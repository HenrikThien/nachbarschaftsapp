import 'package:flutter/material.dart';
import 'dart:ui';

class AllItemsPage extends StatefulWidget {
  _AllItemsPageState createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0.0,
        title: Text('Meine Angebote', style: Theme.of(context).textTheme.title),
      ),
      body: Container(
        color: Colors.orange,
        padding: EdgeInsets.all(15.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(100, (index) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0)),
                child: Center(
                  child: Text("Rolex"),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
