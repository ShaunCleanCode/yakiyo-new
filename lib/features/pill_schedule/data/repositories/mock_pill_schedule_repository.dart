import '../../domain/repositories/pill_schedule_repository.dart';
import '../models/pill_schedule_model.dart';

class MockPillScheduleRepository implements PillScheduleRepository {
  final List<PillScheduleModel> _mockSchedules = [];

  @override
  Future<void> addPillSchedule(PillScheduleModel schedule) async {
    print('[MockPillScheduleRepository] addPillSchedule called with: '
        'id=${schedule.id}, name=${schedule.name}, daySchedules=${schedule.daySchedules.length}');
    final index = _mockSchedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _mockSchedules[index] = schedule;
      print(
          '[MockPillScheduleRepository] Schedule updated at index: $index (via add)');
    } else {
      _mockSchedules.add(schedule);
      print('[MockPillScheduleRepository] Schedule added');
    }
    print(
        '[MockPillScheduleRepository] Current schedules count: ${_mockSchedules.length}');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<PillScheduleModel>> getPillSchedules() async {
    print('[MockPillScheduleRepository] getPillSchedules called');
    await Future.delayed(const Duration(milliseconds: 500));
    print(
        '[MockPillScheduleRepository] Returning schedules count: ${_mockSchedules.length}');
    return _mockSchedules;
  }

  @override
  Future<void> updatePillSchedule(PillScheduleModel schedule) async {
    print(
        '[MockPillScheduleRepository] updatePillSchedule called with: id=${schedule.id}');
    final index = _mockSchedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _mockSchedules[index] = schedule;
      print('[MockPillScheduleRepository] Schedule updated at index: $index');
    } else {
      print('[MockPillScheduleRepository] Schedule not found for update');
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> deletePillSchedule(String id) async {
    print(
        '[MockPillScheduleRepository] deletePillSchedule called with id: $id');
    _mockSchedules.removeWhere((s) => s.id == id);
    print(
        '[MockPillScheduleRepository] Current schedules count after delete: ${_mockSchedules.length}');
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
