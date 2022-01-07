
import 'device_field.dart';

class Device {
  String? id;
  DateTime? createdAt;
  bool? expired;
  bool? uninstalled;
  int? lastUpdatedAt;
  DeviceDetails? deviceInfo;
  String? token;

  Device({this.id, this.token,this.createdAt,this.expired,this.uninstalled,this.lastUpdatedAt,this.deviceInfo});

  Device.fromDS(this.id, Map<String,dynamic> data):
    createdAt=data[DeviceFields.createdAt]?.toDate(),
    expired=data[DeviceFields.expired],
    uninstalled=data[DeviceFields.uninstalled] ?? false,
    lastUpdatedAt=data[DeviceFields.lastUpdatedAt],
    deviceInfo=DeviceDetails.fromJson(data[DeviceFields.deviceInfo]),
    token=data[DeviceFields.token];
  
  Map<String,dynamic> toMap()  {
    return {
      DeviceFields.createdAt: createdAt,
      DeviceFields.deviceInfo: deviceInfo!.toJson(),
      DeviceFields.expired:expired,
      DeviceFields.uninstalled:uninstalled,
      DeviceFields.lastUpdatedAt: lastUpdatedAt,
      DeviceFields.token: token,
    };
  }
}

class DeviceDetails {
  String? device;
  String? model;
  String? osVersion;
  String? platform;

  DeviceDetails({this.device, this.model, this.osVersion, this.platform});

  DeviceDetails.fromJson(Map<String, dynamic> json) {
    device = json[DeviceDetailsFields.device];
    model = json[DeviceDetailsFields.model];
    osVersion = json[DeviceDetailsFields.osVersion];
    platform = json[DeviceDetailsFields.platform];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[DeviceDetailsFields.device] = device;
    data[DeviceDetailsFields.model] = model;
    data[DeviceDetailsFields.osVersion] = osVersion;
    data[DeviceDetailsFields.platform] = platform;
    return data;
  }
}
