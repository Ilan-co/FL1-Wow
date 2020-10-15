import 'package:flutagram/Models/user.dart';
import 'package:flutagram/Services/database.dart';
import 'package:flutagram/Services/geo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _geo = GeoService();

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("UID", user.uid);
      print(user.uid);
      return user;
    } catch (error) {
      print("Sign In Error : " + error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, PickedFile profilPicture) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      String location = await _geo.getPos();
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(location, email);
      await DatabaseService(uid: user.uid).uploadProfilPicture(profilPicture);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("UID", user.uid);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print("Register Error : " + error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      _userFromFirebaseUser(null);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("UID");
      return await _auth.signOut();
    } catch (error) {
      print("Sign Out Error : " + error.toString());
      return null;
    }
  }
}
