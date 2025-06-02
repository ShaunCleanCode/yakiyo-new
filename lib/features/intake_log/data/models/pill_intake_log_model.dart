class PillIntakeLogModel {
  final String id;
  final String pillScheduleId;
  final String timeSlotId;
  final DateTime intakeTime;
  final int quantity;
  final String? note;

  PillIntakeLogModel({
    required this.id,
    required this.pillScheduleId,
    required this.timeSlotId,
    required this.intakeTime,
    required this.quantity,
    this.note,
  });

  factory PillIntakeLogModel.fromJson(Map<String, dynamic> json) {
    return PillIntakeLogModel(
      id: json['id'] as String,
      pillScheduleId: json['pillScheduleId'] as String,
      timeSlotId: json['timeSlotId'] as String,
      intakeTime: DateTime.parse(json['intakeTime'] as String),
      quantity: json['quantity'] as int,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pillScheduleId': pillScheduleId,
      'timeSlotId': timeSlotId,
      'intakeTime': intakeTime.toIso8601String(),
      'quantity': quantity,
      'note': note,
    };
  }
}
