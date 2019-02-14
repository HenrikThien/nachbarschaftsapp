import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

typedef IndexCallback = void Function(int);

class ImageGalleryDialog extends StatefulWidget {
  final List<File> selectedImages;
  final int selectedImageIndex;
  final IndexCallback onImageDelete;

  ImageGalleryDialog(
      {@required this.selectedImages,
      @required this.selectedImageIndex,
      this.onImageDelete});

  @override
  _ImageGalleryDialogState createState() => _ImageGalleryDialogState();
}

class _ImageGalleryDialogState extends State<ImageGalleryDialog> {
  int _imageGalleryIndex = 0;

  @override
  void initState() {
    _imageGalleryIndex = widget.selectedImageIndex;
    super.initState();
  }

  @override
  void dispose() {
    //widget.selectedImages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: UniqueKey(),
      content: SwipeDetector(
        onSwipeRight: () {
          if (_imageGalleryIndex == 0) {
            return;
          }
          setState(() => _imageGalleryIndex--);
        },
        onSwipeLeft: () {
          if (_imageGalleryIndex == widget.selectedImages.length - 1) {
            return;
          }
          setState(() => _imageGalleryIndex++);
        },
        child: Container(
          child: (widget.selectedImages.length > 0)
              ? Image.file(widget.selectedImages[_imageGalleryIndex])
              : Text("Bild nicht gefunden."),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Löschen',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              if (widget.selectedImages.length > 0) {
                widget.selectedImages.removeAt(_imageGalleryIndex);
              }
            });
            widget.onImageDelete(_imageGalleryIndex);
            print("Ich bin im onPressed event ($_imageGalleryIndex)");
          },
        ),
        FlatButton(
          child: Text('Fertig'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
