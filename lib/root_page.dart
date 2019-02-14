import 'package:flutter/material.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/home.dart';
import 'package:nachbar/login.dart';
import 'package:nachbar/models/app_state.dart';

class RootPage extends StatefulWidget {
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AppState state;

  Widget _pageToDisplay(var container) {
    if (state.isLoading) {
      return _loadingView;
    } else if (!state.isLoading && state.user == null) {
      return LoginPage();
    } else {
      if (state.user != null) {
        return HomePage();
      }

      return _loadingView;
    }
  }

  Widget get _loadingView {
    return Container(
      color: Colors.orange,
      child: new CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    state = container.state;

    Widget _body = _pageToDisplay(container);
    return _body;
  }
}
