import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yakiyo/core/constants/string_constants.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../pill_schedule/presentation/providers/pill_schedule_provider.dart';

class DeviceStatusScreen extends ConsumerWidget {
  const DeviceStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSchedulesAsync = ref.watch(pillScheduleProvider);

    return pillSchedulesAsync.when(
      data: (pillSchedules) {
        if (pillSchedules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetsConstants.emptyPillPng,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 16),
                const Text(
                  StringConstants.emptyPillMessage,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }
        // pillSchedules가 있을 때의 UI
        return ListView(
          children: const [
            // pillSchedules.map(...) 등으로 실제 데이터 표시
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('에러: $e')),
    );
  }
}
