import 'package:flutter/material.dart';

class WalkthroughPageNew extends StatefulWidget {
  _WalkthroughPageNewState createState() => _WalkthroughPageNewState();
}

class _WalkthroughPageNewState extends State<WalkthroughPageNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.orange,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('PLACEHOLDER TITLE'),
              Text('placeholder description'),
              Icon(Icons.location_on),
            ],
          ),
        ),
      ),
    );
  }
}
