import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nachbar/dialogs/image_gallery_form.dart';
import 'package:nachbar/models/offer_item.dart';
import 'package:nachbar/util/fade_text_animation.dart';

typedef OfferItemFormCallback = void Function(OfferItem offerItem);

class FormSelector extends StatefulWidget {
  final OfferItemFormCallback onFormSaved;

  final int selectedForm;
  final dynamic form1Key;

  final TextEditingController form1Title;
  final TextEditingController form1Description;
  final TextEditingController form1Price;
  final List<File> form1Images;

  FormSelector(
      {@required this.selectedForm,
      @required this.form1Key,
      this.onFormSaved,
      this.form1Title,
      this.form1Description,
      this.form1Price,
      this.form1Images});

  @override
  _FormSelectorState createState() => _FormSelectorState();
}

class _FormSelectorState extends State<FormSelector> {
  final _animation1Key = new GlobalKey();
  int _charsCounter = 0;
  List<File> _selectedImages = new List<File>();
  int _imageGalleryIndex = 0;

  /* FORM 2 */
  final _animation2Key = new GlobalKey();
  final _animation3Key = new GlobalKey();

  @override
  void initState() {
    super.initState();

    widget.form1Description.addListener(changeCharCounter);
  }

  void changeCharCounter() {
    setState(() {
      _charsCounter = widget.form1Description.text.length;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedForm == 0) {
      return ShowFadeText(
        key: _animation1Key,
        child: _buildOfferForm(context),
      );
    } else if (widget.selectedForm == 1) {
      return ShowFadeText(
        key: _animation2Key,
        child: _buildOfferHelpForm(context),
      );
    } else {
      return ShowFadeText(
        key: _animation3Key,
        child: _buildSearchHelpForm(context),
      );
    }
  }

  _buildOfferForm(BuildContext context) {
    return Container(
      child: Form(
        key: widget.form1Key,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: widget.form1Title,
              decoration: InputDecoration(
                  labelText: 'Titel',
                  hintText: 'Was möchten Sie verkaufen?',
                  border: OutlineInputBorder()),
              maxLines: 1,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bitte geben Sie einen Titel ein.';
                }
                if (value.length < 5 || value.length > 100) {
                  return 'Der Titel hat nicht die passende Größe.';
                }
              },
            ),
            SizedBox(
              height: 5.0,
            ),
            TextFormField(
              controller: widget.form1Description,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Beschreibung',
                hintText: 'Beschreiben Sie Ihr Produkt ein wenig',
                border: OutlineInputBorder(),
                semanticCounterText: "test",
                counterText: '$_charsCounter/500 Zeichen',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bitte geben Sie eine Beschreibung ein.';
                }
                if (value.length < 10) {
                  return 'Die Beschreibung ist zu kurz.';
                }
                if (value.length > 500) {
                  return 'Die Beschreibung ist zu lang. Es sind max. 500 Zeichen zugelassen.';
                }
              },
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blueGrey,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Bilder auswählen",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.file_upload,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  onPressed: () {
                    getImage(true);
                  },
                ),
                RaisedButton(
                  color: Colors.blueGrey,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Mit Kamera aufnehmen",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  onPressed: () {
                    getImage(false);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: (_selectedImages.length > 0) ? 100 : 0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 100.0,
                    padding: EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _imageGalleryIndex = index);
                        _showImageAlert();
                      },
                      child: Image.file(_selectedImages[index]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: widget.form1Price,
              decoration: InputDecoration(
                hintText: 'Wie viele Punkte möchten Sie dafür erhalten?',
                labelText: 'Kosten',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bitte einen Betrag > 0 eingeben';
                }

                int val = int.parse(value);

                if (val == null) {
                  return 'Der Wert scheint ungültig zu sein';
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageAlert() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ImageGalleryDialog(
            selectedImages: _selectedImages,
            selectedImageIndex: _imageGalleryIndex,
            onImageDelete: (int index) {
              if (_selectedImages.length > 0) {
                setState(() => _selectedImages.removeAt(index));
              }
              if (widget.form1Images.length > 0) {
                setState(() => widget.form1Images.removeAt(index));
              }
            },
          );
        });
  }

  Future getImage(bool gallery) async {
    try {
      var image = await ImagePicker.pickImage(
          source: (gallery) ? ImageSource.gallery : ImageSource.camera);

      setState(() {
        if (image != null) {
          _selectedImages.add(image);
          widget.form1Images.add(image);
        }
      });
    } catch (e) {
      print("Fehler beim öffnen der Gallerie oder der Kamera");
    }
  }

  _buildOfferHelpForm(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Hilfe anbieten Form"),
      ),
    );
  }

  _buildSearchHelpForm(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Hilfe suchen Form"),
      ),
    );
  }
}
