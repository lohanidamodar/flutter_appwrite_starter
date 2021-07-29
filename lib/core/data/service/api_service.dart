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
    try {
      final res = await account.create(
        name: name ?? "",
        email: email,
        password: password,
      );
      print(res);
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  Future login({String email, String password}) async {
    try {
      final res = await account.createSession(
        email: email,
        password: password,
      );
      print(res);
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  Future<bool> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
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
