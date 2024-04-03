import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../app/app_constants.dart';

class Appwrite {
  Client client = Client();
  late final Account account;
  late final Avatars avatars;
  late final Storage storage;
  Appwrite() {
    client.setEndpoint(AppConstants.endpoint).setProject(
          AppConstants.projectId,
        ); // For self signed certificates, only use for development
    account = Account(client);
    avatars = Avatars(client);
    storage = Storage(client);
  }

  Future<Uint8List> getAvatar(String name) async {
    final res = await avatars.getInitials(
      name: name,
    );
    return res;
  }

  Future<Uint8List> getImageAvatar(String bucketId, String fileId) async {
    final res = await storage.getFilePreview(
        bucketId: bucketId, fileId: fileId, width: 100);
    return res;
  }

  Future<File> uploadFile(String bucketId, InputFile file,
      {List<String> permissions = const []}) {
    return storage.createFile(
        bucketId: bucketId,
        fileId: 'unique()',
        file: file,
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.any()),
        ]);
  }
}
