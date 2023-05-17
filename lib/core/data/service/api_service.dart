import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_appwrite_starter/core/res/constants.dart';

class ApiService {
  final Client client = Client();
  Account? account;
  Databases? db;
  late Avatars avatars;
  late Storage storage;
  static ApiService? _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    account = Account(client);
    db = Databases(client);
    avatars = Avatars(client);
    storage = Storage(client);
  }

  static ApiService get instance {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  Future<Uint8List> getAvatar(String name) async {
    final res = await avatars.getInitials(
      name: name,
    );
    return res;
  }

  Future<Uint8List> getImageAvatar(String bucketId, String fileId) async {
    final res = await storage.getFilePreview(bucketId: bucketId, fileId: fileId, width: 100);
    return res;
  }

  Future<models.File> uploadFile(
    String bucketId,
    InputFile file, {
    List<String> permissions = const []
  }) {
    return storage.createFile(
      bucketId: bucketId,
        fileId: 'unique()', file: file, permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.any()),
        ]);
  }
}
