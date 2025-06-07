import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../pill_schedule/data/models/pill_schedule_model.dart';
import '../../../pill_schedule/data/models/time_slot_model.dart';
import '../../../intake_log/presentation/providers/intake_log_provider.dart';
import '../providers/home_provider.dart';
import '../viewmodels/home_viewmodel.dart';

/// Card widget that displays a single medication schedule
class PillScheduleCard extends ConsumerWidget {
  final PillScheduleModel schedule;
  final VoidCallback onIntake;

  const PillScheduleCard({
    super.key,
    required this.schedule,
    required this.onIntake,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intakeStatus = ref.watch(todayIntakeStatusProvider);
    final todaySlots = HomeViewModel.extractTodaySlots(schedule);
    final remaining =
        HomeViewModel.filterRemainingSlots(todaySlots, intakeStatus);
    final nextSlot = HomeViewModel.getNextSlot(remaining);
    final nextTime = HomeViewModel.getNextTime(nextSlot);
    final nextIntakeInfo = HomeViewModel.getNextIntakeInfo(nextSlot, nextTime);
    final nextIntakeMsg = nextIntakeInfo['msg'] as String;
    final nextIntakeLabel = nextIntakeInfo['label'] as String?;
    final isWithinWindow = nextIntakeInfo['isWithinWindow'] as bool;
    final isTaken = HomeViewModel.isTaken(nextSlot);
    final slotLabels = HomeViewModel.getSlotLabels(todaySlots);
    final slotByLabel = HomeViewModel.getSlotByLabel(todaySlots);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildNextIntakeInfo(nextIntakeLabel, nextIntakeMsg),
              const SizedBox(height: 8),
              _buildStatusIndicator(isTaken, isWithinWindow),
              const SizedBox(height: 24),
              _buildIntakeStatus(slotLabels, slotByLabel, intakeStatus),
              const Spacer(),
              _buildIntakeButton(isTaken, isWithinWindow, nextSlot),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            schedule.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(Icons.medication, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildNextIntakeInfo(String? nextIntakeLabel, String nextIntakeMsg) {
    if (nextIntakeLabel != null) {
      return Column(
        children: [
          Center(
            child: Text(
              '다음 $nextIntakeLabel약 복용까지',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              nextIntakeMsg,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
    return Center(
      child: Text(
        nextIntakeMsg,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isTaken, bool isWithinWindow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.circle,
          color: isWithinWindow ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          HomeViewModel.getIntakeStatusMessage(isTaken, isWithinWindow),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildIntakeStatus(List<String> slotLabels,
      Map<String, TimeSlotModel?> slotByLabel, Map<String, bool> intakeStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('오늘의 복용 현황', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: slotLabels
                .map((label) =>
                    _buildDot(label, slotByLabel[label], intakeStatus))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildIntakeButton(
      bool isTaken, bool isWithinWindow, TimeSlotModel? nextSlot) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (isTaken || !isWithinWindow)
                ? null
                : () {
                    if (nextSlot != null) {
                      onIntake();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: (isTaken || !isWithinWindow)
                  ? Colors.grey[300]
                  : Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: const Text('복용 확인'),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          HomeViewModel.getButtonStateMessage(isTaken, isWithinWindow),
          style: const TextStyle(fontSize: 13, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDot(
      String label, TimeSlotModel? slot, Map<String, bool> intakeStatus) {
    final taken = slot != null ? (intakeStatus[slot.id] ?? false) : false;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: taken ? Colors.green.withOpacity(0.1) : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.circle,
            color: taken ? Colors.green : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: taken ? Colors.green : Colors.grey[600],
            fontWeight: taken ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
