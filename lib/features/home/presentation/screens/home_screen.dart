import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/home_provider.dart';

import '../../../pill_schedule/data/models/pill_schedule_model.dart';
import '../../../intake_log/presentation/providers/intake_log_provider.dart';
import 'package:yakiyo/features/pill_schedule/presentation/providers/pill_schedule_provider.dart';

import '../viewmodels/home_viewmodel.dart';
import '../widgets/pill_schedule_card.dart';
import '../widgets/refresh_indicator.dart';
import '../widgets/empty_schedule_view.dart';

/// Main screen for displaying medication schedules and intake status
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schedulesAsync = ref.watch(pillScheduleProvider);
    final isRefreshing = ref.watch(homeRefreshingProvider);

    return schedulesAsync.when(
      data: (schedules) {
        final todaySchedules = HomeViewModel.filterTodaySchedules(schedules);

        if (todaySchedules.isEmpty) {
          return const EmptyScheduleView();
        }

        return _buildMainContent(todaySchedules, isRefreshing);
      },
      loading: () => const _LoadingView(),
      error: (e, _) => _ErrorView(error: e),
    );
  }

  Widget _buildMainContent(
      List<PillScheduleModel> todaySchedules, bool isRefreshing) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          ref.read(homeRefreshingProvider.notifier).state = true;
          ref.invalidate(pillScheduleProvider);
          await Future.delayed(const Duration(milliseconds: 600));
          ref.read(homeRefreshingProvider.notifier).state = false;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                if (isRefreshing) const _RefreshingIndicator(),
                _buildSchedulePageView(todaySchedules),
                const SizedBox(height: 16),
                _buildPageIndicator(todaySchedules.length),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSchedulePageView(List<PillScheduleModel> todaySchedules) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: PageView.builder(
        controller: _pageController,
        itemCount: todaySchedules.length,
        itemBuilder: (context, index) {
          final schedule = todaySchedules[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PillScheduleCard(
              schedule: schedule,
              onIntake: () => _handleIntake(schedule),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator(int count) {
    return SmoothPageIndicator(
      controller: _pageController,
      count: count,
      effect: const WormEffect(
        dotHeight: 8,
        dotWidth: 8,
        type: WormType.thin,
        activeDotColor: Colors.black,
      ),
    );
  }

  void _handleIntake(PillScheduleModel schedule) {
    final nextSlotWithId = ref.read(nextIntakeWithPillIdProvider);
    if (nextSlotWithId != null) {
      ref.read(intakeLogProvider.notifier).add(
            pillScheduleId: nextSlotWithId.pillScheduleId,
            timeSlotId: nextSlotWithId.slot.id,
            intakeTime: DateTime.now(),
            quantity: 1,
          );
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Object error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(child: Text('에러 발생: $error')),
    );
  }
}

class _RefreshingIndicator extends StatelessWidget {
  const _RefreshingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('새로고침 중...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
