import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/pill_card.dart';
import '../../../../common/widgets/pill_icon.dart';

import '../../data/models/pill_schedule_model.dart';
import '../providers/pill_schedule_provider.dart';

import '../../data/models/day_schedule_model.dart';
import '../../data/models/time_slot_model.dart';
import '../../../../core/constants/color_constants.dart';

extension DateTimeToTimeOfDay on DateTime {
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
}

class AddPillScreen extends ConsumerStatefulWidget {
  const AddPillScreen({super.key});

  @override
  ConsumerState<AddPillScreen> createState() => _AddPillScreenState();
}

class _AddPillScreenState extends ConsumerState<AddPillScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoading) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePills();
    }
  }

  Future<void> _loadMorePills() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 여기서 추가 데이터를 가져오는 로직을 구현할 수 있습니다.
      // 현재는 Mock 데이터를 사용하므로 실제로는 필요 없지만,
      // 나중에 실제 API를 사용할 때를 위해 구조만 만들어둡니다.
      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pillSchedulesAsync = ref.watch(pillScheduleProvider);

    return Scaffold(
      body: pillSchedulesAsync.when(
        data: (pillSchedules) {
          if (pillSchedules.isEmpty) {
            return const Center(
              child: Text('알약 추가 화면'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(pillScheduleProvider);
            },
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: pillSchedules.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == pillSchedules.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final schedule = pillSchedules[index];
                return _buildPillCard(schedule);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => _showAddPillDialog(context, ref),
              child: Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  CupertinoIcons.plus,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillCard(PillScheduleModel schedule) {
    return PillCard(
      name: schedule.name,
      timeSlots: _extractTimeSlots(schedule),
      pillColor: _getRandomPillColor(schedule.id),
      onTap: () {
        _showPillDetailDialog(context, schedule);
      },
    );
  }

  List<String> _extractTimeSlots(PillScheduleModel schedule) {
    // 대표 요일(예: 첫 번째 daySchedule)만 사용
    if (schedule.daySchedules.isEmpty) return [];
    final firstDay = schedule.daySchedules.first;
    final timeSlots = <String>[];
    for (var timeSlot in firstDay.timeSlots) {
      final hour = timeSlot.time.hour;
      if (hour >= 5 && hour < 11 && !timeSlots.contains('아침')) {
        timeSlots.add('아침');
      } else if (hour >= 11 && hour < 15 && !timeSlots.contains('점심')) {
        timeSlots.add('점심');
      } else if (hour >= 15 && hour < 21 && !timeSlots.contains('저녁')) {
        timeSlots.add('저녁');
      }
    }
    return timeSlots;
  }

  PillColor _getRandomPillColor(String id) {
    // id를 기반으로 일관된 색상 반환
    const colors = PillColor.values;
    final index = id.hashCode.abs() % colors.length;
    return colors[index];
  }

  void _showAddPillDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AddPillDialog(),
    );
  }

  void _showPillDetailDialog(BuildContext context, PillScheduleModel schedule) {
    showDialog(
      context: context,
      builder: (context) => PillDetailDialog(
        schedule: schedule,
        onEdit: () {
          Navigator.of(context).pop();
          _showEditPillDialog(context, schedule);
        },
      ),
    );
  }

  void _showEditPillDialog(BuildContext context, PillScheduleModel schedule) {
    showDialog(
      context: context,
      builder: (context) => AddPillDialog(
        initialSchedule: schedule,
        isEdit: true,
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;
  const _DateBox({required this.date, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Text(
          date != null ? date!.toString().split(' ')[0] : '날짜 선택',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class AddPillDialog extends ConsumerStatefulWidget {
  final PillScheduleModel? initialSchedule;
  final bool isEdit;
  const AddPillDialog({this.initialSchedule, this.isEdit = false, super.key});

  @override
  ConsumerState<AddPillDialog> createState() => _AddPillDialogState();
}

class _AddPillDialogState extends ConsumerState<AddPillDialog> {
  int _currentStep = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  String _pillName = '';
  final List<bool> _selectedDays = List.generate(7, (index) => false);
  final Map<String, TimeOfDay?> _mealTimes = {};
  late final TextEditingController _pillNameController;

  // 시간대별 허용 범위 정의
  final Map<String, RangeValues> _timeRanges = {
    '아침': const RangeValues(5, 11), // 새벽 5시부터 오전 11시까지
    '점심': const RangeValues(11, 17), // 11시부터 5시까지
    '저녁': const RangeValues(17, 24), // 5시부터 12시까지
  };

  @override
  void initState() {
    super.initState();
    _pillNameController = TextEditingController(
      text: widget.initialSchedule?.name ?? '',
    );
    _pillName = _pillNameController.text;
    if (widget.initialSchedule != null) {
      _startDate = widget.initialSchedule!.startDate;
      _endDate = widget.initialSchedule!.endDate;
      for (var i = 0; i < 7; i++) {
        _selectedDays[i] = widget.initialSchedule!.daySchedules
            .any((ds) => ds.dayOfWeek == i + 1);
      }
      // 시간대 초기화
      for (final ds in widget.initialSchedule!.daySchedules) {
        for (final ts in ds.timeSlots) {
          final label = _getTimeLabel(ts.time);
          _mealTimes[label] = ts.time.toTimeOfDay();
        }
      }
    }
  }

  @override
  void dispose() {
    _pillNameController.dispose();
    super.dispose();
  }

  String _getTimeLabel(DateTime time) {
    if (time.hour >= 5 && time.hour < 11) return '아침';
    if (time.hour >= 11 && time.hour < 15) return '점심';
    if (time.hour >= 15 && time.hour < 21) return '저녁';
    return '';
  }

  // 시간 선택 시 범위를 체크하는 메서드
  bool _isTimeInRange(TimeOfDay time, String label) {
    final range = _timeRanges[label];
    if (range == null) return false;
    final hour = time.hour;
    return hour >= range.start && hour < range.end;
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDateSelectionStep();
      case 1:
        return _buildPillInfoStep();
      case 2:
        return _buildTimeSelectionStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDateSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        const Text('약을 복용할 기간을 선택해주세요',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DateBox(
                date: _startDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (date != null) setState(() => _startDate = date);
                }),
            const SizedBox(width: 8),
            const Text('부터', style: TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DateBox(
                date: _endDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? _startDate ?? DateTime.now(),
                    firstDate: _startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (date != null) setState(() => _endDate = date);
                }),
            const SizedBox(width: 8),
            const Text('까지', style: TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 32),
        _buildStepButtons(),
      ],
    );
  }

  Widget _buildPillInfoStep() {
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        const Text('약 상세 정보를 입력해주세요',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('약 이름',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _pillNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: (value) => setState(() => _pillName = value),
        ),
        const SizedBox(height: 24),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('요일 선택',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map((d) => Expanded(
                  child: Center(
                      child:
                          Text(d, style: const TextStyle(color: Colors.grey)))))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              7,
              (index) => Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => setState(
                            () => _selectedDays[index] = !_selectedDays[index]),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedDays[index]
                                ? ColorConstants.selectedGreen
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )),
        ),
        const SizedBox(height: 32),
        _buildStepButtons(),
      ],
    );
  }

  Widget _buildTimeSelectionStep() {
    final times = ['아침', '점심', '저녁'];
    final timeKeys = ['아침', '점심', '저녁'];
    final timePlaceholders = ['오전 11:00', '오후 13:00', '오후 18:00'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text('약 상세 정보를 입력해주세요',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('시간 선택',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 4),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('전 후 30분 간 알림을 보내드려요',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < 3; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    final key = timeKeys[i];
                    if (_mealTimes.containsKey(key)) {
                      _mealTimes.remove(key);
                    } else {
                      _mealTimes[key] = null;
                    }
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                    color: _mealTimes.containsKey(timeKeys[i])
                        ? ColorConstants.selectedGreen
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(times[i], style: const TextStyle(fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Container()),
              GestureDetector(
                onTap: _mealTimes.containsKey(timeKeys[i])
                    ? () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          if (_isTimeInRange(picked, timeKeys[i])) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('${timeKeys[i]} 시간 확인'),
                                content: Text(
                                    '${timeKeys[i]} 시간으로 ${picked.format(context)}을 설정하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _mealTimes[timeKeys[i]] = picked;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('${timeKeys[i]} 시간 범위 초과'),
                                content: Text(
                                    '${timeKeys[i]} 시간은 ${_timeRanges[timeKeys[i]]!.start}시부터 ${_timeRanges[timeKeys[i]]!.end}시까지 선택 가능합니다.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      }
                    : null,
                child: Container(
                  height: 36,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Text(
                    _mealTimes.containsKey(timeKeys[i]) &&
                            _mealTimes[timeKeys[i]] != null
                        ? _mealTimes[timeKeys[i]]!.format(context)
                        : timePlaceholders[i],
                    style: TextStyle(
                      fontSize: 15,
                      color: _mealTimes.containsKey(timeKeys[i]) &&
                              _mealTimes[timeKeys[i]] != null
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 24),
        ],
        _buildStepButtons(),
      ],
    );
  }

  Widget _buildStepButtons() {
    final isLast = _currentStep == 2;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed:
                _currentStep > 0 ? () => setState(() => _currentStep--) : null,
            child: const Text('이전'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _canProceed()
                ? () {
                    if (!isLast) {
                      setState(() => _currentStep++);
                    } else {
                      _submitPillSchedule();
                    }
                  }
                : null,
            child: Text(isLast ? '완료' : '다음'),
          ),
        ),
      ],
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _startDate != null && _endDate != null;
      case 1:
        return _pillName.isNotEmpty && _selectedDays.contains(true);
      case 2:
        return _mealTimes.isNotEmpty;
      default:
        return false;
    }
  }

  Future<void> _submitPillSchedule() async {
    if (_startDate == null || _endDate == null) return;

    final daySchedules = <DayScheduleModel>[];
    for (var i = 0; i < 7; i++) {
      if (_selectedDays[i]) {
        final timeSlots = <TimeSlotModel>[];
        _mealTimes.forEach((label, timeOfDay) {
          if (timeOfDay != null) {
            timeSlots.add(TimeSlotModel(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              time: DateTime(
                _startDate!.year,
                _startDate!.month,
                _startDate!.day,
                timeOfDay.hour,
                timeOfDay.minute,
              ),
              quantity: 1,
            ));
          }
        });

        daySchedules.add(DayScheduleModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          dayOfWeek: i + 1,
          timeSlots: timeSlots,
        ));
      }
    }

    final schedule = PillScheduleModel(
      id: widget.isEdit && widget.initialSchedule != null
          ? widget.initialSchedule!.id
          : DateTime.now().microsecondsSinceEpoch.toString(),
      name: _pillName,
      description: '',
      daySchedules: daySchedules,
      startDate: _startDate!,
      endDate: _endDate,
      isActive: true,
    );

    try {
      if (widget.isEdit && widget.initialSchedule != null) {
        await ref.read(updatePillScheduleProvider(schedule).future);
      } else {
        await ref.read(addPillScheduleProvider(schedule).future);
      }
      if (mounted) {
        ref.invalidate(pillScheduleProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(widget.isEdit ? '약 스케줄이 수정되었습니다' : '약 스케줄이 추가되었습니다')),
        );
        Navigator.of(context).pop(); // Close dialog
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 32, bottom: 0),
      title: const Center(
        child: Text(
          '약 스케줄 추가',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 550), // 최대 높이 제한
        child: SingleChildScrollView(
          child: _buildStepContent(),
        ),
      ),
    );
  }
}

class PillDetailDialog extends StatelessWidget {
  final PillScheduleModel schedule;
  final VoidCallback onEdit;
  const PillDetailDialog(
      {required this.schedule, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    final selectedDays =
        schedule.daySchedules.map((ds) => ds.dayOfWeek - 1).toSet();
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 32, bottom: 0),
      title: Center(
        child: Text(
          '${schedule.name} 정',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('복용 요일',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days
                .map((d) => Expanded(
                    child: Center(
                        child: Text(d,
                            style: const TextStyle(color: Colors.grey)))))
                .toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                7,
                (i) => Expanded(
                      child: Center(
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedDays.contains(i)
                                ? ColorConstants.selectedGreen
                                : Colors.white,
                          ),
                        ),
                      ),
                    )),
          ),
          const SizedBox(height: 24),
          const Text('복용 시간',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          ..._buildTimeRows(schedule),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[200],
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onEdit,
            child: const Text('수정하기', style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTimeRows(PillScheduleModel schedule) {
    final result = <Widget>[];
    if (schedule.daySchedules.isEmpty) return result;
    final firstDay = schedule.daySchedules.first;
    final addedLabels = <String>{};
    for (final ts in firstDay.timeSlots) {
      final label = _getTimeLabel(ts.time);
      if (!addedLabels.contains(label)) {
        result.add(Text('$label - ${_formatTime(ts.time)}',
            style: const TextStyle(fontSize: 15)));
        addedLabels.add(label);
      }
    }
    return result;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final isAM = hour < 12;
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = isAM ? '오전' : '오후';
    return '$period ${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String _getTimeLabel(DateTime time) {
    if (time.hour >= 5 && time.hour < 11) return '아침';
    if (time.hour >= 11 && time.hour < 15) return '점심';
    if (time.hour >= 15 && time.hour < 21) return '저녁';
    return '';
  }
}
