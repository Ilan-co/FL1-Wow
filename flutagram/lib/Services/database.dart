import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutagram/Models/flutagramer.dart';
import 'package:flutagram/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference FlutagramerCollection =
      Firestore.instance.collection('Flutagramers');

  Future<void> updateUserData(String location, String name) async {
    return await FlutagramerCollection.document(uid).setData({
      'location': location,
      'name': name
    });
  }

  Future<void> uploadProfilPicture(PickedFile picture) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String newName = Path.join(dir, '$uid.png');
    File f = await File(picture.path).copy(newName);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilPicture/$uid');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(f);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) async => await FlutagramerCollection.document(uid)
              .updateData({'picture': value}),
        );
  }

  // Flutagramer list from snapshot
  List<Flutagramer> _FlutagramerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Flutagramer(
          name: doc.data['name'],
          picture: doc.data['picture'],
          location: doc.data['location'] ?? 'Non indiqué');
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        location: snapshot.data['location'],
        picture: snapshot.data['picture']);
  }

  // get Flutagramers stream
  Stream<List<Flutagramer>> get Flutagramers {
    return FlutagramerCollection.snapshots().map(_FlutagramerListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return FlutagramerCollection.document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
