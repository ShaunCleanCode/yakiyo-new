import 'package:flutter/material.dart';
import 'package:yakiyo/core/error/failures.dart';
import 'package:yakiyo/core/error/error_messages.dart';

class ErrorDialog extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    required this.failure,
    this.onRetry,
  });

  static Future<void> show(
    BuildContext context, {
    required Failure failure,
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        failure: failure,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(failure.title),
      content: Text(failure.message),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry?.call();
            },
            child: const Text(ErrorMessages.retry),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(ErrorMessages.confirm),
        ),
      ],
    );
  }
}
