import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakiyo/features/settings/presentation/providers/nickname_provider.dart';
import 'package:yakiyo/common/widgets/app_logo.dart';
import 'package:yakiyo/core/constants/assets_constants.dart';

class IntakeLogScreen extends ConsumerStatefulWidget {
  final DateTime? initialMonth;
  const IntakeLogScreen({super.key, this.initialMonth});

  @override
  ConsumerState<IntakeLogScreen> createState() => _IntakeLogScreenState();
}

class _IntakeLogScreenState extends ConsumerState<IntakeLogScreen> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.initialMonth ??
        DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  List<DateTime> _getCalendarDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0:일 ~ 6:토
    final daysBefore = firstWeekday;
    final totalDays = daysBefore + lastDayOfMonth.day;
    final weeks = (totalDays / 7).ceil();
    final daysAfter = weeks * 7 - totalDays;

    final firstDayToShow = firstDayOfMonth.subtract(Duration(days: daysBefore));
    return List.generate(
      weeks * 7,
      (i) => firstDayToShow.add(Duration(days: i)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nickname = ref.watch(nicknameProvider) ?? '사용자';
    final now = DateTime.now();
    final month = _focusedMonth.month;
    final days = _getCalendarDays(_focusedMonth);
    final isCurrentMonth =
        _focusedMonth.year == now.year && _focusedMonth.month == now.month;
    final List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              '$nickname 님의 $month월 약 복용 현황',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 상단 연/월 및 이동 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _goToPreviousMonth,
                      ),
                      Text(
                        DateFormat('yyyy.MM').format(_focusedMonth),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _goToNextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 요일 헤더
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekDays
                        .map((d) => Expanded(
                              child: Center(
                                child: Text(
                                  d,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // 달력 날짜
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final isThisMonth = day.month == _focusedMonth.month;
                      final isToday =
                          isCurrentMonth && day.day == now.day && isThisMonth;
                      final isPrevOrNextMonth = !isThisMonth;

                      // 상태 결정: 실제 복용 기록 기반
                      PillIntakeStatus status;
                      final dateKey = DateTime(day.year, day.month, day.day);
                      final details = dummyIntakeDetails[dateKey];
                      if (!isThisMonth) {
                        status = PillIntakeStatus.notRequired;
                      } else if (day.isAfter(now)) {
                        status = PillIntakeStatus.upcoming;
                      } else if (details == null) {
                        status = PillIntakeStatus.notRequired;
                      } else {
                        final allTaken = details.every((d) => d.taken);
                        final noneTaken = details.every((d) => !d.taken);
                        if (allTaken) {
                          status = PillIntakeStatus.allTaken;
                        } else if (noneTaken) {
                          status = PillIntakeStatus.none;
                        } else {
                          status = PillIntakeStatus.partial;
                        }
                      }

                      return GestureDetector(
                        key: Key(
                            'calendar-day-${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}'),
                        onTap: isThisMonth
                            ? () {
                                final dateKey =
                                    DateTime(day.year, day.month, day.day);
                                final details = dummyIntakeDetails[dateKey];
                                final status = dummyStatus[dateKey] ??
                                    (!isThisMonth
                                        ? PillIntakeStatus.notRequired
                                        : (day.isAfter(now)
                                            ? PillIntakeStatus.upcoming
                                            : PillIntakeStatus.upcoming));
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        DateFormat('yyyy.MM.dd').format(day)),
                                    content: details == null
                                        ? Text(
                                            '상태: ${status.toString().split('.').last}\n복용 기록 없음')
                                        : SizedBox(
                                            width: 250,
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: details.length,
                                              separatorBuilder: (_, __) =>
                                                  const Divider(height: 12),
                                              itemBuilder: (context, idx) {
                                                final d = details[idx];
                                                return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      d.taken
                                                          ? Icons.check_circle
                                                          : Icons.cancel,
                                                      color: d.taken
                                                          ? Colors.green
                                                          : Colors.red,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            d.pillName,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                              '예정: ${d.scheduledTime}'),
                                                          Text(
                                                            d.takenTime != null
                                                                ? '복용: ${d.takenTime}'
                                                                : '미복용',
                                                            style: TextStyle(
                                                              color: d.taken
                                                                  ? Colors.black
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('닫기'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            : null,
                        child: SizedBox.expand(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: isPrevOrNextMonth
                                      ? Colors.grey[400]
                                      : Colors.black,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: getStatusColor(status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // 통계 안내 버튼 (정확히 325x115, 입체감, 로고, 안내문구, 화살표)
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: 통계 그래프 화면 이동
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 115,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 24),
                      Image.asset(
                        AssetsConstants.appLogoPng,
                        width: 48,
                        height: 48,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '약 복용 통계 정보를 보여드려요',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              '클릭해서 그래프 확인하기',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 24),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> _extractTimeSlots(PillScheduleModel schedule) {
  if (schedule.daySchedules.isEmpty) return [];
  final firstDay = schedule.daySchedules.first;
  final timeSlots = <String>[];
  for (var timeSlot in firstDay.timeSlots) {
    final hour = timeSlot.time.hour;
    if (hour >= 5 && hour < 11 && !timeSlots.contains('아침')) {
      timeSlots.add('아침');
    } else if (hour >= 11 && hour < 15 && !timeSlots.contains('점심')) {
      timeSlots.add('점심');
    } else if (hour >= 15 && hour < 21 && !timeSlots.contains('저녁')) {
      timeSlots.add('저녁');
    }
  }
  return timeSlots;
}

enum PillIntakeStatus { allTaken, partial, none, upcoming, notRequired }

Color getStatusColor(PillIntakeStatus status) {
  switch (status) {
    case PillIntakeStatus.allTaken:
      return const Color(0xFF4CAF50); // 초록
    case PillIntakeStatus.partial:
      return const Color(0xFFFFA726); // 주황
    case PillIntakeStatus.none:
      return const Color(0xFFE53935); // 빨강
    case PillIntakeStatus.upcoming:
      return const Color(0xFFBDBDBD); // 연회색
    case PillIntakeStatus.notRequired:
      return Colors.black; // 검정
  }
}

// 6월 한 달치(1~30일) 알록달록하게 상태 분포
final Map<DateTime, PillIntakeStatus> dummyStatus = {
  for (int i = 1; i <= 30; i++)
    DateTime(2024, 6, i): PillIntakeStatus.values[(i - 1) % 5],
};

class PillIntakeDetail {
  final String pillName;
  final String scheduledTime; // "08:00"
  final String? takenTime; // "08:05" or null
  final bool taken; // true/false

  PillIntakeDetail({
    required this.pillName,
    required this.scheduledTime,
    this.takenTime,
    required this.taken,
  });
}

// 6월 1~10일 다양한 복용 기록 예시 (실제 앱에서는 더 확장 가능)
final Map<DateTime, List<PillIntakeDetail>> dummyIntakeDetails = {
  DateTime(2024, 6, 1): [
    PillIntakeDetail(
        pillName: '혈압약',
        scheduledTime: '08:00',
        takenTime: '08:05',
        taken: true),
    PillIntakeDetail(
        pillName: '비타민', scheduledTime: '12:00', takenTime: null, taken: false),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: '20:10',
        taken: true),
  ],
  DateTime(2024, 6, 2): [
    PillIntakeDetail(
        pillName: '혈압약', scheduledTime: '08:00', takenTime: null, taken: false),
    PillIntakeDetail(
        pillName: '비타민', scheduledTime: '12:00', takenTime: null, taken: false),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: null,
        taken: false),
  ],
  DateTime(2024, 6, 3): [
    PillIntakeDetail(
        pillName: '혈압약',
        scheduledTime: '08:00',
        takenTime: '08:01',
        taken: true),
    PillIntakeDetail(
        pillName: '비타민',
        scheduledTime: '12:00',
        takenTime: '12:10',
        taken: true),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: null,
        taken: false),
  ],
  DateTime(2024, 6, 4): [
    PillIntakeDetail(
        pillName: '혈압약',
        scheduledTime: '08:00',
        takenTime: '08:00',
        taken: true),
    PillIntakeDetail(
        pillName: '비타민',
        scheduledTime: '12:00',
        takenTime: '12:00',
        taken: true),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: '20:00',
        taken: true),
  ],
  DateTime(2024, 6, 5): [
    PillIntakeDetail(
        pillName: '혈압약', scheduledTime: '08:00', takenTime: null, taken: false),
    PillIntakeDetail(
        pillName: '비타민', scheduledTime: '12:00', takenTime: null, taken: false),
  ],
  DateTime(2024, 6, 6): [
    PillIntakeDetail(
        pillName: '혈압약',
        scheduledTime: '08:00',
        takenTime: '08:10',
        taken: true),
    PillIntakeDetail(
        pillName: '비타민', scheduledTime: '12:00', takenTime: null, taken: false),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: null,
        taken: false),
  ],
  DateTime(2024, 6, 7): [
    PillIntakeDetail(
        pillName: '혈압약',
        scheduledTime: '08:00',
        takenTime: '08:00',
        taken: true),
    PillIntakeDetail(
        pillName: '비타민',
        scheduledTime: '12:00',
        takenTime: '12:00',
        taken: true),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: '20:00',
        taken: true),
  ],
  DateTime(2024, 6, 8): [
    PillIntakeDetail(
        pillName: '혈압약', scheduledTime: '08:00', takenTime: null, taken: false),
    PillIntakeDetail(
        pillName: '비타민', scheduledTime: '12:00', takenTime: null, taken: false),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: null,
        taken: false),
  ],
  DateTime(2024, 6, 9): [
    PillIntakeDetail(
        pillName: '혈압약',
        scheduledTime: '08:00',
        takenTime: '08:05',
        taken: true),
    PillIntakeDetail(
        pillName: '비타민',
        scheduledTime: '12:00',
        takenTime: '12:10',
        taken: true),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: null,
        taken: false),
  ],
  DateTime(2024, 6, 10): [
    PillIntakeDetail(
        pillName: '혈압약',
        scheduledTime: '08:00',
        takenTime: '08:00',
        taken: true),
    PillIntakeDetail(
        pillName: '비타민',
        scheduledTime: '12:00',
        takenTime: '12:00',
        taken: true),
    PillIntakeDetail(
        pillName: '오메가3',
        scheduledTime: '20:00',
        takenTime: '20:00',
        taken: true),
  ],
};
