import '../../../intake_log/data/models/pill_intake_log_model.dart';
import 'package:yakiyo/features/home/data/models/home_model.dart';
import '../../domain/repositories/home_repository.dart';

/// Use case for getting today's intake status
class GetTodayIntakeStatusUseCase {
  final HomeRepository _repository;

  GetTodayIntakeStatusUseCase(this._repository);

  Map<String, bool> call(
    List<SlotWithScheduleId> todaySlots,
    List<PillIntakeLogModel> logs,
  ) {
    return _repository.getTodayIntakeStatus(todaySlots, logs);
  }
}
