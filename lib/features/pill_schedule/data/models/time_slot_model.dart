class TimeSlotModel {
  final String id;
  final DateTime time;
  final int quantity;
  final String? note;

  TimeSlotModel({
    required this.id,
    required this.time,
    required this.quantity,
    this.note,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] as String,
      time: DateTime.parse(json['time'] as String),
      quantity: json['quantity'] as int,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'quantity': quantity,
      'note': note,
    };
  }
}
