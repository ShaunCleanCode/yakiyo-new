import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<User?> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }

  @override
  Future<User?> signInWithGoogle() async {
    return await _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }

  @override
  Future<bool> isSignedIn() async {
    return await _remoteDataSource.isSignedIn();
  }

  @override
  Future<User?> updateUserDevice(String deviceId) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) return null;

    // TODO: Implement device ID update logic with backend
    return currentUser;
  }

  @override
  Stream<User?> get authStateChanges {
    return _remoteDataSource.authStateChanges;
  }
}
