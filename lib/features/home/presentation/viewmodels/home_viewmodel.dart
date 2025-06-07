import '../../../pill_schedule/data/models/pill_schedule_model.dart';
import '../../../pill_schedule/data/models/time_slot_model.dart';

/// ViewModel for the Home screen that handles all business logic
class HomeViewModel {
  /// Filters schedules for today's weekday
  static List<PillScheduleModel> filterTodaySchedules(
      List<PillScheduleModel> schedules) {
    final today = DateTime.now().weekday;
    return schedules
        .where((schedule) =>
            schedule.daySchedules.any((day) => day.dayOfWeek == today))
        .toList();
  }

  /// Extracts time slots for today from a schedule
  static List<TimeSlotModel> extractTodaySlots(PillScheduleModel schedule) {
    final today = DateTime.now().weekday;
    return schedule.daySchedules
        .where((ds) => ds.dayOfWeek == today)
        .expand((ds) => ds.timeSlots)
        .toList();
  }

  /// Calculates intake status for each time slot
  static Map<String, bool> getIntakeStatus(
      List<TimeSlotModel> slots, Map<String, bool> intakeStatus) {
    return Map.fromEntries(
      slots.map((slot) => MapEntry(slot.id, intakeStatus[slot.id] ?? false)),
    );
  }

  /// Filters remaining time slots that haven't been taken yet
  static List<TimeSlotModel> filterRemainingSlots(
      List<TimeSlotModel> slots, Map<String, bool> intakeStatus) {
    final now = DateTime.now();
    return slots.where((slot) {
      final isTaken = intakeStatus[slot.id] ?? false;
      final slotTime = DateTime(
        now.year,
        now.month,
        now.day,
        slot.time.hour,
        slot.time.minute,
      );
      return !isTaken && slotTime.isAfter(now);
    }).toList();
  }

  /// Gets the next time slot to take medication
  static TimeSlotModel? getNextSlot(List<TimeSlotModel> remainingSlots) {
    if (remainingSlots.isEmpty) return null;
    remainingSlots.sort((a, b) => a.time.compareTo(b.time));
    return remainingSlots.first;
  }

  /// Calculates the next intake time
  static DateTime? getNextTime(TimeSlotModel? nextSlot) {
    if (nextSlot == null) return null;
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      nextSlot.time.hour,
      nextSlot.time.minute,
    );
  }

  /// Determines the time label for a slot (morning, lunch, dinner)
  static String getTimeLabel(TimeSlotModel slot) {
    final hour = slot.time.hour;
    if (hour >= 5 && hour < 11) return '아침';
    if (hour >= 11 && hour < 15) return '점심';
    if (hour >= 15 && hour < 24) return '저녁';
    return '기타';
  }

  /// Calculates next intake information including message and status
  static Map<String, dynamic> getNextIntakeInfo(
      TimeSlotModel? nextSlot, DateTime? nextTime) {
    final now = DateTime.now();

    if (nextSlot == null) {
      return {
        'msg': '이 약은 오늘 다 복용하셨어요',
        'label': null,
        'isWithinWindow': false,
      };
    }

    final difference = nextTime!.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final isWithinWindow = difference.inMinutes.abs() <= 30;
    final nextIntakeLabel = getTimeLabel(nextSlot);

    String nextIntakeMsg;
    if (isWithinWindow) {
      nextIntakeMsg = '약 드실 시간입니다!';
    } else if (hours > 0) {
      nextIntakeMsg = '$hours시간 $minutes분';
    } else {
      nextIntakeMsg = '$minutes분';
    }

    return {
      'msg': nextIntakeMsg,
      'label': nextIntakeLabel,
      'isWithinWindow': isWithinWindow,
    };
  }

  /// Gets unique time labels for all slots in time order
  static List<String> getSlotLabels(List<TimeSlotModel> slots) {
    // 시간순으로 정렬
    final sorted = slots.toList()..sort((a, b) => a.time.compareTo(b.time));
    // 중복 제거하면서 시간순으로 라벨 추출
    final labels = <String>[];
    for (final slot in sorted) {
      final label = getTimeLabel(slot);
      if (!labels.contains(label)) {
        labels.add(label);
      }
    }
    return labels;
  }

  /// Maps time slots to their respective labels
  static Map<String, TimeSlotModel?> getSlotByLabel(List<TimeSlotModel> slots) {
    return Map.fromEntries(
      slots.map((slot) => MapEntry(getTimeLabel(slot), slot)),
    );
  }

  /// Checks if all medications have been taken
  static bool isTaken(TimeSlotModel? nextSlot) => nextSlot == null;

  /// Calculates the intake status message
  static String getIntakeStatusMessage(bool isTaken, bool isWithinWindow) {
    if (isTaken) return '오늘 복용을 모두 완료하셨습니다.';
    if (isWithinWindow) return '지금 약을 복용해주세요!';
    return '아직 약을 복용하지 않으셨습니다.';
  }

  /// Gets the button state message
  static String getButtonStateMessage(bool isTaken, bool isWithinWindow) {
    if (isTaken) return '복용이 임박해지면 활성화돼요';
    if (!isWithinWindow) return '복용 시간 30분 전부터 활성화돼요';
    return '';
  }
}
