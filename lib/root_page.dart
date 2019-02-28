import 'package:flutter/material.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/home.dart';
import 'package:nachbar/import_page.dart';
import 'package:nachbar/login.dart';
import 'dart:async';
import 'package:nachbar/models/app_state.dart';
import 'package:nachbar/walkthrough.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatefulWidget {
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AppState state;
  bool showWalkthroughPage;

  @override
  void initState() {
    super.initState();
    //requestPermissions();
    loadPreferences();
  }

  void requestPermissions() async {
    bool denied = false;

    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
            [PermissionGroup.location, PermissionGroup.camera]);

    permissions.forEach((key, value) {
      if (value == PermissionStatus.denied) {
        denied = true;
      }
    });
    // SHOW error page, need these permissions!
  }

  Future loadPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    final showWalkthrough = prefs.getBool('walkthrough') ?? true;
    setState(() => this.showWalkthroughPage = showWalkthrough);
  }

  Widget _pageToDisplay(var container) {
    if (state.isLoading) {
      return _loadingView;
    } else if (!state.isLoading && state.user == null) {
      return LoginPage();
    } else {
      if (state.user != null) {
        if (state.wallet == null) {
          return ImportPage();
        } else {
          if (state.showWalkthroughPage) {
            loadPreferences();

            return WalkthroughPage(
              onPageClose: () {
                setState(() {
                  state.showWalkthroughPage = false;
                });
              },
            );
          }
        }

        return HomePage();
      }

      return _loadingView;
    }
  }

  Widget get _loadingView {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/image-loading.gif',
                color: Colors.white,
              ),
              SizedBox(height: 10.0),
              Text(
                "Lade Daten aus der Cloud...",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              SizedBox(height: 5.0),
              Text(
                "(Stelle sicher dass du eine Internetverbindugn hast!)",
                style: TextStyle(color: Colors.white, fontSize: 13.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    state = container.state;
    state.showWalkthroughPage = this.showWalkthroughPage;
    return _pageToDisplay(container);
  }
}
