import '../../data/models/pill_schedule_model.dart';

abstract class PillScheduleRepository {
  Future<void> addPillSchedule(PillScheduleModel schedule);
  Future<List<PillScheduleModel>> getPillSchedules();
  Future<void> updatePillSchedule(PillScheduleModel schedule);
}
