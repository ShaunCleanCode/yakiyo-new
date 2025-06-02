import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<UserModel?> updateUserDevice(String deviceId);
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final firebase.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource({
    firebase.FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? firebase.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user != null
          ? UserModel.fromFirebaseUser(userCredential.user!)
          : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _auth.signOut(),
    ]);
  }

  @override
  Future<bool> isSignedIn() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    try {
      await currentUser.reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> updateUserDevice(String deviceId) async {
    final user = await getCurrentUser();
    if (user == null) return null;

    // TODO: Implement the actual device ID update logic with your backend
    return user.copyWith(deviceId: deviceId);
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }
}
