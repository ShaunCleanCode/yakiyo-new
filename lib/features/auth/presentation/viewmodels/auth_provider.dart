import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yakiyo/core/routes/app_router.dart';
import 'package:yakiyo/core/constants/routes_constants.dart';
import 'package:yakiyo/features/settings/presentation/providers/nickname_provider.dart';

final authCredentialProvider = StateProvider<AuthCredential?>((ref) => null);

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final notifier = AuthNotifier(firebaseAuth: firebaseAuth);
  ref.onDispose(() {
    // 필요한 정리 작업
  });
  return notifier;
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth;

  AuthNotifier({required FirebaseAuth firebaseAuth})
      : _auth = firebaseAuth,
        super(const AsyncValue.data(null));

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;

  Future<void> signInWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      print('구글 로그인 시작...');
      state = const AsyncValue.loading();

      // 기존 로그인 상태 확인
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        print('이미 로그인된 사용자가 있습니다: ${currentUser.email}');
        await signOut(ref);
      }

      print('구글 로그인 시도...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('구글 로그인이 취소되었습니다.');
        state = const AsyncValue.data(null);
        return;
      }
      print('구글 로그인 성공: ${googleUser.email}');

      print('구글 인증 토큰 요청...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('구글 인증 토큰 획득 성공');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // credential 저장
      ref.read(authCredentialProvider.notifier).state = credential;
      print('credential 저장 완료');

      print('Firebase 인증 시도...');
      final userCredential = await _auth.signInWithCredential(credential);
      print('Firebase 인증 성공: ${userCredential.user?.email}');

      // 닉네임(이름) 저장
      final user = userCredential.user;
      final nickname =
          user?.displayName ?? user?.email?.split('@').first ?? '사용자';
      ref.read(nicknameProvider.notifier).state = nickname;

      state = AsyncValue.data(userCredential.user);

      // Navigate to HomeScreen after successful login
      if (context.mounted) {
        print('홈 화면으로 이동...');
        AppRouter.pushReplacement(context, RoutesConstants.home);
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException 발생: ${e.code} - ${e.message}');
      state = AsyncValue.error(e, e.stackTrace ?? StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 중 오류가 발생했습니다: ${e.message}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e, stack) {
      print('일반 Exception 발생: $e');
      print('스택 트레이스: $stack');
      state = AsyncValue.error(e, stack);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인 중 오류가 발생했습니다.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> signOut(WidgetRef ref) async {
    try {
      print('로그아웃 시작...');
      await _googleSignIn.signOut();
      print('구글 로그아웃 완료');
      await _auth.signOut();
      print('Firebase 로그아웃 완료');
      // credential 초기화
      ref.read(authCredentialProvider.notifier).state = null;
      print('credential 초기화 완료');
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      print('로그아웃 중 오류 발생: $e');
      print('스택 트레이스: $stack');
      state = AsyncValue.error(e, stack);
    }
  }
}
