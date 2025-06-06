import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/home_provider.dart';
import '../../../pill_schedule/data/models/time_slot_model.dart';
import '../../../pill_schedule/data/models/pill_schedule_model.dart';
import '../../../intake_log/presentation/providers/intake_log_provider.dart';
import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();

  String getTimeLabel(TimeSlotModel slot) {
    final hour = slot.time.hour;
    if (hour >= 5 && hour < 11) return '아침';
    if (hour >= 11 && hour < 15) return '점심';
    if (hour >= 15 && hour < 24) return '저녁';
    return '기타';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schedulesAsync = ref.watch(pillScheduleProvider);
    final isRefreshing = ref.watch(homeRefreshingProvider);

    return schedulesAsync.when(
      data: (schedules) {
        // 오늘 요일
        final today = DateTime.now().weekday;
        // 오늘 복용해야 하는 스케줄만 필터링
        final todaySchedules = schedules
            .where((schedule) =>
                schedule.daySchedules.any((day) => day.dayOfWeek == today))
            .toList();

        if (todaySchedules.isEmpty) {
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
                    // 약 스케줄 PageView
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.6, // 화면 높이의 60%
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: todaySchedules.length,
                        itemBuilder: (context, index) {
                          final schedule = todaySchedules[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: PillScheduleCard(
                              schedule: schedule,
                              onIntake: () {
                                final nextSlotWithId =
                                    ref.read(nextIntakeWithPillIdProvider);
                                if (nextSlotWithId != null) {
                                  ref.read(intakeLogProvider.notifier).add(
                                        pillScheduleId:
                                            nextSlotWithId.pillScheduleId,
                                        timeSlotId: nextSlotWithId.slot.id,
                                        intakeTime: DateTime.now(),
                                        quantity: 1,
                                      );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 페이지 인디케이터
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: todaySchedules.length,
                      effect: const WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        type: WormType.thin,
                        activeDotColor: Colors.black,
                      ),
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
}

class PillScheduleCard extends ConsumerWidget {
  final PillScheduleModel schedule;
  final VoidCallback onIntake;

  const PillScheduleCard({
    super.key,
    required this.schedule,
    required this.onIntake,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = now.weekday;
    // 오늘 요일에 해당하는 slot만 추출
    final todaySlots = schedule.daySchedules
        .where((ds) => ds.dayOfWeek == today)
        .expand((ds) => ds.timeSlots)
        .toList();
    // 복용 기록
    final intakeStatus = ref.watch(todayIntakeStatusProvider);
    // 아직 복용하지 않은 slot만 필터링
    final remaining = todaySlots
        .where((slot) =>
            !(intakeStatus[slot.id] ?? false) &&
            DateTime(now.year, now.month, now.day, slot.time.hour,
                    slot.time.minute)
                .isAfter(now))
        .toList();
    remaining.sort((a, b) => a.time.compareTo(b.time));
    final nextSlot = remaining.isNotEmpty ? remaining.first : null;
    final nextTime = nextSlot != null
        ? DateTime(now.year, now.month, now.day, nextSlot.time.hour,
            nextSlot.time.minute)
        : null;
    final isTaken = nextSlot == null;
    // 시간대 라벨링 함수
    String getTimeLabel(TimeSlotModel slot) {
      final hour = slot.time.hour;
      if (hour >= 5 && hour < 11) return '아침';
      if (hour >= 11 && hour < 15) return '점심';
      if (hour >= 15 && hour < 24) return '저녁';
      return '기타';
    }

    // 남은 시간 메시지 및 시간대
    String nextIntakeMsg;
    String? nextIntakeLabel;
    bool isWithinWindow = false;
    if (nextSlot == null) {
      nextIntakeMsg = '이 약은 오늘 다 복용하셨어요';
      nextIntakeLabel = null;
    } else {
      final difference = nextTime!.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      isWithinWindow = difference.inMinutes.abs() <= 30;
      nextIntakeLabel = getTimeLabel(nextSlot);
      if (isWithinWindow) {
        nextIntakeMsg = '약 드실 시간입니다!';
      } else if (hours > 0) {
        nextIntakeMsg = '$hours시간 $minutes분';
      } else {
        nextIntakeMsg = '$minutes분';
      }
    }
    // 오늘의 복용 현황: 실제 slot 시간대만
    final slotLabels = todaySlots.map(getTimeLabel).toSet().toList();
    // 시간대별 slot 매핑
    final Map<String, TimeSlotModel?> slotByLabel = {};
    for (final slot in todaySlots) {
      final label = getTimeLabel(slot);
      slotByLabel[label] = slot;
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4, // 그림자 효과 추가
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 약 이름
              Row(
                children: [
                  Expanded(
                    child: Text(
                      schedule.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.medication, color: Colors.grey[400]),
                ],
              ),
              const SizedBox(height: 24),
              // 다음 복용 시간대 및 남은 시간 (센터 정렬)
              if (nextIntakeLabel != null) ...[
                Center(
                  child: Text(
                    '다음 $nextIntakeLabel약 복용까지',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    nextIntakeMsg,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ] else ...[
                Center(
                  child: Text(
                    nextIntakeMsg,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: isWithinWindow ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTaken
                        ? '오늘 복용을 모두 완료하셨습니다.'
                        : isWithinWindow
                            ? '지금 약을 복용해주세요!'
                            : '아직 약을 복용하지 않으셨습니다.',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 오늘의 복용 현황 (해당 약의 slot 시간대만)
              const Text('오늘의 복용 현황', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: slotLabels
                      .map((label) =>
                          _buildDot(label, slotByLabel[label], intakeStatus))
                      .toList(),
                ),
              ),
              const Spacer(),
              // 복용 확인 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (isTaken || !isWithinWindow)
                      ? null
                      : () {
                          ref.read(intakeLogProvider.notifier).add(
                                pillScheduleId: schedule.id,
                                timeSlotId: nextSlot.id,
                                intakeTime: DateTime.now(),
                                quantity: 1,
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isTaken || !isWithinWindow)
                        ? Colors.grey[300]
                        : Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('복용 확인'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isTaken
                    ? '복용이 임박해지면 활성화돼요'
                    : !isWithinWindow
                        ? '복용 시간 30분 전부터 활성화돼요'
                        : '',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(
      String label, TimeSlotModel? slot, Map<String, bool> intakeStatus) {
    final taken = slot != null ? (intakeStatus[slot.id] ?? false) : false;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: taken ? Colors.green.withOpacity(0.1) : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.circle,
            color: taken ? Colors.green : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: taken ? Colors.green : Colors.grey[600],
            fontWeight: taken ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String getTimeLabel(TimeSlotModel slot) {
    final hour = slot.time.hour;
    if (hour >= 5 && hour < 11) return '아침';
    if (hour >= 11 && hour < 15) return '점심';
    if (hour >= 15 && hour < 24) return '저녁';
    return '기타';
  }
}
