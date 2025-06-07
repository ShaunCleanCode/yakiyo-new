import '../../../pill_schedule/data/models/time_slot_model.dart';

/// Data model that combines a time slot with its schedule ID
class SlotWithScheduleId {
  final TimeSlotModel slot;
  final String pillScheduleId;

  const SlotWithScheduleId(this.slot, this.pillScheduleId);
}
