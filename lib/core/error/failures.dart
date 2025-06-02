abstract class Failure {
  final String message;
  final String title;

  const Failure({
    required this.message,
    required this.title,
  });
}

class ServerFailure extends Failure {
  const ServerFailure()
      : super(
          message: '서버에 연결할 수 없습니다.\n잠시 후 다시 시도해주세요.',
          title: '서버 오류',
        );
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure()
      : super(
          message: '인증이 만료되었습니다.\n다시 로그인해주세요.',
          title: '인증 오류',
        );
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super(
          message: '네트워크 연결을 확인해주세요.',
          title: '네트워크 오류',
        );
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message: message, title: '캐시 오류');
}

class DeviceFailure extends Failure {
  const DeviceFailure(String message) : super(message: message, title: '기기 오류');
}
