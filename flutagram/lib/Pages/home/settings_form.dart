import 'package:flutagram/Assets/loading.dart';
import 'package:flutagram/Models/user.dart';
import 'package:flutagram/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  Text(userData.name ?? 'Non indiqué'),
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
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
