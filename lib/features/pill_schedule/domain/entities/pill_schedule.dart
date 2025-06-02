class PillSchedule {
  final String id;
  final String name;
  final List<String> timeSlots; // '아침', '점심', '저녁' 등의 시간대

  PillSchedule({
    required this.id,
    required this.name,
    required this.timeSlots,
  });
}
