import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/day_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/time_slot_model.dart';
import 'package:yakiyo/features/pill_schedule/data/repositories/mock_pill_schedule_repository.dart';

class TestMockPillScheduleRepository extends MockPillScheduleRepository {
  Exception? _error;
  List<PillScheduleModel> _schedules = [];

  void setError(Exception error) {
    _error = error;
  }

  void setMockSchedules(List<PillScheduleModel> schedules) {
    _schedules = schedules;
  }

  @override
  Future<List<PillScheduleModel>> getPillSchedules() async {
    if (_error != null) {
      throw _error!;
    }
    return _schedules;
  }

  @override
  Future<void> addPillSchedule(PillScheduleModel schedule) async {
    if (_error != null) {
      throw _error!;
    }
    _schedules.add(schedule);
  }

  @override
  Future<void> updatePillSchedule(PillScheduleModel schedule) async {
    if (_error != null) {
      throw _error!;
    }
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _schedules[index] = schedule;
    }
  }

  @override
  Future<void> deletePillSchedule(String id) async {
    if (_error != null) {
      throw _error!;
    }
    _schedules.removeWhere((s) => s.id == id);
  }
}

void main() {
  late ProviderContainer container;
  late TestMockPillScheduleRepository mockRepository;

  setUp(() {
    mockRepository = TestMockPillScheduleRepository();
    container = ProviderContainer(
      overrides: [
        pillScheduleRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PillScheduleProvider Tests', () {
    test('initial state is loading', () {
      final state = container.read(pillScheduleProvider);
      expect(state, const AsyncValue.loading());
    });

    test('loads schedules successfully', () async {
      // Arrange
      final schedules = [
        PillScheduleModel(
          id: '1',
          name: 'Morning Pills',
          description: 'Take with breakfast',
          daySchedules: [
            DayScheduleModel(
              id: '1',
              dayOfWeek: 1,
              timeSlots: [
                TimeSlotModel(
                  id: '1',
                  time: DateTime(2024, 1, 1, 8, 0),
                  quantity: 1,
                ),
              ],
            ),
          ],
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 12, 31),
          isActive: true,
        ),
      ];
      mockRepository.setMockSchedules(schedules);

      // Act
      await container.read(pillScheduleProvider.notifier).loadSchedules();

      // Assert
      final state = container.read(pillScheduleProvider);
      expect(state, isA<AsyncData<List<PillScheduleModel>>>());
      expect(state.value, schedules);
    });

    test('handles error when loading schedules', () async {
      // Arrange
      mockRepository.setError(Exception('Failed to load schedules'));

      // Act
      await container.read(pillScheduleProvider.notifier).loadSchedules();

      // Assert
      final state = container.read(pillScheduleProvider);
      expect(state, isA<AsyncError>());
      expect(state.error, isA<Exception>());
    });

    test('adds schedule successfully', () async {
      // Arrange
      final schedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
        description: 'Take with breakfast',
        daySchedules: [
          DayScheduleModel(
            id: '1',
            dayOfWeek: 1,
            timeSlots: [
              TimeSlotModel(
                id: '1',
                time: DateTime(2024, 1, 1, 8, 0),
                quantity: 1,
              ),
            ],
          ),
        ],
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        isActive: true,
      );

      // Act
      await container.read(pillScheduleProvider.notifier).addSchedule(schedule);

      // Assert
      final state = container.read(pillScheduleProvider);
      expect(state, isA<AsyncData<List<PillScheduleModel>>>());
      expect(state.value?.length, 1);
      expect(state.value?.first, schedule);
    });

    test('updates schedule successfully', () async {
      // Arrange
      final initialSchedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
        description: 'Take with breakfast',
        daySchedules: [
          DayScheduleModel(
            id: '1',
            dayOfWeek: 1,
            timeSlots: [
              TimeSlotModel(
                id: '1',
                time: DateTime(2024, 1, 1, 8, 0),
                quantity: 1,
              ),
            ],
          ),
        ],
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        isActive: true,
      );
      mockRepository.setMockSchedules([initialSchedule]);

      final updatedSchedule = PillScheduleModel(
        id: initialSchedule.id,
        name: 'Updated Morning Pills',
        description: 'Updated description',
        daySchedules: initialSchedule.daySchedules,
        startDate: initialSchedule.startDate,
        endDate: initialSchedule.endDate,
        isActive: initialSchedule.isActive,
      );

      // Act
      await container
          .read(pillScheduleProvider.notifier)
          .updateSchedule(updatedSchedule);

      // Assert
      final state = container.read(pillScheduleProvider);
      expect(state, isA<AsyncData<List<PillScheduleModel>>>());
      expect(state.value?.length, 1);
      expect(state.value?.first.name, 'Updated Morning Pills');
      expect(state.value?.first.description, 'Updated description');
    });

    test('deletes schedule successfully', () async {
      // Arrange
      final schedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
        description: 'Take with breakfast',
        daySchedules: [
          DayScheduleModel(
            id: '1',
            dayOfWeek: 1,
            timeSlots: [
              TimeSlotModel(
                id: '1',
                time: DateTime(2024, 1, 1, 8, 0),
                quantity: 1,
              ),
            ],
          ),
        ],
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        isActive: true,
      );
      mockRepository.setMockSchedules([schedule]);

      // Act
      await container.read(pillScheduleProvider.notifier).deleteSchedule('1');

      // Assert
      final state = container.read(pillScheduleProvider);
      expect(state, isA<AsyncData<List<PillScheduleModel>>>());
      expect(state.value?.length, 0);
    });

    test('handles error when adding schedule', () async {
      // Arrange
      mockRepository.setError(Exception('Failed to add schedule'));
      final schedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
        description: 'Take with breakfast',
        daySchedules: [
          DayScheduleModel(
            id: '1',
            dayOfWeek: 1,
            timeSlots: [
              TimeSlotModel(
                id: '1',
                time: DateTime(2024, 1, 1, 8, 0),
                quantity: 1,
              ),
            ],
          ),
        ],
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        isActive: true,
      );

      // Act
      await container.read(pillScheduleProvider.notifier).addSchedule(schedule);

      // Assert
      final state = container.read(pillScheduleProvider);
      expect(state, isA<AsyncError>());
      expect(state.error, isA<Exception>());
    });
  });
}
