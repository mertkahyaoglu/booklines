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
      padding: const EdgeInsets.all(20.0),
      child: Crop(
        key: cropKey,
        image: FileImage(widget.imageFile)
      ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a photo')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: _buildCropImage()

    );
  }
}
