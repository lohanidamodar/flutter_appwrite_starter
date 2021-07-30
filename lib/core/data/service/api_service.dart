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
