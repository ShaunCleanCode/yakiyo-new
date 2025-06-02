import 'time_slot_model.dart';

class DayScheduleModel {
  final String id;
  final int dayOfWeek;
  final List<TimeSlotModel> timeSlots;

  DayScheduleModel({
    required this.id,
    required this.dayOfWeek,
    required this.timeSlots,
  });

  factory DayScheduleModel.fromJson(Map<String, dynamic> json) {
    return DayScheduleModel(
      id: json['id'] as String,
      dayOfWeek: json['dayOfWeek'] as int,
      timeSlots: (json['timeSlots'] as List)
          .map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek,
      'timeSlots': timeSlots.map((e) => e.toJson()).toList(),
    };
  }
}
