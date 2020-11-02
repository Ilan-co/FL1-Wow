import 'package:shared_preferences/shared_preferences.dart';

class PreferencesServices {
  Future<void> setUID(String uid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UID', uid);
  }

  Future<String> get getUID async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UID');
  }

  Future<void> deleteUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('UID');
  }
}