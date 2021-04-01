import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appwrite_starter/core/data/res/data_constants.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/device.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/device_field.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  
  UserModel _user;
  Status _status = Status.Uninitialized;
  String _error;
  StreamSubscription _userListener;
  UserModel _fsUser;
  Device currentDevice;
  bool _loading;

  UserRepository.instance(){
    _error = '';
    _loading = true;
    //get current user and set auth state
  }

  String get error => _error;
  Status get status => _status;
  UserModel get user => _fsUser;
  bool get isLoading => _loading;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      //sign in
      _error = '';
      return true;
    } catch (e) {
      _error = e.message;
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      //signup
      _error = '';
      return true;
    } catch (e) {
      _error = e.message;
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }


  Future signOut() async {
    //sign out
    _status = Status.Unauthenticated;
    _fsUser = null;
    _userListener.cancel();
    notifyListeners();
    return Future.delayed(Duration.zero);
  }


  Future<void> _saveUserRecord() async {
    if (_user == null) return;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    UserModel user = UserModel(
      email: _user.email,
      name: _user.name,
      photoUrl: _user.photoUrl,
      id: _user.id,
      registrationDate: DateTime.now().toUtc(),
      lastLoggedIn: DateTime.now().toUtc(),
      buildNumber: buildNumber,
      introSeen: false,
    );
    
    //get existing user
    bool existing = false;
    if (existing == null) {
      _fsUser = user;
    } else {
      //update users login and build number
      /* await userDBS.updateData(_user.uid, {
        UserFields.lastLoggedIn: FieldValue.serverTimestamp(),
        UserFields.buildNumber: buildNumber,
      }); */
    }
    _saveDevice(user);
  }

  Future<void> _saveDevice(UserModel user) async {
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
    if (user.buildNumber != buildNumber) {
      //TODO
      /* userDBS.updateData(user.id, {
        UserFields.buildNumber: buildNumber,
        UserFields.lastUpdated: nowMS,
      }); */
    }

    
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

  @override
  void dispose() {
    _userListener.cancel();
    super.dispose();
  }
}
