import '../entities/user.dart';

abstract class IAuthRepository {
  Future<User?> getCurrentUser();
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<User?> updateUserDevice(String deviceId);
  Stream<User?> get authStateChanges;
}
