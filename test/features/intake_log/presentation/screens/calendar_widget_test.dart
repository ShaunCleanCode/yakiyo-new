import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakiyo/features/intake_log/presentation/screens/intake_log_screen.dart';
import 'package:yakiyo/features/intake_log/presentation/providers/intake_log_provider.dart';
import 'package:yakiyo/features/intake_log/data/models/pill_intake_log_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/day_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/time_slot_model.dart';
import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';
import 'package:yakiyo/features/pill_schedule/data/repositories/mock_pill_schedule_repository.dart';
import 'package:yakiyo/features/intake_log/presentation/providers/intake_log_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('달력 날짜별 색상 테스트', (WidgetTester tester) async {
    // Arrange
    final pillSchedule = PillScheduleModel(
      id: '1',
      name: '혈압약',
      description: '',
      daySchedules: [
        DayScheduleModel(
          id: '1',
          dayOfWeek: DateTime.now().weekday,
          timeSlots: [
            TimeSlotModel(
              id: '1',
              time: DateTime(2024, 1, 1, 8, 0),
              quantity: 1,
            ),
          ],
        ),
      ],
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 12, 31),
      isActive: true,
    );

    final intakeLogs = [
      PillIntakeLogModel(
        id: '1',
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: DateTime(2024, 6, 6, 8, 10),
        quantity: 1,
      ),
    ];

    container = ProviderContainer(
      overrides: [
        pillScheduleProvider.overrideWith(
          (ref) => PillScheduleNotifier(MockPillScheduleRepository())
            ..state = AsyncData([pillSchedule]),
        ),
        intakeLogProvider.overrideWith(
          (ref) => IntakeLogNotifier()..state = intakeLogs,
        ),
      ],
    );

    // Act & Assert
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: IntakeLogScreen(initialMonth: DateTime(2024, 6, 1)),
        ),
      ),
    );

    // Wait for any pending timers
    await tester.pumpAndSettle();

    // 6월 6일 셀이 존재하는지 확인
    final day6Finder = find.byKey(const Key('calendar-day-2024-06-06'));
    expect(day6Finder, findsOneWidget);

    // 6월 2일 셀이 존재하는지 확인
    final day2Finder = find.byKey(const Key('calendar-day-2024-06-02'));
    expect(day2Finder, findsOneWidget);

    // 달력 헤더가 올바르게 표시되는지 확인
    expect(find.text('M'), findsOneWidget);
    expect(find.text('T'), findsNWidgets(2));
    expect(find.text('W'), findsOneWidget);
    expect(find.text('F'), findsOneWidget);
    expect(find.text('S'), findsNWidgets(2));
  });
}
