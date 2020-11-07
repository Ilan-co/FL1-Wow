import 'dart:io';
import 'package:flutagram/Services/auth.dart';
import 'package:flutagram/Assets/constants.dart';
import 'package:flutagram/Assets/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({this.toggleView});

  final Function toggleView;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  PickedFile profilPicture;

  Future<void> _openGal() async {
    final PickedFile picture =
        await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      profilPicture = picture;
    });
  }

  Future<void> _openCamera() async {
    final PickedFile picture =
        await _imagePicker.getImage(source: ImageSource.camera);
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
        child: const Text(
          'Pas de photo de profil',
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.teal[300],
            appBar: AppBar(
              backgroundColor: Colors.teal,
              elevation: 0.0,
              title: const Text('S\'inscrire'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Se connecter'),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    _displayImage(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                            child: const Text('Camera'),
                            onPressed: () {
                              _openCamera();
                            }),
                        RaisedButton(
                            child: const Text('Galerie'),
                            onPressed: () {
                              _openGal();
                            }),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (String val) =>
                          val.isEmpty ? 'Entrer un email' : null,
                      onChanged: (String val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Mot de passe'),
                      obscureText: true,
                      validator: (String val) => val.length < 6
                          ? 'Entrer un password 6+ charactères'
                          : null,
                      onChanged: (String val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.teal[400],
                        child: const Text(
                          'S\'inscrire',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            final dynamic result =
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
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
