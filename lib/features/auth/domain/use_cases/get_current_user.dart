import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

class GetCurrentUser {
  final IAuthRepository repository;

  GetCurrentUser(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}
