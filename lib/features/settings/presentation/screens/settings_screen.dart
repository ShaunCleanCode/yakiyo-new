import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/nickname_provider.dart';
import '../../../auth/presentation/viewmodels/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  final VoidCallback? onClose;
  const SettingsScreen({super.key, this.onClose});

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('회원 탈퇴 실패: 현재 로그인된 사용자가 없습니다.');
      return;
    }

    try {
      print('회원 탈퇴 시작: ${user.email}');

      // 저장된 credential 확인
      final savedCredential = ref.read(authCredentialProvider);
      if (savedCredential == null) {
        // 저장된 credential이 없는 경우 새로운 구글 로그인 수행
        final GoogleSignIn googleSignIn = GoogleSignIn();
        print('구글 재인증 시도...');
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          throw FirebaseAuthException(
            code: 'sign-in-cancelled',
            message: '구글 로그인이 취소되었습니다.',
          );
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);
      } else {
        // 저장된 credential로 재인증
        print('저장된 credential로 재인증 시도...');
        await user.reauthenticateWithCredential(savedCredential);
      }
      print('구글 재인증 성공');

      // 계정 삭제
      print('계정 삭제 시도...');
      await user.delete();
      print('계정 삭제 성공');

      // 상태 초기화
      ref.invalidate(nicknameProvider);
      ref.read(authCredentialProvider.notifier).state = null;

      if (context.mounted) {
        // 로그인 페이지로 이동 (스택 모두 제거)
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException 발생: ${e.code} - ${e.message}');
      if (context.mounted) {
        String errorMessage = '회원 탈퇴 중 오류가 발생했습니다.';
        if (e.code == 'requires-recent-login') {
          errorMessage = '보안을 위해 다시 로그인해주세요.';
        } else if (e.code == 'user-not-found') {
          errorMessage = '사용자를 찾을 수 없습니다.';
        } else if (e.code == 'invalid-credential') {
          errorMessage = '인증 정보가 유효하지 않습니다.';
        } else if (e.code == 'network-request-failed') {
          errorMessage = '네트워크 연결을 확인해주세요.';
        } else if (e.code == 'sign-in-cancelled') {
          errorMessage = '구글 로그인이 취소되었습니다.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('일반 Exception 발생: $e');
      print('스택 트레이스: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('회원 탈퇴 중 오류가 발생했습니다.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname = ref.watch(nicknameProvider);
    final nicknameController = TextEditingController(text: nickname ?? '');
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('마이페이지',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person, size: 36)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nickname == null || nickname.isEmpty
                            ? '닉네임을 설정해주세요.'
                            : nickname,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '이메일 정보 없음',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ListTile(
              title: const Text('닉네임 설정'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final controller =
                        TextEditingController(text: nickname ?? '');
                    return AlertDialog(
                      title: const Text('닉네임 설정'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: '닉네임을 입력해주세요',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('취소'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(nicknameProvider.notifier).state =
                                controller.text.trim();
                            Navigator.of(context).pop();
                          },
                          child: const Text('저장하기'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: const Text('회원 탈퇴'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('회원 탈퇴'),
                    content: const Text(
                      '정말로 회원을 탈퇴하시겠습니까?\n'
                      '탈퇴 후에는 복구할 수 없습니다.\n'
                      '보안을 위해 다시 로그인해야 할 수 있습니다.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('탈퇴하기'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await _deleteAccount(context, ref);
                }
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: const Text('로그아웃'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('로그아웃'),
                    content: const Text('정말로 로그아웃 하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await FirebaseAuth.instance.signOut();
                    // 상태 초기화
                    ref.invalidate(nicknameProvider);
                    ref.read(authCredentialProvider.notifier).state = null;
                    // 로그인 페이지로 이동 (스택 모두 제거)
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('로그아웃 중 오류가 발생했습니다.'),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
