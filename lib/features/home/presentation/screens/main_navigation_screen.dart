import 'package:flutter/material.dart';
import 'package:yakiyo/common/widgets/bottom_nav_bar.dart';
import 'package:yakiyo/common/widgets/app_main_appbar.dart';
import 'package:yakiyo/features/home/presentation/screens/home_screen.dart';
import 'package:yakiyo/features/intake_log/presentation/screens/intake_log_screen.dart';
import 'package:yakiyo/features/device_status/presentation/screens/device_status_screen.dart';
import 'package:yakiyo/features/pill_schedule/presentation/screens/add_pill_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 1; // 디바이스 상태가 기본 탭

  final List<Widget> _screens = [
    const IntakeLogScreen(), // 왼쪽: 복약 기록
    const HomeScreen(), // 가운데: 디바이스 상태
    const AddPillScreen(), // 오른쪽: 알약 추가 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMainAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
