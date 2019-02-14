import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/login.dart';
import 'package:nachbar/root_page.dart';

void main() => runApp(AppStateContainer(
  child: MyApp(),
));

class MyApp extends StatelessWidget {
  MyApp() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nachbarschaftshilfe',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange,
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          title: TextStyle(fontSize: 22.0, color: Colors.white),
          body1: TextStyle(fontSize: 14.0),
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context) => RootPage(),
        '/login': (BuildContext context) => LoginPage(),
      },
    );
  }
}