import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

class UpdateUserDevice {
  final IAuthRepository repository;

  UpdateUserDevice(this.repository);

  Future<User?> call(String deviceId) async {
    return await repository.updateUserDevice(deviceId);
  }
}
