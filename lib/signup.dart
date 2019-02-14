import 'package:flutter/material.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/util/my_wallet.dart';

import 'dart:io';
import 'dart:math';
import 'package:web3dart/web3dart.dart';

class SignupPage extends StatefulWidget {
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = new GlobalKey<FormState>();
  final _passCtrl = new TextEditingController();

  File _localWallet;

  bool _isLoading = false;
  bool _isIos = false;

  String _errorMessage;

  String _email;
  String _firstname;
  String _lastname;
  String _password;
  String _passwordRepeat;

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white70.withOpacity(0.8),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  _validateAndSubmit(var container) async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    if (_validateAndSave()) {
      try {
        var uid = await container.signUpUser(
            _email, _password, _firstname, _lastname);

        var wallet = await MyWallet.createNewWallet(uid);

        setState(() {
          _isLoading = false;
        });

        if (uid == null) {
          //fehler anzeigen
        } else {
          Navigator.pop(context, true);
        }
      } catch (e) {
        print("Sign in error: $e");
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else {
            _errorMessage = e.message;
          }
          _neverSatisfied();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fehler'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(this._errorMessage)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Verstanden'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Nachbarschaftshilfe",
            style: TextStyle(
              fontSize: 25.0,
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 50.0, left: 20.0, right: 20.0, bottom: 20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Registrieren Sie sich kostenlos und erhalten 20 Socialpoints dazu!",
                            style: TextStyle(fontSize: 17.0),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                              "Laden Sie Ihre Freunde/Verwandten ein und erhalten weitere Socialpoints pro Anmeldung dazu!"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(left: 35.0, right: 35.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Registrieren',
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 28.0)),
                            SizedBox(
                              height: 50.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'E-Mail Adresse',
                                hintText:
                                    'Bitte geben Sie eine E-Mail Adresse ein',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Dieses Feld darf nicht leer bleiben';
                                }
                                if (!isEmail(value)) {
                                  return 'Diese Email darf nicht verwendet werden!';
                                }
                              },
                              onSaved: (value) => _email = value,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Vorname',
                                hintText: 'Bitte geben Sie Ihren Vornamen ein',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Dieses Feld darf nicht leer bleiben';
                                }
                              },
                              onSaved: (value) => _firstname = value,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nachname',
                                hintText: 'Bitte geben Sie Ihren Nachnamen ein',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Dieses Feld darf nicht leer bleiben';
                                }
                              },
                              onSaved: (value) => _lastname = value,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextFormField(
                              controller: _passCtrl,
                              decoration: InputDecoration(
                                labelText: 'Passwort',
                                hintText:
                                    'Bitte geben Sie ein sicheres Passwort ein',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Sie müssen ein Passwort bestimmen';
                                }
                                if (value.length < 6) {
                                  return 'Ihr Passwort sollte mind. 6 Zeichen beinhalten.';
                                }
                              },
                              onSaved: (value) => _password = value,
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Passwort wiederholen',
                                hintText: 'Wiederholen Sie Ihr Passwort',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Bitte wiederholen Sie das Passwort';
                                }
                                if (value != _passCtrl.text) {
                                  return 'Ihre Passwörter stimmen nicht überein';
                                }
                              },
                              onSaved: (value) => _passwordRepeat = value,
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            RaisedButton(
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Registrieren',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17.0),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              onPressed: () {
                                _validateAndSubmit(container);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }
}
