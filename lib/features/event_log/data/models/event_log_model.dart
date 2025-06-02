class EventLogModel {
  final String id;
  final String eventType;
  final String description;
  final DateTime timestamp;
  final String? userId;
  final String? deviceId;
  final Map<String, dynamic>? metadata;

  EventLogModel({
    required this.id,
    required this.eventType,
    required this.description,
    required this.timestamp,
    this.userId,
    this.deviceId,
    this.metadata,
  });

  factory EventLogModel.fromJson(Map<String, dynamic> json) {
    return EventLogModel(
      id: json['id'] as String,
      eventType: json['eventType'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['userId'] as String?,
      deviceId: json['deviceId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventType': eventType,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'deviceId': deviceId,
      'metadata': metadata,
    };
  }
}
