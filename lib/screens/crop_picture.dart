import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropPicturePage extends StatefulWidget {
  final File imageFile;

  const CropPicturePage({
    Key key,
    @required this.imageFile,
  }) : super(key: key);

  @override
  CropPicturePageState createState() => CropPicturePageState();
}

class CropPicturePageState extends State<CropPicturePage> {
  final cropKey = GlobalKey<CropState>();

  Widget _buildCropImage() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(12.0),
      child: Crop(key: cropKey, image: FileImage(widget.imageFile)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(title: Text('Crop your photo'), actions: <Widget>[
      IconButton(
          icon: Icon(Icons.done),
          onPressed: () async {
            final crop = cropKey.currentState;
            File croppedImage = await ImageCrop.cropImage(
              file: widget.imageFile,
              area: crop.area,
            );

            Navigator.pop(context, croppedImage);
          })
    ]);

    return Scaffold(appBar: topAppBar, body: _buildCropImage());
  }
}
