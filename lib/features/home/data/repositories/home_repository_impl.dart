import 'package:yakiyo/features/home/data/models/home_model.dart';

import '../../../pill_schedule/data/models/pill_schedule_model.dart';

import '../../../intake_log/data/models/pill_intake_log_model.dart';
import '../../domain/repositories/home_repository.dart';

/// Implementation of the home repository
class HomeRepositoryImpl implements HomeRepository {
  @override
  List<SlotWithScheduleId> getTodayScheduleWithPillId(
      List<PillScheduleModel> schedules) {
    final today = DateTime.now();
    final weekday = today.weekday;
    final result = <SlotWithScheduleId>[];

    for (final schedule in schedules) {
      for (final day in schedule.daySchedules) {
        if (day.dayOfWeek == weekday) {
          for (final slot in day.timeSlots) {
            result.add(SlotWithScheduleId(slot, schedule.id));
          }
        }
      }
    }
    return result;
  }

  @override
  Map<String, bool> getTodayIntakeStatus(
    List<SlotWithScheduleId> todaySlots,
    List<PillIntakeLogModel> logs,
  ) {
    final today = DateTime.now();

    return Map.fromEntries(
      todaySlots.map((slotWithId) {
        final slot = slotWithId.slot;
        final taken = logs.any((log) =>
            log.timeSlotId == slot.id &&
            log.intakeTime.year == today.year &&
            log.intakeTime.month == today.month &&
            log.intakeTime.day == today.day);
        return MapEntry(slot.id, taken);
      }),
    );
  }

  @override
  SlotWithScheduleId? getNextIntakeWithPillId(
    List<SlotWithScheduleId> todaySlots,
    Map<String, bool> status,
  ) {
    final now = DateTime.now();

    final remaining = todaySlots.where((slotWithId) {
      final slot = slotWithId.slot;
      final taken = status[slot.id] ?? false;
      final slotTime = DateTime(
        now.year,
        now.month,
        now.day,
        slot.time.hour,
        slot.time.minute,
      );
      return !taken && slotTime.isAfter(now);
    }).toList();

    remaining.sort((a, b) => a.slot.time.compareTo(b.slot.time));
    return remaining.isNotEmpty ? remaining.first : null;
  }
}
