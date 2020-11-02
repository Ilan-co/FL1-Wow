import 'package:flutagram/Services/auth.dart';
import 'package:flutagram/Assets/constants.dart';
import 'package:flutagram/Assets/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({this.toggleView});
  final Function toggleView;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal[300],
            appBar: AppBar(
              backgroundColor: Colors.teal,
              elevation: 0.0,
              title: const Text('Se connecter'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('S\'inscrire'),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
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
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Mot de passe'),
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
                          'Se connecter',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            final dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error =
                                    'Impossible de se connecter avec ces identifiants';
                              });
                            }
                          }
                        }),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
