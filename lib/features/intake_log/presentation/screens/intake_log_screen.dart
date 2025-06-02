import 'package:flutter/material.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';

class IntakeLogScreen extends StatelessWidget {
  const IntakeLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Intake Log Screen'),
    );
  }
}

List<String> _extractTimeSlots(PillScheduleModel schedule) {
  // 대표 요일(예: 첫 번째 daySchedule)만 사용
  if (schedule.daySchedules.isEmpty) return [];
  final firstDay = schedule.daySchedules.first;
  final timeSlots = <String>[];
  for (var timeSlot in firstDay.timeSlots) {
    final hour = timeSlot.time.hour;
    if (hour >= 5 && hour < 11 && !timeSlots.contains('아침')) {
      timeSlots.add('아침');
    } else if (hour >= 11 && hour < 15 && !timeSlots.contains('점심')) {
      timeSlots.add('점심');
    } else if (hour >= 15 && hour < 21 && !timeSlots.contains('저녁')) {
      timeSlots.add('저녁');
    }
  }
  return timeSlots;
}
