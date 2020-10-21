import 'package:shared_preferences/shared_preferences.dart';

class PreferencesServices {
  void setUID(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("UID", uid);
  }

  Future<String> get getUID async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("UID");
  }

  void deleteUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("UID");
  }
}