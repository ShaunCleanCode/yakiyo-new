import 'package:yakiyo/features/pill_schedule/data/repositories/mock_pill_schedule_repository.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';

class TestMockPillScheduleRepository extends MockPillScheduleRepository {
  Exception? _error;
  List<PillScheduleModel> _mockSchedules = [];

  void setError(Exception error) {
    _error = error;
  }

  void setMockSchedules(List<PillScheduleModel> schedules) {
    _mockSchedules = schedules;
  }

  @override
  Future<List<PillScheduleModel>> getPillSchedules() async {
    if (_error != null) {
      throw _error!;
    }
    return _mockSchedules;
  }

  @override
  Future<void> addPillSchedule(PillScheduleModel schedule) async {
    if (_error != null) {
      throw _error!;
    }
    _mockSchedules.add(schedule);
  }

  @override
  Future<void> updatePillSchedule(PillScheduleModel schedule) async {
    if (_error != null) {
      throw _error!;
    }
    final index = _mockSchedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _mockSchedules[index] = schedule;
    }
  }

  @override
  Future<void> deletePillSchedule(String id) async {
    if (_error != null) {
      throw _error!;
    }
    _mockSchedules.removeWhere((schedule) => schedule.id == id);
  }
}
