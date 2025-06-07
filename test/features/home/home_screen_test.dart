import 'package:flutter_test/flutter_test.dart';
import 'package:yakiyo/features/home/data/repositories/home_repository_impl.dart';
import 'package:yakiyo/features/home/domain/use_cases/get_today_schedule_use_case.dart';
import 'package:yakiyo/features/home/domain/use_cases/get_today_intake_status_use_case.dart';
import 'package:yakiyo/features/home/domain/use_cases/get_next_intake_use_case.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/day_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/time_slot_model.dart';
import 'package:yakiyo/features/intake_log/data/models/pill_intake_log_model.dart';

void main() {
  group('Home UseCase Tests', () {
    final repository = HomeRepositoryImpl();
    final getTodayScheduleUseCase = GetTodayScheduleUseCase(repository);
    final getTodayIntakeStatusUseCase = GetTodayIntakeStatusUseCase(repository);
    final getNextIntakeUseCase = GetNextIntakeUseCase(repository);

    final today = DateTime.now();
    final pillSchedule = PillScheduleModel(
      id: '1',
      name: 'Test Pill',
      description: '',
      daySchedules: [
        DayScheduleModel(
          id: '1',
          dayOfWeek: today.weekday,
          timeSlots: [
            TimeSlotModel(
              id: 'slot1',
              time: DateTime(today.year, today.month, today.day, 8, 0),
              quantity: 1,
            ),
            TimeSlotModel(
              id: 'slot2',
              time: DateTime(today.year, today.month, today.day, 18, 0),
              quantity: 1,
            ),
          ],
        ),
      ],
      startDate: today,
      endDate: today.add(const Duration(days: 30)),
      isActive: true,
    );

    test('getTodayScheduleUseCase returns today\'s slots', () {
      final result = getTodayScheduleUseCase([pillSchedule]);
      expect(result.length, 2);
      expect(result[0].pillScheduleId, '1');
    });

    test('getTodayIntakeStatusUseCase returns correct status', () {
      final slots = getTodayScheduleUseCase([pillSchedule]);
      final logs = [
        PillIntakeLogModel(
          id: 'log1',
          pillScheduleId: '1',
          timeSlotId: 'slot1',
          intakeTime: today,
          quantity: 1,
        ),
      ];
      final status = getTodayIntakeStatusUseCase(slots, logs);
      expect(status['slot1'], true);
      expect(status['slot2'], false);
    });

    test('getNextIntakeUseCase returns next slot', () {
      final slots = getTodayScheduleUseCase([pillSchedule]);
      final status = {'slot1': true, 'slot2': false};
      final next = getNextIntakeUseCase(slots, status);
      expect(next?.slot.id, 'slot2');
    });
  });
}
