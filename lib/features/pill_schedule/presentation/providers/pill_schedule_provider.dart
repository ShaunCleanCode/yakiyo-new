import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/get_pill_schedules.dart';
import '../../domain/use_cases/add_pill_schedule.dart';

import '../../data/models/pill_schedule_model.dart';
import '../../data/repositories/mock_pill_schedule_repository.dart';

// 싱글턴 인스턴스 생성
final _mockRepo = MockPillScheduleRepository();

// Repository Provider
final pillScheduleRepositoryProvider =
    Provider<MockPillScheduleRepository>((ref) {
  return _mockRepo;
});

// Use Case Providers
final getPillSchedulesUseCaseProvider =
    Provider<GetPillSchedulesUseCase>((ref) {
  final repository = ref.read(pillScheduleRepositoryProvider);
  return GetPillSchedulesUseCase(repository);
});

final addPillScheduleUseCaseProvider = Provider<AddPillScheduleUseCase>((ref) {
  final repository = ref.read(pillScheduleRepositoryProvider);
  return AddPillScheduleUseCase(repository);
});

final updatePillScheduleUseCaseProvider =
    Provider<UpdatePillScheduleUseCase>((ref) {
  final repository = ref.read(pillScheduleRepositoryProvider);
  return UpdatePillScheduleUseCase(repository);
});

// State Providers
final pillScheduleProvider = StateNotifierProvider<PillScheduleNotifier,
    AsyncValue<List<PillScheduleModel>>>((ref) {
  final repository = ref.read(pillScheduleRepositoryProvider);
  return PillScheduleNotifier(repository);
});

class PillScheduleNotifier
    extends StateNotifier<AsyncValue<List<PillScheduleModel>>> {
  final MockPillScheduleRepository _repository;

  PillScheduleNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    try {
      final schedules = await _repository.getPillSchedules();
      state = AsyncValue.data(schedules);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addSchedule(PillScheduleModel schedule) async {
    try {
      await _repository.addPillSchedule(schedule);
      await loadSchedules(); // 상태 갱신
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSchedule(PillScheduleModel schedule) async {
    try {
      await _repository.updatePillSchedule(schedule);
      await loadSchedules(); // 상태 갱신
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _repository.deletePillSchedule(id);
      await loadSchedules(); // 상태 갱신
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Action Providers
final addPillScheduleProvider =
    FutureProvider.family<void, PillScheduleModel>((ref, schedule) async {
  final notifier = ref.read(pillScheduleProvider.notifier);
  await notifier.addSchedule(schedule);
});

final updatePillScheduleProvider =
    FutureProvider.family<void, PillScheduleModel>((ref, schedule) async {
  final notifier = ref.read(pillScheduleProvider.notifier);
  await notifier.updateSchedule(schedule);
});

final deletePillScheduleProvider =
    FutureProvider.family<void, String>((ref, id) async {
  final notifier = ref.read(pillScheduleProvider.notifier);
  await notifier.deleteSchedule(id);
});
