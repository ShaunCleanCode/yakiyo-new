import '../../domain/repositories/pill_schedule_repository.dart';
import '../models/pill_schedule_model.dart';
import '../models/day_schedule_model.dart';
import '../models/time_slot_model.dart';

class MockPillScheduleRepository implements PillScheduleRepository {
  final List<PillScheduleModel> _mockSchedules = [];

  @override
  Future<void> addPillSchedule(PillScheduleModel schedule) async {
    // 실제 API 호출 대신 로컬 리스트에 추가
    _mockSchedules.add(schedule);
    // 실제 API 호출처럼 약간의 지연 추가
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<PillScheduleModel>> getPillSchedules() async {
    // 실제 API 호출처럼 약간의 지연 추가
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockSchedules;
  }

  @override
  Future<void> updatePillSchedule(PillScheduleModel schedule) async {
    final index = _mockSchedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _mockSchedules[index] = schedule;
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
