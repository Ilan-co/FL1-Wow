import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutagram/Models/user.dart';
import 'package:flutagram/Services/database.dart';
import 'package:flutagram/Services/geo.dart';
import 'package:flutagram/Services/preferences.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PreferencesServices _pref = PreferencesServices();
  final GeoService _geo = GeoService();

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
  Future<User> signInAnon() async {
    try {
      final AuthResult result = await _auth.signInAnonymously();
      final FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser user = result.user;
      _pref.setUID(user.uid);
      return user;
    } catch (error) {
      print('Sign In Error : ' + error.toString());
      return null;
    }
  }

  // register with email and password
  Future<User> registerWithEmailAndPassword(
      String email, String password, PickedFile profilPicture) async {
    try {
      final AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser user = result.user;
      final String location = await _geo.getPos();
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(location, email);
      await DatabaseService(uid: user.uid).uploadProfilPicture(profilPicture);
      _pref.setUID(user.uid);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print('Register Error : ' + error.toString());
      return null;
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      _userFromFirebaseUser(null);
      _pref.deleteUID();
      return await _auth.signOut();
    } catch (error) {
      print('Sign Out Error : ' + error.toString());
    }
  }
}
