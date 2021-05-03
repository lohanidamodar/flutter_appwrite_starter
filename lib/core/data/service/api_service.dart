import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_appwrite_starter/core/res/constants.dart';

class ApiService {
  final Client client = Client();
  Account account;
  Database db;
  Avatars avatars;
  Storage storage;
  static ApiService _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);

    //simple fix for running in Flutter Desktop platforms,
    //before desktop platforms are available in Appwrite console
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      client.addHeader('Origin', 'http://localhost');
    }
    account = Account(client);
    db = Database(client);
    avatars = Avatars(client);
    storage = Storage(client);
  }

  static ApiService get instance {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance;
  }

  Future signup({String name, String email, String password}) async {
    return account.create(name: name ?? "", email: email, password: password);
  }

  Future login({String email, String password}) async {
    return account.createSession(email: email, password: password);
  }

  Future<bool> logout() async {
    try {
      await account.deleteSessions();
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future getUser() async {
    return account.get();
  }

  Future updatePrefs(Map<String, dynamic> prefs) {
    return account.updatePrefs(prefs: prefs);
  }

  Future updateAccountName(String name) {
    return account.updateName(name: name);
  }

  Future getAvatar(String name) {
    return avatars.getInitials(
      name: name,
    );
  }

  Future getImageAvatar(String fileId) {
    return storage.getFilePreview(fileId: fileId, width: 100);
  }

  Future uploadFile(
    MultipartFile file, {
    List<String> read = const ["*"],
    List<String> write = const ['*'],
  }) {
    return storage.createFile(file: file, read: read, write: write);
  }
}
