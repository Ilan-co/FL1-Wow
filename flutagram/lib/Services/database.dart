import 'package:flutagram/Models/flutagramer.dart';
import 'package:flutagram/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference FlutagramerCollection =
      Firestore.instance.collection('Flutagramers');

  Future<void> updateUserData(
      String location, String name, String picture) async {
    return await FlutagramerCollection.document(uid).setData({
      'location': location,
      'name': name,
      'picture': picture,
    });
  }

  // Flutagramer list from snapshot
  List<Flutagramer> _FlutagramerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Flutagramer(
          name: doc.data['name'] ?? '',
          picture: doc.data['picture'] ?? "0",
          location: doc.data['location'] ?? '0');
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
