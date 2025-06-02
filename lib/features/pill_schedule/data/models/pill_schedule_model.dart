import 'day_schedule_model.dart';

class PillScheduleModel {
  final String id;
  final String name;
  final String description;
  final List<DayScheduleModel> daySchedules;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  PillScheduleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.daySchedules,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory PillScheduleModel.fromJson(Map<String, dynamic> json) {
    return PillScheduleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      daySchedules: (json['daySchedules'] as List)
          .map((e) => DayScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'daySchedules': daySchedules.map((e) => e.toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    };
  }
}
