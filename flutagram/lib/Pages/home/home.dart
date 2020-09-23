import 'package:flutagram/Models/flutagramer.dart';
import 'package:flutagram/Pages/home/flutagramer_list.dart';
import 'package:flutagram/Pages/home/settings_form.dart';
import 'package:flutagram/Services/auth.dart';
import 'package:flutagram/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Flutagramer>>.value(
      value: DatabaseService().Flutagramers,
      child: Scaffold(
        backgroundColor: Colors.teal[300],
        appBar: AppBar(
          title: Text('Flutagram'),
          backgroundColor: Colors.teal,
          elevation: 0.0,
          titleSpacing: 5.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Se déconnecter'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text('Profil'),
              onPressed: () => _showSettingsPanel(),
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/coffee_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: FlutagramerList()),
      ),
    );
  }
}
