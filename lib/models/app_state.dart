import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nachbar/models/app_location.dart';
import 'package:nachbar/models/offer_item.dart';
import 'package:web3dart/web3dart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class AppState {
  bool isLoading;
  bool showWalkthroughPage;

  FirebaseUser user;
  DatabaseReference database;
  Wallet wallet;
  AppLocation location;

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

  Future<AppLocation> loadCurrentLocation() async {
    try {
      var currentPosition = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      final coordinates =
          new Coordinates(currentPosition.latitude, currentPosition.longitude);
      var addr = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addr.first;

      return new AppLocation(
          location: first.locality,
          postalcode: first.postalCode,
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude);
    } catch (e) {
      print(e.toString());
      return new AppLocation(
        location: 'Unkown',
        postalcode: '',
      );
    }
  }

  Future<List<OfferItem>> getAllUserOffers(String uid) async {
    List<OfferItem> items = new List<OfferItem>();

    try {
      await FirebaseDatabase.instance
          .reference()
          .child("offer_items")
          .child(uid)
          .once()
          .then((DataSnapshot snapshot) {
        //String key = snapshot.key;
        Map<dynamic, dynamic> snapMap = snapshot.value;

        snapMap.forEach((key, value) {
          OfferItem item = OfferItem.fromSnapshot(key.toString(), value);
          items.add(item);
        });
      });
    } catch (e) {
      print(" exception...");
      print(e.toString());
    }

    return items;
  }
}
