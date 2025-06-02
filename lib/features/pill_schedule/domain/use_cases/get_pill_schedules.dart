import 'dart:developer' as developer;
import '../entities/pill_schedule.dart';
import '../repositories/pill_schedule_repository.dart';

class GetPillSchedulesUseCase {
  final PillScheduleRepository _repository;

  GetPillSchedulesUseCase(this._repository);

  Future<List<PillSchedule>> call() async {
    final schedules = await _repository.getPillSchedules();
    developer.log('Fetched schedules: ${schedules.length}');

    final convertedSchedules = schedules.map((schedule) {
      // 시간대 정보 추출
      final timeSlots = <String>[];
      for (var daySchedule in schedule.daySchedules) {
        for (var timeSlot in daySchedule.timeSlots) {
          final hour = timeSlot.time.hour;
          if (hour >= 5 && hour < 11 && !timeSlots.contains('아침')) {
            timeSlots.add('아침');
          } else if (hour >= 11 && hour < 15 && !timeSlots.contains('점심')) {
            timeSlots.add('점심');
          } else if (hour >= 15 && hour < 21 && !timeSlots.contains('저녁')) {
            timeSlots.add('저녁');
          }
        }
      }

      developer.log(
          'Converting schedule: ${schedule.name} with timeSlots: $timeSlots');

      return PillSchedule(
        id: schedule.id,
        name: schedule.name,
        timeSlots: timeSlots,
      );
    }).toList();

    developer.log('Converted schedules: ${convertedSchedules.length}');
    return convertedSchedules;
  }
}
