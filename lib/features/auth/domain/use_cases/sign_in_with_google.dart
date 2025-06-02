import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

class SignInWithGoogle {
  final IAuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<User?> call() async {
    return await repository.signInWithGoogle();
  }
}
