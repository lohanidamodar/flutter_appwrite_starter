import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CropScreen extends StatelessWidget {
  static String name = 'crop_image';
  final Uint8List? image;
  final CropController _controller = CropController();

  CropScreen({super.key, this.image});

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
            context.pop(image);
          },
          image: image!),
    );
  }
}
