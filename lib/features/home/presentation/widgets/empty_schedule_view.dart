import 'package:flutter/material.dart';
import 'package:yakiyo/common/widgets/empty_pill.dart';

/// Widget displayed when there are no medication schedules
class EmptyScheduleView extends StatelessWidget {
  const EmptyScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyPill(width: 140, height: 140),
            const SizedBox(height: 24),
            const Text(
              '나만의 약 스케줄을 추가해보세요',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
