import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutagram/Models/flutagramer.dart';
import 'package:flutagram/Models/user.dart';
import 'package:flutagram/Services/notifications.dart';
import 'package:flutagram/Services/preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as _path;
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  DatabaseService({this.uid});

  final String uid;

  final PreferencesServices _pref = PreferencesServices();
  final NotificationsServices _notif = NotificationsServices();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // collection reference
  final CollectionReference flutagramerCollection =
      Firestore.instance.collection('Flutagramers');

  Future<void> updateUserData(String location, String name) async {
    return await flutagramerCollection.document(uid).setData(<String, dynamic>{
      'token': await _firebaseMessaging.getToken(),
      'uid': uid,
      'location': location,
      'name': name,
      'followers': <String>[''],
      'follows': <String>[''],
    });
  }

  // follow User
  Future<void> followUser(
      String uidToFollow, String token, BuildContext context) async {
    final List<String> uid = <String>[];
    uid.add(await _pref.getUID);
    final List<String> listUidToFollow = <String>[];
    listUidToFollow.add(uidToFollow);
    await flutagramerCollection.document(uidToFollow).updateData(
        <String, FieldValue>{'followers': FieldValue.arrayUnion(uid)});
    await flutagramerCollection
        .document(uid[0])
        .updateData(<String, FieldValue>{
      'follows': FieldValue.arrayUnion(listUidToFollow)
    });
    await _notif.sendNotificationsNewFollower(token);
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      final SnackBar snackBar = SnackBar(
        content: Text(
            "${message['notification']['title']}\n${message['notification']['body']}"),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
    _firebaseMessaging.subscribeToTopic(uidToFollow);
  }

  // Unfollow User
  Future<void> unfollowUser(String uidToFollow) async {
    final List<String> uid = <String>[];
    uid.add(await _pref.getUID);
    final List<String> listUidToFollow = <String>[];
    listUidToFollow.add(uidToFollow);
    await flutagramerCollection.document(uidToFollow).updateData(
        <String, FieldValue>{'followers': FieldValue.arrayRemove(uid)});
    await flutagramerCollection
        .document(uid[0])
        .updateData(<String, FieldValue>{
      'follows': FieldValue.arrayRemove(listUidToFollow)
    });
    _firebaseMessaging.unsubscribeFromTopic(uidToFollow);
  }

  // Upload Profil Picture
  Future<void> uploadProfilPicture(PickedFile picture) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String newName = _path.join(dir, '$uid.png');
    final File f = await File(picture.path).copy(newName);
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilPicture/$uid');
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(f);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (dynamic value) async => await flutagramerCollection
              .document(uid)
              .updateData(<String, dynamic>{'picture': value}),
        );
  }

  // Upload publication to feed
  Future<void> uploadPublication(
      BuildContext context, PickedFile picture, String location) async {
    final String uid = await _pref.getUID;
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String newName = _path.join(dir,
        '$uid-${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}.png');
    final File f = await File(picture.path).copy(newName);
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(
            'feed/$uid-${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}');
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(f);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((dynamic value) async {
      try {
        final List<Map<String, dynamic>> listElement = <Map<String, dynamic>>[];
        listElement.add(<String, dynamic>{
          'image': value,
          'location': location,
        });
        await flutagramerCollection
            .document(uid)
            .updateData(<String, FieldValue>{
          'feedPictures': FieldValue.arrayUnion(listElement)
        });
        Scaffold.of(context)
            .showSnackBar(const SnackBar(content: Text('Publication réussie')));
        _notif.sendNotificationsNewPost();
      } catch (error) {
        Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('Echec de la publication')));
      }
    });
  }

  // Flutagramer list from snapshot
  List<Flutagramer> _flutagramerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map<Flutagramer>((DocumentSnapshot doc) {
      return Flutagramer(
        uid: doc.data['uid'] as String,
        token: doc.data['token'] as String,
        name: doc.data['name'] as String,
        picture: doc.data['picture'] as String,
        location: doc.data['location'] as String ?? 'Non indiqué',
        followers: doc.data['followers'] as List<dynamic>,
      );
    }).toList();
  }

  // Feed list from snapshot
  List<dynamic> _feedListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map<dynamic>((DocumentSnapshot doc) {
      // print(doc.data);
      return doc.data['feedPictures'];
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'] as String,
      location: snapshot.data['location'] as String,
      picture: snapshot.data['picture'] as String,
      followers: snapshot.data['followers'] as List<dynamic>,
      follows: snapshot.data['follows'] as List<dynamic>,
    );
  }

  // get Flutagramers stream
  Stream<List<Flutagramer>> get flutagramers {
    return flutagramerCollection.snapshots().map(_flutagramerListFromSnapshot);
  }

  // get Feed stream
  Stream<List<dynamic>> get feed {
    return flutagramerCollection.snapshots().map(_feedListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return flutagramerCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
