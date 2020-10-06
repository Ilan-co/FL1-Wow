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
  final _formKey = GlobalKey<FormState>();

  // form values
  String _currentName;
  String _currentLocation;
  String _currentPicture;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Modifier son profil',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    validator: (val) => val.isEmpty ? 'Entrer un nom' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                      color: Colors.teal[400],
                      child: Text(
                        'Mettre à jour',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                              _currentLocation ?? snapshot.data.location,
                              _currentName ?? snapshot.data.name,
                              _currentPicture ?? snapshot.data.picture);
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
