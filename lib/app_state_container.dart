import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nachbar/models/app_state.dart';
import 'package:nachbar/util/my_wallet.dart';
import 'package:web3dart/web3dart.dart';

class AppStateContainer extends StatefulWidget {
  final AppState state;
  final Widget child;

  AppStateContainer({
    @required this.child,
    this.state,
  });

  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  AppState state;
  FirebaseUser user;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    if (widget.state != null) {
      state = widget.state;
    } else {
      state = AppState.loading(context);
      initUser();
    }
  }

  Future initUser() async {
    await signInUser('', '');
  }

  signOut() async {
    if (state.user != null) {
      await _firebaseAuth.signOut();

      setState(() {
        state.isLoading = false;
        state.user = null;
        state.wallet = null;
      });
    }
  }

  signInUser(String email, String password) async {
    var user = await getCurrentUser();

    if (user != null) {
      var wallet = await getWallet(user.uid);
      var items = await state.getAllUserOffers(user?.uid);

      setState(() {
        state.isLoading = false;
        state.user = user;
        state.wallet = wallet;
        state.offerItems = items;
      });
    }

    if (state.user == null) {
      FirebaseUser user;

      if (email.isNotEmpty && password.isNotEmpty) {
        user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      var wallet = await getWallet(user?.uid);
      var items = await state.getAllUserOffers(user?.uid);

      setState(() {
        state.isLoading = false;
        state.user = user;
        state.wallet = wallet;
        state.offerItems = items;
      });
    }
  }

  Future<Wallet> getWallet(String uid) async {
    var wallet = await MyWallet.readWallet(uid);
    return wallet;
  }

  signUpUser(
      String email, String password, String firstname, String lastname) async {
    try {
      FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserUpdateInfo info = new UserUpdateInfo();
      info.displayName = firstname + ' ' + lastname;

      await user?.updateProfile(info);

      return user?.uid;
    } catch (e) {
      return null;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
