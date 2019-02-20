import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/dialogs/dialog_forms.dart';
import 'package:nachbar/models/offer_item.dart';
import 'package:nachbar/util/fade_text_animation.dart';
import 'package:path/path.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateNewServiceDialog extends StatefulWidget {
  _CreateNewServiceDialogState createState() => _CreateNewServiceDialogState();
}

class _CreateNewServiceDialogState extends State<CreateNewServiceDialog>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  TabController _tabController;

  IconData _fabIcon;
  dynamic _fabText;

  String qrCodeText = 'Noch nichts gescannt';

  var _form1Key = new GlobalKey<FormState>();

  /* form 1 */
  int _radioValue = 0;

  /* form 1_a */
  TextEditingController _titleCtrl;
  TextEditingController _descCtrl;
  TextEditingController _priceCtrl;
  List<File> _imageFiles;

  @override
  void initState() {
    super.initState();

    setState(() {
      _fabIcon = Icons.add;
      _fabText = new ShowFadeText(
          key: UniqueKey(),
          child: new Text(
            "Jetzt erstellen",
            style: TextStyle(color: Colors.white),
          ));
    });

    _titleCtrl = new TextEditingController();
    _descCtrl = new TextEditingController();
    _priceCtrl = new TextEditingController();
    _imageFiles = new List<File>();

    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_onTabChangesListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _imageFiles.clear();
    super.dispose();
  }

  _onTabChangesListener() {
    if (_tabController.index == 0) {
      setState(() {
        _fabIcon = Icons.add;
        _fabText = new ShowFadeText(
            key: UniqueKey(),
            child: new Text(
              "Jetzt erstellen",
              style: TextStyle(color: Colors.white),
            ));
      });
    } else if (_tabController.index == 1) {
      setState(() {
        _fabIcon = Icons.attach_money;
        _fabText = new ShowFadeText(
          key: UniqueKey(),
          child: Text(
            "Jetzt bezahlen",
            style: TextStyle(color: Colors.white),
          ),
          delay: 0,
        );
      });
    } else {
      setState(() {
        _fabIcon = Icons.add;
        _fabText = new ShowFadeText(
            key: UniqueKey(),
            child: Text(
              "Jetzt senden",
              style: TextStyle(color: Colors.white),
            ));
      });
    }
  }

  Widget _showCircularProgress(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: EdgeInsets.all(15.0),
        height: MediaQuery.of(context).size.height,
        color: Colors.white70.withOpacity(0.9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 25.0,
              ),
              Text(
                'Bitte warten, Ihr Angebot wird erstellt und die Bilder werden verarbeitet..',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
        title: Text('Optionen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text(
                'Neues Angebot',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Bezahlen',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
                child: Text(
              'Punkte senden',
              style: TextStyle(color: Colors.white),
            )),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          TabBarView(
            controller: _tabController,
            children: <Widget>[
              _buildNewOfferTab(context),
              _buildPaymentTab(context),
              _buildSendPointsTab(context),
            ],
          ),
          _showCircularProgress(context)
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: _fabText,
        icon: Icon(
          _fabIcon,
          color: Colors.white,
        ),
        onPressed: () async {
          // prevent double pressing
          if (isLoading) {
            return;
          }
          if (_tabController.index == 0) {
            setState(() {
              print("hier true");
              isLoading = true;
            });
            if (_form1Key.currentState.validate()) {
              _form1Key.currentState.save();

              var ref =
                  FirebaseDatabase.instance.reference().child('offer_items');

              var item = ref.child(container.state.user.uid).push();

              var ownerUid = container.state.user.uid;

              await item.set({
                'title': _titleCtrl.text,
                'description': _descCtrl.text,
                'images': '',
                'price': _priceCtrl.text,
                'ownerUid': '',
              }).then((_) async {
                await _uploadImages(item.key, _imageFiles).then((links) async {
                  setState(() {
                    isLoading = false;
                  });

                  await item.set({
                    'title': _titleCtrl.text,
                    'description': _descCtrl.text,
                    'images': links,
                    'price': _priceCtrl.text,
                    'ownerUid': ownerUid
                  });

                  OfferItem newItem = new OfferItem(
                    itemId: item.key,
                    ownerUid: ownerUid,
                    title: _titleCtrl.text,
                    description: _descCtrl.text,
                    images: links,
                    price: _priceCtrl.text,
                  );

                  var container = AppStateContainer.of(context);
                  setState(() => container.state.offerItems.add(newItem));

                  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text('Das Angebot wurde erstellt.'),
                  ));

                  Navigator.pop(context);
                });
              });
            } else {
              setState(() {
                print("hier false!");
                isLoading = false;
              });
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text('Das Angebot konnte nicht erstellt werden.'),
              ));
            }
          } else if (_tabController.index == 1) {
          } else {}
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future _uploadImages(String productId, List<File> images) async {
    List<String> imageLinks = new List<String>();

    var c = new Completer<List<String>>();

    var i = 0;

    images.forEach((element) async {
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child(productId)
          .child(basename(element.path));

      StorageUploadTask uploadTask = ref.putFile(element);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      imageLinks.add(url);

      if (i == images.length - 1) {
        c.complete(imageLinks);
      }

      i++;
    });

    return c.future;
  }

  _buildNewOfferTab(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Angebot erstellen",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Erstellen Sie hier passende Angebote. Sie können Gegenstände anbieten oder Ihre persönliche Hilfe. Vielleicht möchten Sie auch ein Suchangebot schreiben?",
            style: TextStyle(color: Colors.grey.shade500),
          ),
          SizedBox(
            height: 25.0,
          ),
          Text("Bitte wählen Sie die passende Option aus"),
          Row(
            children: <Widget>[
              Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: _onRadioChanged,
              ),
              Flexible(
                child: Text("Verkaufen"),
              ),
              Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: _onRadioChanged,
              ),
              Flexible(
                child: Text("Hilfe anbieten"),
              ),
              Radio(
                value: 2,
                groupValue: _radioValue,
                onChanged: _onRadioChanged,
              ),
              Flexible(
                child: Text("Hilfe suchen"),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          FormSelector(
            selectedForm: _radioValue,
            form1Key: _form1Key,
            form1Title: _titleCtrl,
            form1Description: _descCtrl,
            form1Images: _imageFiles,
            form1Price: _priceCtrl,
          ),
        ],
      )),
    );
  }

  void _onRadioChanged(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  _buildPaymentTab(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text("Hier ein test qr code einfügen"),
          RaisedButton(
            child: Text("QR Code Scannen"),
            color: Colors.orangeAccent,
            onPressed: () async {
              var scan = await _openQrCodeScanner(context);
              print(scan);
              setState(() {
                qrCodeText = scan;
              });
            },
          ),
          Text((qrCodeText != null) ? qrCodeText : ''),
        ],
      ),
    );
  }

  Future<String> _openQrCodeScanner(BuildContext context) async {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;

    if (isAndroid) {
      try {
        Future<String> futureString = new QRCodeReader()
            .setAutoFocusIntervalInMs(200) // default 5000
            .setForceAutoFocus(true) // default false
            .setTorchEnabled(true) // default false
            .setHandlePermissions(true) // default true
            .setExecuteAfterPermissionGranted(true) // default true
            .scan();

        return futureString;
      } catch (e) {
        return null;
      }
    } else {
      try {
        Future<String> futureString = new QRCodeReader().scan();
        return futureString;
      } catch (e) {
        return null;
      }
    }
  }

  _buildSendPointsTab(BuildContext context) {
    return Container();
  }
}
