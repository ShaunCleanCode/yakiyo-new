import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pill_intake_log_model.dart';
import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';
import 'package:yakiyo/features/pill_schedule/data/models/time_slot_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';
import 'package:flutter/material.dart';

class IntakeLogNotifier extends StateNotifier<List<PillIntakeLogModel>> {
  IntakeLogNotifier() : super([]);

  void add({
    required String pillScheduleId,
    required String timeSlotId,
    required DateTime intakeTime,
    required int quantity,
    String? note,
  }) {
    state = [
      ...state,
      PillIntakeLogModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        pillScheduleId: pillScheduleId,
        timeSlotId: timeSlotId,
        intakeTime: intakeTime,
        quantity: quantity,
        note: note,
      ),
    ];
  }
}

final intakeLogProvider =
    StateNotifierProvider<IntakeLogNotifier, List<PillIntakeLogModel>>(
  (ref) => IntakeLogNotifier(),
);

enum PillIntakeStatus { allTaken, partial, none, upcoming, notRequired }

final pillIntakeStatusForDateProvider =
    Provider.family<PillIntakeStatus, DateTime>((ref, date) {
  final schedulesAsync = ref.watch(pillScheduleProvider);
  final logs = ref.watch(intakeLogProvider);
  if (schedulesAsync is! AsyncData<List<PillScheduleModel>>) {
    return PillIntakeStatus.notRequired;
  }
  final schedules = schedulesAsync.value;
  final weekday = date.weekday;
  final dateOnly = DateTime(date.year, date.month, date.day);
  final slots = schedules
      .where((schedule) => !dateOnly.isBefore(DateTime(schedule.startDate.year,
          schedule.startDate.month, schedule.startDate.day)))
      .expand((schedule) => schedule.daySchedules
          .where((ds) => ds.dayOfWeek == weekday)
          .expand((ds) => ds.timeSlots))
      .toList();
  if (slots.isEmpty) return PillIntakeStatus.notRequired;
  final now = DateTime.now();
  if (dateOnly.isAfter(DateTime(now.year, now.month, now.day))) {
    return PillIntakeStatus.upcoming;
  }
  final takenList = slots
      .map((slot) => logs.any((log) =>
          log.timeSlotId == slot.id &&
          log.intakeTime.year == date.year &&
          log.intakeTime.month == date.month &&
          log.intakeTime.day == date.day))
      .toList();
  if (takenList.every((taken) => taken)) return PillIntakeStatus.allTaken;
  if (takenList.every((taken) => !taken)) return PillIntakeStatus.none;
  return PillIntakeStatus.partial;
});
