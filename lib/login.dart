import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/signup.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  bool _isLoading = false;
  bool _successSignedUp = false;

  String _errorMessage = '';

  String _email = '';
  String _password = '';

  bool _isIos;

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
        await container.signInUser(_email, _password);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print("Sign in error: $e");
        setState(() {
          _isLoading = false;
        });
        if (_isIos) {
          _errorMessage = e.details;
        } else {
          _errorMessage = e.message;
        }
        _neverSatisfied();
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
              children: <Widget>[
                Text((this._errorMessage != null)
                    ? this._errorMessage
                    : 'Ein Fehler ist aufgetreten'),
              ],
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

  _buildRegistrationMessage() {
    if (_successSignedUp) {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                  'Erfolgreich registriert! Sie können sich nun Anmelden.',
                  softWrap: true),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
        ],
      );
    }

    return SizedBox(
      height: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    var container = AppStateContainer.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text("Nachbarschaftshilfe",
                style: TextStyle(
                  fontSize: 25.0,
                ))),
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
                  top: 30.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.2),
                    child: Text(
                      'Melden Sie sich heute noch kostenlos an und werden Teil des echten Sozialen Netzwerkes. Tauschen/Verkaufen Sie Gegenstände in Ihrer Region.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Melden Sie sich an um fortzufahren.',
                    style: TextStyle(color: Colors.black45),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 50.0, left: 35.0, right: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildRegistrationMessage(),
                        Text('Anmelden',
                            style: TextStyle(
                                color: Colors.orangeAccent, fontSize: 28.0)),
                        SizedBox(
                          height: 25.0,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Geben Sie Ihre E-mail Adresse ein',
                                  labelText: 'E-mail Adresse',
                                  icon: Icon(Icons.email, color: Colors.orange),
                                ),
                                maxLines: 1,
                                keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                validator: (value) => ((value.isEmpty
                                    ? 'Bitte geben Sie eine Email ein.'
                                    : null)),
                                onSaved: (value) => _email = value,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Geben Sie Ihr Passwort ein',
                                  labelText: 'Passwort',
                                  icon: (Icon(Icons.vpn_key,
                                      color: Colors.orange)),
                                ),
                                obscureText: true,
                                maxLines: 1,
                                autofocus: false,
                                validator: (value) => value.isEmpty
                                    ? 'Bitte geben Sie ein Passwort ein.'
                                    : null,
                                onSaved: (value) => _password = value,
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              RaisedButton(
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Anmelden',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0),
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
                        Divider(
                          height: 100.0,
                          color: Colors.orange[300],
                        ),
                        Text('Noch keinen Account?'),
                        FlatButton(
                          child: Text(
                            'Melden Sie sich kostenlos an!',
                            style:
                                TextStyle(color: Colors.orange, fontSize: 18.0),
                          ),
                          onPressed: () async {
                            var success = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(),
                                ));

                            setState(() {
                              if (success == null) success = false;

                              _successSignedUp = success;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }
}
