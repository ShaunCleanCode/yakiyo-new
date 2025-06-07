import 'package:yakiyo/features/home/data/models/home_model.dart';

import '../../domain/repositories/home_repository.dart';

/// Use case for getting the next intake slot
class GetNextIntakeUseCase {
  final HomeRepository _repository;

  GetNextIntakeUseCase(this._repository);

  SlotWithScheduleId? call(
    List<SlotWithScheduleId> todaySlots,
    Map<String, bool> status,
  ) {
    return _repository.getNextIntakeWithPillId(todaySlots, status);
  }
}
