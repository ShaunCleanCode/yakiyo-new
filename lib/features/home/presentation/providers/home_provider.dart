import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakiyo/features/home/domain/repositories/home_repository.dart';

import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';
import 'package:yakiyo/features/intake_log/presentation/providers/intake_log_provider.dart';
import 'package:yakiyo/features/home/data/models/home_model.dart';
import 'package:yakiyo/features/home/domain/use_cases/get_today_schedule_use_case.dart';
import 'package:yakiyo/features/home/domain/use_cases/get_today_intake_status_use_case.dart';
import 'package:yakiyo/features/home/domain/use_cases/get_next_intake_use_case.dart';
import 'package:yakiyo/features/home/data/repositories/home_repository_impl.dart';

/// Provider for managing the refreshing state of the home screen
final homeRefreshingProvider = StateProvider<bool>((ref) => false);

/// Provider for the home repository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl();
});

/// Provider for the get today schedule use case
final getTodayScheduleUseCaseProvider =
    Provider<GetTodayScheduleUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetTodayScheduleUseCase(repository);
});

/// Provider for the get today intake status use case
final getTodayIntakeStatusUseCaseProvider =
    Provider<GetTodayIntakeStatusUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetTodayIntakeStatusUseCase(repository);
});

/// Provider for the get next intake use case
final getNextIntakeUseCaseProvider = Provider<GetNextIntakeUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetNextIntakeUseCase(repository);
});

/// Provider that combines time slots with their schedule IDs for today
final todayScheduleWithPillIdProvider =
    Provider<List<SlotWithScheduleId>>((ref) {
  final schedulesAsync = ref.watch(pillScheduleProvider);
  final useCase = ref.watch(getTodayScheduleUseCaseProvider);

  return schedulesAsync.when(
    data: (schedules) => useCase(schedules),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider that tracks the intake status for today's time slots
final todayIntakeStatusProvider = Provider<Map<String, bool>>((ref) {
  final todaySlots = ref.watch(todayScheduleWithPillIdProvider);
  final logs = ref.watch(intakeLogProvider);
  final useCase = ref.watch(getTodayIntakeStatusUseCaseProvider);

  return useCase(todaySlots, logs);
});

/// Provider that determines the next intake slot with its schedule ID
final nextIntakeWithPillIdProvider = Provider<SlotWithScheduleId?>((ref) {
  final todaySlots = ref.watch(todayScheduleWithPillIdProvider);
  final status = ref.watch(todayIntakeStatusProvider);
  final useCase = ref.watch(getNextIntakeUseCaseProvider);

  return useCase(todaySlots, status);
});

/// Provider that checks if we're within the intake window for the next medication
final isWithinIntakeWindowProvider = Provider<bool>((ref) {
  final nextSlot = ref.watch(nextIntakeWithPillIdProvider);
  if (nextSlot == null) return false;

  final now = DateTime.now();
  final slotTime = DateTime(
    now.year,
    now.month,
    now.day,
    nextSlot.slot.time.hour,
    nextSlot.slot.time.minute,
  );

  final difference = now.difference(slotTime).inMinutes.abs();
  return difference <= 30;
});

/// Provider that generates the message for the next intake time
final nextIntakeTimeMessageProvider = Provider<String>((ref) {
  final nextSlot = ref.watch(nextIntakeWithPillIdProvider);
  final isWithinWindow = ref.watch(isWithinIntakeWindowProvider);

  if (nextSlot == null) return '완료';
  if (isWithinWindow) return '약 드실 시간입니다!';

  final now = DateTime.now();
  final slotTime = DateTime(
    now.year,
    now.month,
    now.day,
    nextSlot.slot.time.hour,
    nextSlot.slot.time.minute,
  );

  final difference = slotTime.difference(now);
  final hours = difference.inHours;
  final minutes = difference.inMinutes % 60;

  if (hours > 0) {
    return '$hours시간 $minutes분';
  } else {
    return '$minutes분';
  }
});
