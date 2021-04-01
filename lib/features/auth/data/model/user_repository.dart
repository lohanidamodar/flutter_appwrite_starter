import 'dart:async';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/device.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  User _user;
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

  Future<void> _getUser() async {
    try {
      final res = await ApiService.instance.getUser();
      _user = User.fromMap(res.data);
      _status = Status.Authenticated;
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
      await ApiService.instance.signup(name: name, email: email, password: password);
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
      _status = Status.Unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _saveUserRecord() async {
    if (_user == null) return;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    User user = User(
      email: _user.email,
      name: _user.name,
      id: _user.id,
    );

    //get existing user
    bool existing = false;
    if (existing == null) {
      _user = user;
    } else {
      //update users login and build number
      /* await userDBS.updateData(_user.uid, {
        UserFields.lastLoggedIn: FieldValue.serverTimestamp(),
        UserFields.buildNumber: buildNumber,
      }); */
    }
    _saveDevice(user);
  }

  Future<void> _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    String deviceId;
    DeviceDetails deviceDescription;
    if (Platform.isAndroid) {
      AndroidDeviceInfo deviceInfo = await devicePlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceDescription = DeviceDetails(
        device: deviceInfo.device,
        model: deviceInfo.model,
        osVersion: deviceInfo.version.sdkInt.toString(),
        platform: 'android',
      );
    }
    if (Platform.isIOS) {
      IosDeviceInfo deviceInfo = await devicePlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceDescription = DeviceDetails(
        osVersion: deviceInfo.systemVersion,
        device: deviceInfo.name,
        model: deviceInfo.utsname.machine,
        platform: 'ios',
      );
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
    //if (user.buildNumber != buildNumber) {
    //TODO
    /* userDBS.updateData(user.id, {
        UserFields.buildNumber: buildNumber,
        UserFields.lastUpdated: nowMS,
      }); */
    //}

    //TODO get current device
    // Device exsiting = await userDeviceDBS.getSingle(deviceId);
    Device existing = null;
    if (existing != null) {
      //TODO
      /* await userDeviceDBS.updateData(deviceId, {
        DeviceFields.lastUpdatedAt: nowMS,
        DeviceFields.expired: false,
        DeviceFields.uninstalled: false,
      }); */
      currentDevice = existing;
    } else {
      Device device = Device(
        createdAt: DateTime.now().toUtc(),
        deviceInfo: deviceDescription,
        expired: false,
        id: deviceId,
        lastUpdatedAt: nowMS,
        uninstalled: false,
      );
      //TODO add device data
      /* await userDeviceDBS.createItem(device, id: deviceId); */
      currentDevice = device;
    }
    notifyListeners();
  }
}
