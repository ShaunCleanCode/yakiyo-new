import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:yakiyo/features/home/presentation/screens/home_screen.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/day_schedule_model.dart';
import 'package:yakiyo/features/pill_schedule/data/models/time_slot_model.dart';
import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';
// import 'package:yakiyo/features/device_status/presentation/providers/device_status_provider.dart';
// import 'package:yakiyo/features/device_status/data/models/device_status_model.dart';
import 'package:yakiyo/features/intake_log/presentation/providers/intake_log_provider.dart';
import 'package:yakiyo/features/pill_schedule/data/repositories/mock_pill_schedule_repository.dart';

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

  group('HomeScreen Tests', () {
    testWidgets('renders home screen correctly', (WidgetTester tester) async {
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
          // deviceStatusProvider.overrideWith(
          //   (ref) => DeviceStatusNotifier()
          //     ..state = AsyncData(
          //       DeviceStatusModel(
          //         id: '1',
          //         deviceId: 'device1',
          //         status: 'connected',
          //         lastUpdated: DateTime.now(),
          //         batteryLevel: 80,
          //         firmwareVersion: '1.0.0',
          //       ),
          //     ),
          // ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for any pending timers
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Morning Pills'), findsOneWidget);
    });

    // testWidgets('displays device connection status',
    //     (WidgetTester tester) async {
    //   // Arrange
    //   final pillSchedule = PillScheduleModel(
    //     id: '1',
    //     name: 'Morning Pills',
    //     description: '',
    //     daySchedules: [
    //       DayScheduleModel(
    //         id: '1',
    //         dayOfWeek: DateTime.now().weekday,
    //         timeSlots: [
    //           TimeSlotModel(
    //             id: '1',
    //             time: DateTime(2024, 1, 1, 8, 0),
    //             quantity: 1,
    //           ),
    //         ],
    //       ),
    //     ],
    //     startDate: DateTime(2024, 1, 1),
    //     endDate: DateTime(2024, 12, 31),
    //     isActive: true,
    //   );

    //   container = ProviderContainer(
    //     overrides: [
    //       pillScheduleProvider.overrideWith(
    //         (ref) => PillScheduleNotifier(MockPillScheduleRepository())
    //           ..state = AsyncData([pillSchedule]),
    //       ),
    //       deviceStatusProvider.overrideWith(
    //         (ref) => DeviceStatusNotifier()
    //           ..state = AsyncData(
    //             DeviceStatusModel(
    //               id: '1',
    //               deviceId: 'device1',
    //               status: 'connected',
    //               lastUpdated: DateTime.now(),
    //               batteryLevel: 80,
    //               firmwareVersion: '1.0.0',
    //             ),
    //           ),
    //       ),
    //     ],
    //   );

    //   // Act
    //   await tester.pumpWidget(
    //     UncontrolledProviderScope(
    //       container: container,
    //       child: const MaterialApp(
    //         home: HomeScreen(),
    //       ),
    //     ),
    //   );

    //   // Assert
    //   expect(find.text('연결됨'), findsOneWidget);
    //   expect(find.text('80%'), findsOneWidget);
    // });

    testWidgets('displays next pill schedule', (WidgetTester tester) async {
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
          // deviceStatusProvider.overrideWith(
          //   (ref) => DeviceStatusNotifier()
          //     ..state = AsyncData(
          //       DeviceStatusModel(
          //         id: '1',
          //         deviceId: 'device1',
          //         status: 'connected',
          //         lastUpdated: DateTime.now(),
          //         batteryLevel: 80,
          //         firmwareVersion: '1.0.0',
          //       ),
          //     ),
          // ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for any pending timers
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('다음 복용 시간'), findsOneWidget);
      expect(find.text('08:00'), findsOneWidget);
    });

    // testWidgets('handles device disconnection', (WidgetTester tester) async {
    //   // Arrange
    //   final pillSchedule = PillScheduleModel(
    //     id: '1',
    //     name: 'Morning Pills',
    //     description: '',
    //     daySchedules: [
    //       DayScheduleModel(
    //         id: '1',
    //         dayOfWeek: DateTime.now().weekday,
    //         timeSlots: [
    //           TimeSlotModel(
    //             id: '1',
    //             time: DateTime(2024, 1, 1, 8, 0),
    //             quantity: 1,
    //           ),
    //         ],
    //       ),
    //     ],
    //     startDate: DateTime(2024, 1, 1),
    //     endDate: DateTime(2024, 12, 31),
    //     isActive: true,
    //   );

    //   container = ProviderContainer(
    //     overrides: [
    //       pillScheduleProvider.overrideWith(
    //         (ref) => PillScheduleNotifier(MockPillScheduleRepository())
    //           ..state = AsyncData([pillSchedule]),
    //       ),
    //       deviceStatusProvider.overrideWith(
    //         (ref) => DeviceStatusNotifier()
    //           ..state = AsyncData(
    //             DeviceStatusModel(
    //               id: '1',
    //               deviceId: 'device1',
    //               status: 'disconnected',
    //               lastUpdated: DateTime.now(),
    //               batteryLevel: 0,
    //               firmwareVersion: '1.0.0',
    //             ),
    //           ),
    //       ),
    //     ],
    //   );

    //   // Act
    //   await tester.pumpWidget(
    //     UncontrolledProviderScope(
    //       container: container,
    //       child: const MaterialApp(
    //         home: HomeScreen(),
    //       ),
    //     ),
    //   );

    //   // Assert
    //   expect(find.text('연결 끊김'), findsOneWidget);
    // });

    testWidgets('shows loading state', (WidgetTester tester) async {
      // Arrange
      container = ProviderContainer(
        overrides: [
          pillScheduleProvider.overrideWith(
            (ref) => PillScheduleNotifier(MockPillScheduleRepository())
              ..state = const AsyncLoading(),
          ),
          // deviceStatusProvider.overrideWith(
          //   (ref) => DeviceStatusNotifier()..state = const AsyncLoading(),
          // ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for any pending timers
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state', (WidgetTester tester) async {
      // Arrange
      container = ProviderContainer(
        overrides: [
          pillScheduleProvider.overrideWith(
            (ref) => PillScheduleNotifier(MockPillScheduleRepository())
              ..state =
                  AsyncError('Failed to load schedules', StackTrace.current),
          ),
          // deviceStatusProvider.overrideWith(
          //   (ref) => DeviceStatusNotifier()
          //     ..state = AsyncError(
          //         'Failed to load device status', StackTrace.current),
          // ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for any pending timers
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('에러 발생: Failed to load schedules'), findsOneWidget);
    });

    testWidgets('validates medication intake button colors',
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
          // deviceStatusProvider.overrideWith(
          //   (ref) => DeviceStatusNotifier()
          //     ..state = AsyncData(
          //       DeviceStatusModel(
          //         id: '1',
          //         deviceId: 'device1',
          //         status: 'connected',
          //         lastUpdated: DateTime.now(),
          //         batteryLevel: 80,
          //         firmwareVersion: '1.0.0',
          //       ),
          //     ),
          // ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for any pending timers
      await tester.pumpAndSettle();

      // Assert
      final button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton).first);
      expect(button.style?.backgroundColor?.resolve({}), Colors.grey[300]);
    });

    testWidgets('validates time slot colors', (WidgetTester tester) async {
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
          // deviceStatusProvider.overrideWith(
          //   (ref) => DeviceStatusNotifier()
          //     ..state = AsyncData(
          //       DeviceStatusModel(
          //         id: '1',
          //         deviceId: 'device1',
          //         status: 'connected',
          //         lastUpdated: DateTime.now(),
          //         batteryLevel: 80,
          //         firmwareVersion: '1.0.0',
          //       ),
          //     ),
          // ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for any pending timers
      await tester.pumpAndSettle();

      // Assert
      final dotIcon = tester.widget<Icon>(find.byIcon(Icons.circle).first);
      expect(dotIcon.color, Colors.grey);
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
