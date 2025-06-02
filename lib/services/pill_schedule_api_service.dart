import 'api_service.dart';

class PillScheduleApiService {
  final ApiService _apiService;

  PillScheduleApiService(this._apiService);

  Future<dynamic> fetchPillSchedules() {
    return _apiService.get('/pill-schedules');
  }

  Future<dynamic> fetchPillScheduleDetail(String id) {
    return _apiService.get('/pill-schedules/$id');
  }

  Future<dynamic> addPillSchedule(Map<String, dynamic> data) {
    return _apiService.post('/pill-schedules', data: data);
  }

  Future<dynamic> updatePillSchedule(String id, Map<String, dynamic> data) {
    return _apiService.put('/pill-schedules/$id', data: data);
  }

  Future<dynamic> deletePillSchedule(String id) {
    return _apiService.delete('/pill-schedules/$id');
  }
}
