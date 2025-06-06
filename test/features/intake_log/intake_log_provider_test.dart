import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakiyo/features/intake_log/presentation/providers/intake_log_provider.dart';
import 'package:yakiyo/features/intake_log/data/models/pill_intake_log_model.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('IntakeLogProvider Tests', () {
    test('initial state is empty list', () {
      final notifier = container.read(intakeLogProvider.notifier);
      expect(notifier.state, []);
    });

    test('adds intake log correctly', () {
      // Arrange
      final notifier = container.read(intakeLogProvider.notifier);
      final intakeTime = DateTime(2024, 1, 1, 8, 0);

      // Act
      notifier.add(
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: intakeTime,
        quantity: 1,
      );

      // Assert
      expect(notifier.state.length, 1);
      expect(notifier.state.first.pillScheduleId, '1');
      expect(notifier.state.first.timeSlotId, '1');
      expect(notifier.state.first.intakeTime, intakeTime);
      expect(notifier.state.first.quantity, 1);
    });

    test('adds multiple intake logs correctly', () {
      // Arrange
      final notifier = container.read(intakeLogProvider.notifier);
      final intakeTime1 = DateTime(2024, 1, 1, 8, 0);
      final intakeTime2 = DateTime(2024, 1, 1, 12, 0);

      // Act
      notifier.add(
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: intakeTime1,
        quantity: 1,
      );
      notifier.add(
        pillScheduleId: '1',
        timeSlotId: '2',
        intakeTime: intakeTime2,
        quantity: 1,
      );

      // Assert
      expect(notifier.state.length, 2);
      expect(notifier.state.first.timeSlotId, '1');
      expect(notifier.state.last.timeSlotId, '2');
    });

    test('maintains order of intake logs by time', () {
      // Arrange
      final notifier = container.read(intakeLogProvider.notifier);
      final intakeTime1 = DateTime(2024, 1, 1, 12, 0);
      final intakeTime2 = DateTime(2024, 1, 1, 8, 0);

      // Act
      notifier.add(
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: intakeTime1,
        quantity: 1,
      );
      notifier.add(
        pillScheduleId: '1',
        timeSlotId: '2',
        intakeTime: intakeTime2,
        quantity: 1,
      );

      // Assert
      expect(notifier.state.length, 2);
      expect(notifier.state.first.timeSlotId,
          '2'); // Earlier time should come first
      expect(notifier.state.last.timeSlotId, '1');
    });

    test('handles duplicate intake logs correctly', () {
      // Arrange
      final notifier = container.read(intakeLogProvider.notifier);
      final intakeTime = DateTime(2024, 1, 1, 8, 0);

      // Act
      notifier.add(
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: intakeTime,
        quantity: 1,
      );
      notifier.add(
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: intakeTime,
        quantity: 1,
      );

      // Assert
      expect(notifier.state.length,
          2); // Should add both logs since they have different IDs
      expect(notifier.state.first.timeSlotId, '1');
      expect(notifier.state.last.timeSlotId, '1');
    });

    test('updates state correctly when adding logs', () {
      // Arrange
      final notifier = container.read(intakeLogProvider.notifier);
      final intakeTime = DateTime(2024, 1, 1, 8, 0);

      // Act
      notifier.add(
        pillScheduleId: '1',
        timeSlotId: '1',
        intakeTime: intakeTime,
        quantity: 1,
      );

      // Assert
      final providerState = container.read(intakeLogProvider);
      expect(providerState.length, 1);
      expect(providerState.first.pillScheduleId, '1');
      expect(providerState.first.timeSlotId, '1');
      expect(providerState.first.intakeTime, intakeTime);
      expect(providerState.first.quantity, 1);
    });
  });
}
