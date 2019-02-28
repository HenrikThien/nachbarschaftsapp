import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchValue = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await SharedPreferences.getInstance().then((prefs) {
      setState(() {
        this.switchValue = prefs.getBool('walkthrough') ?? false;
        print("switchValue = $switchValue");
      });
    });
  }

  void _onSwitchChange(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('walkthrough', value);
  }

  final _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
        title: Text('Einstellungen'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Email'),
            trailing: Text(container.state.user.email),
          ),
          ListTile(
              title: Text("Guthaben Adresse"),
              subtitle: Text("Ihre Adresse für Überweisungen"),
              isThreeLine: true,
              trailing: RaisedButton(
                child: Text('Kopieren!'),
                color: Colors.orangeAccent,
                onPressed: () {
                  Clipboard.setData(new ClipboardData(
                      text: container.state.wallet.credentials.address
                          .toString()));
                  _key.currentState.showSnackBar(new SnackBar(
                    content: new Text("Die Adresse wurde kopiert!"),
                  ));
                },
              )),
          SwitchListTile(
            value: switchValue,
            onChanged: _onSwitchChange,
            title: Text('Tutorial beim Start zeigen'),
          ),
          Divider(),
          ListTile(
            isThreeLine: true,
            title: Text("Backup private key"),
            subtitle: Text(
                'Use this key if you going to use a different smartphone!'),
            trailing: RaisedButton(
              child: Text("Copy private key"),
              color: Colors.orangeAccent,
              onPressed: () {
                Clipboard.setData(new ClipboardData(
                    text: container.state.wallet.credentials.privateKey
                        .toRadixString(16)
                        .toString()));
                _key.currentState.showSnackBar(new SnackBar(
                  content: new Text(
                      "Der private Schlüssel wurde kopiert! Füge ihn nun in deinem neuen Gerät ein!"),
                ));
              },
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
