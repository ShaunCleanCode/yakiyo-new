import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakiyo/features/auth/presentation/viewmodels/auth_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  late ProviderContainer container;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthProvider Tests', () {
    test('초기 상태는 비인증(unauthenticated)이다', () {
      final state = container.read(authProvider);
      expect(state, isA<AsyncData>());
      expect((state as AsyncData).value, isNull);
    });

    test('로그아웃 후 상태는 null이어야 한다', () async {
      final notifier = container.read(authProvider.notifier);
      notifier.state = const AsyncValue.data(null);
      final state = container.read(authProvider);
      expect(state, isA<AsyncData>());
      expect((state as AsyncData).value, isNull);
    });

    test('로딩 상태로 전환되면 AsyncLoading이 된다', () {
      final notifier = container.read(authProvider.notifier);
      notifier.state = const AsyncValue.loading();
      final state = container.read(authProvider);
      expect(state, isA<AsyncLoading>());
    });

    test('에러 상태로 전환되면 AsyncError가 된다', () {
      final notifier = container.read(authProvider.notifier);
      final error = Exception('테스트 에러');
      notifier.state = AsyncValue.error(error, StackTrace.current);
      final state = container.read(authProvider);
      expect(state, isA<AsyncError>());
      expect((state as AsyncError).error, error);
    });

    test('로딩 → 데이터 → 에러 상태 전이', () {
      final notifier = container.read(authProvider.notifier);
      notifier.state = const AsyncValue.loading();
      expect(container.read(authProvider), isA<AsyncLoading>());
      notifier.state = const AsyncValue.data(null);
      expect(container.read(authProvider), isA<AsyncData>());
      final error = Exception('에러');
      notifier.state = AsyncValue.error(error, StackTrace.current);
      expect(container.read(authProvider), isA<AsyncError>());
    });
  });
}
