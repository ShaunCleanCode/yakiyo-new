//	ServerHealthService: 서버 상태 확인만 담당

class HealthService {
  static final HealthService _instance = HealthService._internal();

  factory HealthService() {
    return _instance;
  }

  HealthService._internal();

  Future<bool> checkServerHealth() async {
    try {
      // TODO: 실제 서버 health check API 호출 구현
      await Future.delayed(const Duration(milliseconds: 3000)); // 임시 딜레이
      return true;
    } catch (e) {
      return false;
    }
  }
}
