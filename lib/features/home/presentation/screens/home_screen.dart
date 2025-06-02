import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import '../../../pill_schedule/data/models/time_slot_model.dart';
import '../../../intake_log/presentation/providers/intake_log_provider.dart';
import '../../../pill_schedule/presentation/providers/pill_schedule_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String getTimeLabel(TimeSlotModel slot) {
    final hour = slot.time.hour;
    if (hour >= 5 && hour < 11) return '아침';
    if (hour >= 11 && hour < 15) return '점심';
    if (hour >= 15 && hour < 21) return '저녁';
    return '기타';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(pillScheduleProvider);
    final isRefreshing = ref.watch(homeRefreshingProvider);

    return schedulesAsync.when(
      data: (_) {
        final todaySlotsWithId = ref.watch(todayScheduleWithPillIdProvider);
        final intakeStatus = ref.watch(todayIntakeStatusProvider);
        final nextSlotWithId = ref.watch(nextIntakeWithPillIdProvider);

        if (todaySlotsWithId.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            body: Center(
              child: Text(
                '등록된 약이 없습니다.\n약을 추가해 주세요!',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final now = DateTime.now();
        final nextTime = nextSlotWithId != null
            ? DateTime(now.year, now.month, now.day,
                nextSlotWithId.slot.time.hour, nextSlotWithId.slot.time.minute)
            : null;
        final hoursLeft =
            nextTime != null ? nextTime.difference(now).inHours : 0;
        final isTaken = nextSlotWithId == null;

        // 시간대별로 slot을 분류
        final Map<String, SlotWithScheduleId?> slotByLabel = {};
        for (final slotWithId in todaySlotsWithId) {
          final label = getTimeLabel(slotWithId.slot);
          slotByLabel[label] = slotWithId;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.read(homeRefreshingProvider.notifier).state = true;
              ref.invalidate(pillScheduleProvider);
              await Future.delayed(const Duration(milliseconds: 600));
              ref.read(homeRefreshingProvider.notifier).state = false;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    if (isRefreshing)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text('새로고침 중...',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    // 상단 카드
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text('약 복용 섭취까지',
                                    style: TextStyle(fontSize: 16)),
                                const Spacer(),
                                Icon(Icons.menu, color: Colors.grey[400]),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              ref.watch(nextIntakeTimeMessageProvider),
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Icon(
                              Icons.circle,
                              color: ref.watch(isWithinIntakeWindowProvider)
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isTaken
                                  ? '오늘 복용을 모두 완료하셨습니다.'
                                  : ref.watch(isWithinIntakeWindowProvider)
                                      ? '지금 약을 복용해주세요!'
                                      : '아직 약을 복용하지 않으셨습니다.',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 오늘의 복용 현황 카드
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('오늘의 복용 현황',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: slotByLabel.entries
                                  .where((entry) => entry.value != null)
                                  .map((entry) => _buildDot(
                                      entry.key, entry.value, intakeStatus))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 복용 확인 버튼
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (isTaken ||
                                    !ref.watch(isWithinIntakeWindowProvider))
                                ? null
                                : () {
                                    ref.read(intakeLogProvider.notifier).add(
                                          pillScheduleId:
                                              nextSlotWithId.pillScheduleId,
                                          timeSlotId: nextSlotWithId.slot.id,
                                          intakeTime: DateTime.now(),
                                          quantity: 1,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (isTaken ||
                                      !ref.watch(isWithinIntakeWindowProvider))
                                  ? Colors.grey[300]
                                  : Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('복용 확인'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isTaken
                              ? '복용이 임박해지면 활성화돼요'
                              : !ref.watch(isWithinIntakeWindowProvider)
                                  ? '복용 시간 30분 전부터 활성화돼요'
                                  : '',
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: Center(child: Text('에러 발생: $e')),
      ),
    );
  }

  Widget _buildDot(String label, SlotWithScheduleId? slotWithId,
      Map<String, bool> intakeStatus) {
    final taken = slotWithId != null
        ? (intakeStatus[slotWithId.slot.id] ?? false)
        : false;
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 8),
        Icon(Icons.circle, color: taken ? Colors.green : Colors.grey, size: 20),
      ],
    );
  }
}
