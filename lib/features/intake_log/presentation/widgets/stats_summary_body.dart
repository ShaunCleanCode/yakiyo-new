import 'package:flutter/material.dart';
import 'package:yakiyo/core/constants/assets_constants.dart';

class StatsSummaryBody extends StatelessWidget {
  final int totalDays;
  final double morningRate;
  final double lunchRate;
  final double dinnerRate;
  final String mostMissedSlot;
  final VoidCallback onSave;

  const StatsSummaryBody({
    super.key,
    required this.totalDays,
    required this.morningRate,
    required this.lunchRate,
    required this.dinnerRate,
    required this.mostMissedSlot,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.6),
      child: Container(
        width: 325,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '약 통계 정보 확인하기',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  AssetsConstants.appLogoPng,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI 요약',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_box, color: Color(0xFF4CAF50)),
                      SizedBox(width: 6),
                      Text('복용률',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('총 기록일 : $totalDays일',
                      style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('아침 : ${_rateString(morningRate)}',
                      style: const TextStyle(fontSize: 15)),
                  Text('점심 : ${_rateString(lunchRate)}',
                      style: const TextStyle(fontSize: 15)),
                  Text('저녁 : ${_rateString(dinnerRate)}',
                      style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.error, color: Color(0xFFE53935)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '가장 누락이 많은 시간대는\n"$mostMissedSlot"이에요',
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('그래프 저장하기', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '그래프를 저장하면 더 많은 정보를\n보실 수 있어요!',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String _rateString(double rate) {
  return rate.toStringAsFixed(1) + '%';
}
