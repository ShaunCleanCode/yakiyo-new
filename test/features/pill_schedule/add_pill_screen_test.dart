import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:yakiyo/features/pill_schedule/presentation/screens/add_pill_screen.dart';
import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/day_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/time_slot_model.dart';
import 'package:yakiyo/features/pill_schedule/data/repositories/mock_pill_schedule_repository.dart';
import 'package:yakiyo/common/widgets/pill_card.dart';
import 'package:yakiyo/common/widgets/pill_icon.dart';
import 'test_mock_pill_schedule_repository.dart';
import 'mocks/mock_pill_widgets.dart';
import 'mocks/mock_dialogs.dart';

class TestAddPillScreenWrapper extends StatelessWidget {
  const TestAddPillScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return AddPillScreen(
            onShowAddPillDialog: (context, ref) {
              showDialog(
                context: context,
                builder: (context) => const MockAddPillDialog(),
              );
            },
            onShowPillDetailDialog: (context, schedule) {
              showDialog(
                context: context,
                builder: (context) => MockPillDetailDialog(
                  schedule: schedule,
                  onEdit: () {
                    Navigator.of(context).pop();
                  },
                  onDelete: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  late ProviderContainer container;
  late TestMockPillScheduleRepository mockRepository;

  setUp(() {
    mockRepository = TestMockPillScheduleRepository();
    container = ProviderContainer(
      overrides: [
        pillScheduleRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AddPillScreen Tests', () {
    testWidgets('renders empty state correctly', (WidgetTester tester) async {
      // Arrange
      mockRepository.setMockSchedules([]);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestAddPillScreenWrapper(),
        ),
      );

      // Assert
      expect(find.text('알약 추가 화면'), findsOneWidget);
    });

    testWidgets('renders pill cards correctly', (WidgetTester tester) async {
      // Arrange
      final schedules = [
        PillScheduleModel(
          id: '1',
          name: 'Morning Pills',
          description: 'Take with breakfast',
          daySchedules: [
            DayScheduleModel(
              id: '1',
              dayOfWeek: 1,
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
        ),
      ];
      mockRepository.setMockSchedules(schedules);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestAddPillScreenWrapper(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Morning Pills'), findsOneWidget);
      expect(find.text('아침'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading',
        (WidgetTester tester) async {
      // Arrange
      mockRepository.setError(Exception('Loading'));

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestAddPillScreenWrapper(),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when error occurs',
        (WidgetTester tester) async {
      // Arrange
      mockRepository.setError(Exception('Test error'));

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestAddPillScreenWrapper(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Error: Exception: Test error'), findsOneWidget);
    });

    testWidgets('shows add pill dialog when FAB is tapped',
        (WidgetTester tester) async {
      // Arrange
      mockRepository.setMockSchedules([]);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestAddPillScreenWrapper(),
        ),
      );
      await tester.pumpAndSettle();

      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MockAddPillDialog), findsOneWidget);
    });

    testWidgets('shows pill detail dialog when pill card is tapped',
        (WidgetTester tester) async {
      // Arrange
      final schedules = [
        PillScheduleModel(
          id: '1',
          name: 'Morning Pills',
          description: 'Take with breakfast',
          daySchedules: [
            DayScheduleModel(
              id: '1',
              dayOfWeek: 1,
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
        ),
      ];
      mockRepository.setMockSchedules(schedules);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestAddPillScreenWrapper(),
        ),
      );
      await tester.pumpAndSettle();

      final pillCard = find.text('Morning Pills');
      await tester.tap(pillCard);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MockPillDetailDialog), findsOneWidget);
    });

    testWidgets('refreshes data when pull to refresh',
        (WidgetTester tester) async {
      // Arrange
      final schedules = [
        PillScheduleModel(
          id: '1',
          name: 'Morning Pills',
          description: 'Take with breakfast',
          daySchedules: [
            DayScheduleModel(
              id: '1',
              dayOfWeek: 1,
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
        ),
      ];
      mockRepository.setMockSchedules(schedules);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestAddPillScreenWrapper(),
        ),
      );
      await tester.pumpAndSettle();

      // Simulate pull to refresh
      await tester.drag(find.byType(GridView), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Morning Pills'), findsOneWidget);
    });
  });
}
