import 'package:vital_data_viewer_app/const/response_type.dart';

class DeviceResponse {
  final DeviceBattery battery; // バッテリー状態
  final int batteryLevel; // バッテリーレベル
  final String deviceVersion; // デバイスのバージョン
  final String id; // デバイスID
  final DateTime lastSyncTime; // 最終同期時間
  final DeviceType type; // デバイスタイプ

  DeviceResponse({
    required this.battery,
    required this.batteryLevel,
    required this.deviceVersion,
    required this.id,
    required this.lastSyncTime,
    required this.type,
  });

  factory DeviceResponse.fromJson(Map<String, dynamic> json) {
    return DeviceResponse(
      battery: DeviceButteryExtension.fromString(json['battery']),
      batteryLevel: json['batteryLevel'] as int,
      deviceVersion: json['deviceVersion'] as String,
      id: json['id'] as String,
      lastSyncTime: DateTime.parse(json['lastSyncTime']),
      type: DeviceTypeExtension.fromString(json['type']),
    );
  }
}