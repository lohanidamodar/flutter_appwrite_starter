import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/device.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user_prefs.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  User _user;
  UserPrefs _prefs;
  Status _status = Status.Uninitialized;
  String _error;
  Device currentDevice;
  bool _loading;

  UserRepository.instance() {
    _error = '';
    _loading = true;
    _getUser();
  }

  String get error => _error;
  Status get status => _status;
  User get user => _user;
  bool get isLoading => _loading;
  UserPrefs get prefs => _prefs;

  Future<void> _getUser() async {
    try {
      final res = await ApiService.instance.getUser();
      _user = User.fromMap(res.data);
      _status = Status.Authenticated;
      _prefs = _user.prefs;
      _saveUserPrefs();
    } on AppwriteException catch (e) {
      _status = Status.Unauthenticated;
      _error = e.message;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await ApiService.instance.login(email: email, password: password);
      _getUser();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await ApiService.instance
          .signup(name: name, email: email, password: password);
      _error = '';
      await signIn(email, password);
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    //sign out
    final res = await ApiService.instance.logout();
    if (res == true) {
      _user = null;
      _prefs = null;
      _status = Status.Unauthenticated;
      notifyListeners();
    }
  }

  introSeen() async {
    final prefs = _prefs?.copyWith(
      introSeen: true,
    );
    if (prefs != null) await ApiService.instance.updatePrefs(prefs.toMap());
    _prefs = prefs;
    notifyListeners();
  }

  updateProfile({String name, String photoUrl, String photoId}) async {
    try {
      final res = await ApiService.instance.updateAccountName(name);
      _error = '';
      _user = User.fromMap(res.data);
      _prefs = _prefs.copyWith(photoUrl: photoUrl, photoId: photoId);
      await _saveUserPrefs();
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<void> _saveUserPrefs() async {
    if (_user == null) return;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    var prefs = _prefs ?? UserPrefs();
    prefs = prefs.copyWith(
      buildNumber: buildNumber,
      introSeen: _prefs.introSeen ?? false,
      registrationDate: _prefs.registrationDate ?? DateTime.now(),
      lastLoggedIn: DateTime.now(),
    );
    await ApiService.instance.updatePrefs(prefs.toMap());
    _prefs = prefs;
    _user = _user.copyWith(prefs: _prefs);
    notifyListeners();
  }
}
