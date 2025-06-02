import '../../data/models/pill_schedule_model.dart';
import '../repositories/pill_schedule_repository.dart';

class AddPillScheduleUseCase {
  final PillScheduleRepository _repository;

  AddPillScheduleUseCase(this._repository);

  Future<void> call(PillScheduleModel schedule) async {
    await _repository.addPillSchedule(schedule);
  }
}

class UpdatePillScheduleUseCase {
  final PillScheduleRepository _repository;

  UpdatePillScheduleUseCase(this._repository);

  Future<void> call(PillScheduleModel schedule) async {
    await _repository.updatePillSchedule(schedule);
  }
}
