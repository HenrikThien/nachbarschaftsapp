import 'package:flutter/material.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/util/my_wallet.dart';

class ImportPage extends StatefulWidget {
  ImportPage({Key key}) : super(key: key);

  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final GlobalKey<FormState> _formkey = new GlobalKey();
  final TextEditingController _keyController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Guthabenschlüssel importieren',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Text(
              'Account wiederherstellen',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Icon(
              Icons.vpn_key,
              size: MediaQuery.of(context).size.height * 0.1,
              color: Colors.orange,
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
                'Uupss....Es sieht so aus als würdest du dich auf diesem Gerät zum ersten Mal anmelden! Bitte benutze den Accountschlüssel von deinem aktuellem Gerät um fortzufahren!'),
            SizedBox(
              height: 50.0,
            ),
            Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _keyController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Account Schlüssel',
                        hintText: 'Bitte geben hier den Schlüssel ein!'),
                    validator: (v) {
                      if (v.isEmpty) {
                        return 'Bitte gebe den Schlüssel ein.';
                      }
                      if (v.length < 50) {
                        return 'Diese Schlüssellänge ist nicht zulässig!';
                      }
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  OutlineButton(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Importieren!'),
                    ),
                    highlightedBorderColor: Colors.orange,
                    highlightColor: Colors.orangeAccent,
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        var wallet = await MyWallet.importWallet(
                            _keyController.text,
                            container.state.user.uid.toString());
                        if (wallet == null) {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text(
                                "Ein Fehler ist aufgetreten, der Schlüssel oder das Passwort scheinen nicht korrekt zu sein!"),
                          ));
                        } else {
                          setState(() {
                            container.state.wallet = wallet;
                          });
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
