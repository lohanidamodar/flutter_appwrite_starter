import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropPage extends StatelessWidget {
  final Uint8List? image;
  final CropController _controller = CropController();

  CropPage({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop'),
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                _controller.crop();
              })
        ],
      ),
      body: Crop(
          controller: _controller,
          aspectRatio: 1,
          onCropped: (image) {
            Navigator.pop(context, image);
          },
          image: image!),
    );
  }
}
