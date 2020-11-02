import 'package:flutagram/Models/user.dart';
import 'package:flutagram/Services/database.dart';
import 'package:flutagram/Assets/constants.dart';
import 'package:flutagram/Assets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // form values
  String _currentName;
  String _currentLocation;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
          if (snapshot.hasData) {
            final UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.teal,
                    backgroundImage: userData.picture != null
                        ? NetworkImage(userData.picture)
                        : null,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Text('Abonnements'),
                          Text(userData.follows != null
                              ? userData.follows.length.toString()
                              : '0'),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text('Abonnés'),
                          Text(userData.followers != null
                              ? userData.followers.length.toString()
                              : '0'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Modifier son profil',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    validator: (String val) => val.isEmpty ? 'Entrer un nom' : null,
                    onChanged: (String val) => setState(() => _currentName = val),
                  ),
                  const SizedBox(height: 10.0),
                  RaisedButton(
                    color: Colors.teal[400],
                    child: const Text(
                      'Mettre à jour',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentLocation ?? snapshot.data.location,
                          _currentName ?? snapshot.data.name,
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
