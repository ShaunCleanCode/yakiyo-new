import 'package:flutter/material.dart';
import 'package:yakiyo/features/pill_schedule/data/models/pill_schedule_model.dart';

class MockAddPillDialog extends StatelessWidget {
  final PillScheduleModel? initialSchedule;
  final bool isEdit;

  const MockAddPillDialog({
    super.key,
    this.initialSchedule,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('약 스케줄 추가'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Initial Schedule: ${initialSchedule?.name ?? 'None'}'),
          Text('Is Edit: $isEdit'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

class MockPillDetailDialog extends StatelessWidget {
  final PillScheduleModel schedule;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const MockPillDetailDialog({
    super.key,
    required this.schedule,
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(schedule.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Schedule ID: ${schedule.id}'),
          Text('Description: ${schedule.description}'),
          Text('Start Date: ${schedule.startDate}'),
          Text('End Date: ${schedule.endDate}'),
          Text('Is Active: ${schedule.isActive}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
        TextButton(
          onPressed: onEdit,
          child: const Text('수정하기'),
        ),
        if (onDelete != null)
          TextButton(
            onPressed: onDelete,
            child: const Text('삭제하기'),
          ),
      ],
    );
  }
}
