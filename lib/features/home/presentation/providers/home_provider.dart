import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../pill_schedule/data/models/pill_schedule_model.dart';
import '../../../pill_schedule/data/models/time_slot_model.dart';
import '../../../intake_log/data/models/pill_intake_log_model.dart';
import '../../../pill_schedule/presentation/providers/pill_schedule_provider.dart';
import '../../../intake_log/presentation/providers/intake_log_provider.dart';

// (TimeSlotModel, pillScheduleId) 튜플 제공
class SlotWithScheduleId {
  final TimeSlotModel slot;
  final String pillScheduleId;
  SlotWithScheduleId(this.slot, this.pillScheduleId);
}

final todayScheduleWithPillIdProvider =
    Provider<List<SlotWithScheduleId>>((ref) {
  final schedulesAsync = ref.watch(pillScheduleProvider);
  return schedulesAsync.maybeWhen(
    data: (schedules) {
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
    },
    orElse: () => [],
  );
});

final todayIntakeStatusProvider = Provider<Map<String, bool>>((ref) {
  final todaySlots = ref.watch(todayScheduleWithPillIdProvider);
  final logs = ref.watch(intakeLogProvider);
  final today = DateTime.now();
  final status = <String, bool>{};
  for (final slotWithId in todaySlots) {
    final slot = slotWithId.slot;
    final taken = logs.any((log) =>
        log.timeSlotId == slot.id &&
        log.intakeTime.year == today.year &&
        log.intakeTime.month == today.month &&
        log.intakeTime.day == today.day);
    status[slot.id] = taken;
  }
  return status;
});

final nextIntakeWithPillIdProvider = Provider<SlotWithScheduleId?>((ref) {
  final todaySlots = ref.watch(todayScheduleWithPillIdProvider);
  final status = ref.watch(todayIntakeStatusProvider);
  final now = DateTime.now();
  final remaining = todaySlots.where((slotWithId) {
    final slot = slotWithId.slot;
    final taken = status[slot.id] ?? false;
    final slotTime = DateTime(
        now.year, now.month, now.day, slot.time.hour, slot.time.minute);
    return !taken && slotTime.isAfter(now);
  }).toList();
  remaining.sort((a, b) => a.slot.time.compareTo(b.slot.time));
  return remaining.isNotEmpty ? remaining.first : null;
});

final homeRefreshingProvider = StateProvider<bool>((ref) => false);

final isWithinIntakeWindowProvider = Provider<bool>((ref) {
  final nextSlot = ref.watch(nextIntakeWithPillIdProvider);
  if (nextSlot == null) return false;

  final now = DateTime.now();
  final slotTime = DateTime(
    now.year,
    now.month,
    now.day,
    nextSlot.slot.time.hour,
    nextSlot.slot.time.minute,
  );

  final difference = now.difference(slotTime).inMinutes.abs();
  return difference <= 30;
});

final nextIntakeTimeMessageProvider = Provider<String>((ref) {
  final nextSlot = ref.watch(nextIntakeWithPillIdProvider);
  final isWithinWindow = ref.watch(isWithinIntakeWindowProvider);

  if (nextSlot == null) return '완료';
  if (isWithinWindow) return '약 드실 시간입니다!';

  final now = DateTime.now();
  final slotTime = DateTime(
    now.year,
    now.month,
    now.day,
    nextSlot.slot.time.hour,
    nextSlot.slot.time.minute,
  );

  final difference = slotTime.difference(now);
  final hours = difference.inHours;
  final minutes = difference.inMinutes % 60;

  if (hours > 0) {
    return '$hours시간 $minutes분';
  } else {
    return '$minutes분';
  }
});
