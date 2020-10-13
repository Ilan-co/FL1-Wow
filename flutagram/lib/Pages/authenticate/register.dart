import 'dart:io';
import 'package:flutagram/Services/auth.dart';
import 'package:flutagram/Assets/constants.dart';
import 'package:flutagram/Assets/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  PickedFile profilPicture;

  void _openGal() async {
    var picture = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      profilPicture = picture;
    });
  }

  void _openCamera() async {
    var picture = await _imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      profilPicture = picture;
    });
  }

  Widget _displayImage() {
    if (profilPicture != null) {
      return CircleAvatar(
        backgroundImage: FileImage(File(profilPicture.path)),
        radius: 80,
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.teal[700],
        child: Text(
          "Pas de photo de profil",
          style: TextStyle(color: Colors.white),
        ),
        radius: 80,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal[300],
            appBar: AppBar(
              backgroundColor: Colors.teal,
              elevation: 0.0,
              title: Text('S\'inscrire'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Se connecter'),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    _displayImage(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                            child: Text("Camera"),
                            onPressed: () {
                              _openCamera();
                            }),
                        RaisedButton(
                            child: Text("Galerie"),
                            onPressed: () {
                              _openGal();
                            }),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) =>
                          val.isEmpty ? 'Entrer un email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Mot de passe'),
                      obscureText: true,
                      validator: (val) => val.length < 6
                          ? 'Entrer un password 6+ charactères'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.teal[400],
                        child: Text(
                          'S\'inscrire',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    email, password, profilPicture);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Email invalide';
                              });
                            }
                          }
                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
