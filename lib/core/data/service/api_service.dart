import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_appwrite_starter/core/res/constants.dart';

class ApiService {
  final Client client = Client();
  Account? account;
  Database? db;
  late Avatars avatars;
  late Storage storage;
  static ApiService? _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    account = Account(client);
    db = Database(client);
    avatars = Avatars(client);
    storage = Storage(client);
  }

  static ApiService get instance {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance!;
  }

  Future<Uint8List> getAvatar(String name) async {
    final res = await avatars.getInitials(
      name: name,
    );
    return res.data;
  }

  Future<Uint8List> getImageAvatar(String fileId) async {
    final res = await storage.getFilePreview(fileId: fileId, width: 100);
    return res.data;
  }

  Future uploadFile(
    MultipartFile file, {
    List<String> read = const ["*"],
    List<String> write = const ['*'],
  }) {
    return storage.createFile(file: file, read: read, write: write);
  }
}
