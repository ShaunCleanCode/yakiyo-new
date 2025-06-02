import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//	AuthService: 로그인 상태 확인만 담당

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  static final AuthService _instance = AuthService._internal();
  static const String _tokenKey = 'auth_token';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // 현재 사용자 상태 확인
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;

  // 토큰 유효성 체크
  Future<bool> isTokenValid() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // 토큰 새로고침 시도
      await currentUser.getIdToken(true);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 구글 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _auth.signOut(),
    ]);
    await clearToken();
  }

  // 토큰 저장
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // 토큰 삭제
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
