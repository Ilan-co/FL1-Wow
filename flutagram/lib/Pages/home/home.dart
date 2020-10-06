import 'package:flutagram/Models/flutagramer.dart';
import 'package:flutagram/Pages/home/flutagramer_list.dart';
import 'package:flutagram/Pages/home/settings_form.dart';
import 'package:flutagram/Services/auth.dart';
import 'package:flutagram/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;
  final List<Widget> _children = [
    FlutagramerList(),
    Text("Photo view"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBar _setupNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          title: Text('Flutagrammers'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_a_photo),
          title: Text('Prendre une photo'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal,
      onTap: _onItemTapped,
    );
  }

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
        body: _children[_selectedIndex],
        bottomNavigationBar: _setupNavigationBar(),
      ),
    );
  }
}
