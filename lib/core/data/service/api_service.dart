import 'package:appwrite/appwrite.dart';
import 'package:flutter_appwrite_starter/core/res/constants.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user.dart';

class ApiService {
  final Client client = Client();
  Account account;
  Database db;
  static ApiService _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    account = Account(client);
    db = Database(client);
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
  /* 
  Future<Mood> addMood({
    Map<String, dynamic> data,
    List<String> read,
    List<String> write,
  }) async {
    try {
      final res = await db.createDocument(
        collectionId: AppConstants.entriesCollection,
        data: data,
        read: read,
        write: write,
      );
      return Mood.fromMap(res.data);
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<List<Mood>> getMoods() async {
    try {
      final res =
          await db.listDocuments(collectionId: AppConstants.entriesCollection);
      return List<Map<String, dynamic>>.from(res.data['documents'])
          .map((e) => Mood.fromMap(e))
          .toList();
    } on AppwriteException catch (e) {
      print(e.message);
      return [];
    }
  } */

}