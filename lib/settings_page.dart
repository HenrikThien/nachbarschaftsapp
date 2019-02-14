import 'package:flutter/material.dart';
import 'package:nachbar/app_state_container.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    return Scaffold(
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
            trailing:
                Text(container.state.wallet.credentials.address.toString()),
          ),
        ],
      ),
    );
  }
}
