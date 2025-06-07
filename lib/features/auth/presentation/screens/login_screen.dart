import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yakiyo/common/widgets/app_logo.dart';
import 'package:yakiyo/features/auth/presentation/viewmodels/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LogoSection(),
                SizedBox(height: 32),
                _LoginButtonSection(),
                SizedBox(height: 32),
                _LoginNoticeText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AppLogo(width: 100, height: 100),
        SizedBox(height: 24),
        Text(
          '간편하게 로그인하고 시작해보세요',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _LoginButtonSection extends ConsumerWidget {
  const _LoginButtonSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () async {
        await ref.read(authProvider.notifier).signInWithGoogle(context, ref);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            'https://www.google.com/favicon.ico',
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'Sign in with Google',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginNoticeText extends StatelessWidget {
  const _LoginNoticeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '다음 단계에서 약 복용 알림 권한을\n설정할 수 있어요',
      style: TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}
