import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yakiyo/features/intake_log/presentation/screens/intake_log_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('달력 날짜별 색상 및 다이얼로그 복용 정보 UI 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
            home: IntakeLogScreen(initialMonth: DateTime(2024, 6, 1)))));

    // 6월 6일 셀(초록) tap → 다이얼로그에 복용 정보(혈압약, 비타민, 오메가3) 노출
    final day6Finder = find.byKey(const Key('calendar-day-2024-06-06'));
    expect(day6Finder, findsOneWidget);
    await tester.tap(day6Finder);
    await tester.pumpAndSettle();
    expect(find.text('2024.06.06'), findsOneWidget);
    expect(find.text('혈압약'), findsOneWidget);
    expect(find.text('비타민'), findsOneWidget);
    expect(find.text('오메가3'), findsOneWidget);
    expect(find.text('복용: 08:10'), findsOneWidget);
    expect(find.text('미복용'), findsWidgets);
    // 닫기 버튼
    expect(find.text('닫기'), findsOneWidget);
    await tester.tap(find.text('닫기'));
    await tester.pumpAndSettle();

    // 6월 2일 셀(빨강) tap → 다이얼로그에 모두 미복용
    final day2Finder = find.byKey(const Key('calendar-day-2024-06-02'));
    expect(day2Finder, findsOneWidget);
    await tester.tap(day2Finder);
    await tester.pumpAndSettle();
    expect(find.text('2024.06.02'), findsOneWidget);
    expect(find.text('미복용'), findsWidgets);
    await tester.tap(find.text('닫기'));
    await tester.pumpAndSettle();
  });
}
