import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:yakiyo/features/intake_log/presentation/screens/intake_log_screen.dart';
import 'package:yakiyo/features/intake_log/presentation/providers/intake_log_provider.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/day_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/time_slot_model.dart';
import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';
import 'package:yakiyo/features/pill_schedule/data/repositories/mock_pill_schedule_repository.dart';
import 'package:yakiyo/features/intake_log/data/models/pill_intake_log_model.dart';

void main() {
  late ProviderContainer container;
  late MockBuildContext context;

  setUp(() {
    container = ProviderContainer();
    context = MockBuildContext();
  });

  tearDown(() {
    container.dispose();
  });

  group('IntakeLogScreen Tests', () {
    testWidgets('renders intake log screen correctly',
        (WidgetTester tester) async {
      // Arrange
      final pillSchedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
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

      container = ProviderContainer(
        overrides: [
          pillScheduleProvider.overrideWith(
            (ref) => PillScheduleNotifier(MockPillScheduleRepository())
              ..state = AsyncData([pillSchedule]),
          ),
          intakeLogProvider.overrideWith(
            (ref) => IntakeLogNotifier(),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: IntakeLogScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('복용 기록'), findsOneWidget);
      expect(find.byType(CalendarDatePicker), findsOneWidget);
    });

    testWidgets('displays intake statistics correctly',
        (WidgetTester tester) async {
      // Arrange
      final pillSchedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
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

      final intakeLog = PillIntakeLogModel(
        id: '1',
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: DateTime(2024, 1, 1, 8, 0),
        quantity: 1,
      );

      container = ProviderContainer(
        overrides: [
          pillScheduleProvider.overrideWith(
            (ref) => PillScheduleNotifier(MockPillScheduleRepository())
              ..state = AsyncData([pillSchedule]),
          ),
          intakeLogProvider.overrideWith(
            (ref) => IntakeLogNotifier()..state = [intakeLog],
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: IntakeLogScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('복용 통계'), findsOneWidget);
      expect(find.text('아침'), findsOneWidget);
      expect(find.text('점심'), findsOneWidget);
      expect(find.text('저녁'), findsOneWidget);
    });

    testWidgets('navigates between months correctly',
        (WidgetTester tester) async {
      // Arrange
      final pillSchedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
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

      container = ProviderContainer(
        overrides: [
          pillScheduleProvider.overrideWith(
            (ref) => PillScheduleNotifier(MockPillScheduleRepository())
              ..state = AsyncData([pillSchedule]),
          ),
          intakeLogProvider.overrideWith(
            (ref) => IntakeLogNotifier(),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: IntakeLogScreen(),
          ),
        ),
      );

      // Find and tap the next month button
      final nextMonthButton = find.byIcon(Icons.chevron_right);
      await tester.tap(nextMonthButton);
      await tester.pumpAndSettle();

      // Assert
      final currentMonth = DateTime.now().month;
      final nextMonth = currentMonth == 12 ? 1 : currentMonth + 1;
      expect(find.text('$nextMonth월'), findsOneWidget);
    });

    testWidgets('shows consent dialog when sharing stats',
        (WidgetTester tester) async {
      // Arrange
      final pillSchedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
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

      container = ProviderContainer(
        overrides: [
          pillScheduleProvider.overrideWith(
            (ref) => PillScheduleNotifier(MockPillScheduleRepository())
              ..state = AsyncData([pillSchedule]),
          ),
          intakeLogProvider.overrideWith(
            (ref) => IntakeLogNotifier(),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: IntakeLogScreen(),
          ),
        ),
      );

      // Find and tap the share button
      final shareButton = find.byIcon(Icons.share);
      await tester.tap(shareButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('복용 통계 공유하기'), findsOneWidget);
      expect(find.text('개인정보 수집 및 이용에 동의하시겠습니까?'), findsOneWidget);
    });

    testWidgets('displays correct intake status for dates',
        (WidgetTester tester) async {
      // Arrange
      final pillSchedule = PillScheduleModel(
        id: '1',
        name: 'Morning Pills',
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

      final intakeLog = PillIntakeLogModel(
        id: '1',
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: DateTime.now(),
        quantity: 1,
      );

      container = ProviderContainer(
        overrides: [
          pillScheduleProvider.overrideWith(
            (ref) => PillScheduleNotifier(MockPillScheduleRepository())
              ..state = AsyncData([pillSchedule]),
          ),
          intakeLogProvider.overrideWith(
            (ref) => IntakeLogNotifier()..state = [intakeLog],
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: IntakeLogScreen(),
          ),
        ),
      );

      // Assert
      final today = DateTime.now();
      final todayCell =
          find.byKey(ValueKey('${today.year}-${today.month}-${today.day}'));
      expect(todayCell, findsOneWidget);
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
