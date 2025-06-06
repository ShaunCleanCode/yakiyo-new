import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakiyo/features/settings/presentation/providers/nickname_provider.dart';

void main() {
  group('NicknameProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is null', () {
      final state = container.read(nicknameProvider);
      expect(state, isNull);
    });

    test('can update nickname', () {
      const newNickname = 'TestUser';
      container.read(nicknameProvider.notifier).state = newNickname;

      final state = container.read(nicknameProvider);
      expect(state, equals(newNickname));
    });

    test('can clear nickname', () {
      container.read(nicknameProvider.notifier).state = 'TestUser';
      container.read(nicknameProvider.notifier).state = null;

      final state = container.read(nicknameProvider);
      expect(state, isNull);
    });

    test('notifies listeners when nickname changes', () {
      var listenerCallCount = 0;
      container.listen(nicknameProvider, (previous, next) {
        listenerCallCount++;
      });

      container.read(nicknameProvider.notifier).state = 'TestUser';
      expect(listenerCallCount, equals(1));

      container.read(nicknameProvider.notifier).state = 'NewUser';
      expect(listenerCallCount, equals(2));

      container.read(nicknameProvider.notifier).state = null;
      expect(listenerCallCount, equals(3));
    });
  });
}
