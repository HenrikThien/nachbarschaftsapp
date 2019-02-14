import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nachbar/models/offer_item.dart';
import 'package:web3dart/web3dart.dart';

class AppState {
  bool isLoading;
  FirebaseUser user;
  DatabaseReference database;
  Wallet wallet;

  List<OfferItem> offerItems;

  BuildContext context;

  AppState(
      BuildContext context, bool isLoading, FirebaseUser user, Wallet wallet) {
    this.context = context;
    this.isLoading = isLoading;
    this.user = user;
    this.wallet = wallet;
    this.offerItems = new List<OfferItem>();
  }

  factory AppState.loading(BuildContext context) =>
      new AppState(context, true, null, null);

  Future<List<OfferItem>> getAllUserOffers(String uid) async {
    List<OfferItem> items = new List<OfferItem>();

    try {
      await FirebaseDatabase.instance
          .reference()
          .child("offer_items")
          .child(uid)
          .once()
          .then((DataSnapshot snapshot) {
        String key = snapshot.key;
        Map<dynamic, dynamic> snapMap = snapshot.value;

        snapMap.forEach((key, value) {
          OfferItem item = OfferItem.fromSnapshot(key.toString(), value);
          items.add(item);
        });
      });
    } catch (e) {
      print("wieder eine kack exception...");
      print(e.toString());
    }

    return items;
  }
}
