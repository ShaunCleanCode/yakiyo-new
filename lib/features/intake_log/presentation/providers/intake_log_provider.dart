import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pill_intake_log_model.dart';

class IntakeLogNotifier extends StateNotifier<List<PillIntakeLogModel>> {
  IntakeLogNotifier() : super([]);

  void add({
    required String pillScheduleId,
    required String timeSlotId,
    required DateTime intakeTime,
    required int quantity,
    String? note,
  }) {
    state = [
      ...state,
      PillIntakeLogModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        pillScheduleId: pillScheduleId,
        timeSlotId: timeSlotId,
        intakeTime: intakeTime,
        quantity: quantity,
        note: note,
      ),
    ];
  }
}

final intakeLogProvider =
    StateNotifierProvider<IntakeLogNotifier, List<PillIntakeLogModel>>(
  (ref) => IntakeLogNotifier(),
);
