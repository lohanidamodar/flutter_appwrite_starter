import 'dart:typed_data';

typedef GotoCropPageCallback = Future<Uint8List?> Function(Uint8List);
typedef CropImageCallback = void Function(Uint8List);
