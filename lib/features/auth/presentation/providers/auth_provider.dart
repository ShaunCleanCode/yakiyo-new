import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/use_cases/get_current_user.dart';
import '../../domain/use_cases/sign_in_with_google.dart';
import '../../domain/use_cases/update_user_device.dart';

// Data source provider
final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

// Repository provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// Use case providers
final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUser(repository);
});

final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithGoogle(repository);
});

final updateUserDeviceProvider = Provider<UpdateUserDevice>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateUserDevice(repository);
});

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// Current user provider
final currentUserProvider = FutureProvider<User?>((ref) async {
  final getCurrentUser = ref.watch(getCurrentUserProvider);
  return await getCurrentUser();
});
