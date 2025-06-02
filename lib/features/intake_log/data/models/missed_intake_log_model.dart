class MissedIntakeLogModel {
  final String id;
  final String pillScheduleId;
  final String timeSlotId;
  final DateTime scheduledTime;
  final int quantity;
  final String? reason;

  MissedIntakeLogModel({
    required this.id,
    required this.pillScheduleId,
    required this.timeSlotId,
    required this.scheduledTime,
    required this.quantity,
    this.reason,
  });

  factory MissedIntakeLogModel.fromJson(Map<String, dynamic> json) {
    return MissedIntakeLogModel(
      id: json['id'] as String,
      pillScheduleId: json['pillScheduleId'] as String,
      timeSlotId: json['timeSlotId'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      quantity: json['quantity'] as int,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pillScheduleId': pillScheduleId,
      'timeSlotId': timeSlotId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'quantity': quantity,
      'reason': reason,
    };
  }
}
