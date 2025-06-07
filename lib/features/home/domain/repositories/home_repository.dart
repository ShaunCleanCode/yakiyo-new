import 'package:yakiyo/features/home/data/models/home_model.dart';

import '../../../pill_schedule/data/models/pill_schedule_model.dart';
import '../../../intake_log/data/models/pill_intake_log_model.dart';

/// Repository interface for home feature
abstract class HomeRepository {
  /// Gets today's schedule with pill IDs
  List<SlotWithScheduleId> getTodayScheduleWithPillId(
      List<PillScheduleModel> schedules);

  /// Gets today's intake status
  Map<String, bool> getTodayIntakeStatus(
    List<SlotWithScheduleId> todaySlots,
    List<PillIntakeLogModel> logs,
  );

  /// Gets the next intake slot with pill ID
  SlotWithScheduleId? getNextIntakeWithPillId(
    List<SlotWithScheduleId> todaySlots,
    Map<String, bool> status,
  );
}
