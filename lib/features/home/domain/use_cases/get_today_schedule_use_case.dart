import '../../../pill_schedule/data/models/pill_schedule_model.dart';
import 'package:yakiyo/features/home/data/models/home_model.dart';
import '../../domain/repositories/home_repository.dart';

/// Use case for getting today's schedule
class GetTodayScheduleUseCase {
  final HomeRepository _repository;

  GetTodayScheduleUseCase(this._repository);

  List<SlotWithScheduleId> call(List<PillScheduleModel> schedules) {
    return _repository.getTodayScheduleWithPillId(schedules);
  }
}
