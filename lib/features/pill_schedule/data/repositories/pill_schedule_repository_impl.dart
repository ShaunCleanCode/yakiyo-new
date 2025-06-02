import '../../domain/repositories/pill_schedule_repository.dart';
import '../models/pill_schedule_model.dart';
import '../../../../services/pill_schedule_api_service.dart';

class PillScheduleRepositoryImpl implements PillScheduleRepository {
  final PillScheduleApiService _apiService;

  PillScheduleRepositoryImpl(this._apiService);

  @override
  Future<void> addPillSchedule(PillScheduleModel schedule) async {
    try {
      await _apiService.addPillSchedule(schedule.toJson());
    } catch (e) {
      throw Exception('Failed to add pill schedule: $e');
    }
  }

  @override
  Future<List<PillScheduleModel>> getPillSchedules() async {
    try {
      final response = await _apiService.fetchPillSchedules();
      return (response as List)
          .map((json) => PillScheduleModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pill schedules: $e');
    }
  }

  @override
  Future<void> updatePillSchedule(PillScheduleModel schedule) async {
    try {
      await _apiService.updatePillSchedule(schedule.id, schedule.toJson());
    } catch (e) {
      throw Exception('Failed to update pill schedule: $e');
    }
  }
}
