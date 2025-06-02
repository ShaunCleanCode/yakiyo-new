class DeviceStatusModel {
  final String id;
  final String deviceId;
  final String status;
  final DateTime lastUpdated;
  final double? batteryLevel;
  final String? firmwareVersion;
  final Map<String, dynamic>? additionalInfo;

  DeviceStatusModel({
    required this.id,
    required this.deviceId,
    required this.status,
    required this.lastUpdated,
    this.batteryLevel,
    this.firmwareVersion,
    this.additionalInfo,
  });

  factory DeviceStatusModel.fromJson(Map<String, dynamic> json) {
    return DeviceStatusModel(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      status: json['status'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      batteryLevel: json['batteryLevel'] as double?,
      firmwareVersion: json['firmwareVersion'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'status': status,
      'lastUpdated': lastUpdated.toIso8601String(),
      'batteryLevel': batteryLevel,
      'firmwareVersion': firmwareVersion,
      'additionalInfo': additionalInfo,
    };
  }
}
