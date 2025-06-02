import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'package:yakiyo/core/constants/assets_constants.dart';
import 'package:yakiyo/core/constants/string_constants.dart';
import 'package:yakiyo/features/auth/presentation/viewmodels/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsConstants.appLogoPng,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 24),
              Text(
                StringConstants.loginSubtitle,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              SignInButton(
                Buttons.google,
                onPressed: () async {
                  await ref
                      .read(authProvider.notifier)
                      .signInWithGoogle(context);
                },
              ),
              const SizedBox(height: 32),
              Text(
                StringConstants.loginNotice,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
