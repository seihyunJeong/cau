import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../widgets/baby_profile_card.dart';
import '../widgets/growth_summary_card.dart';
import '../widgets/observation_summary_card.dart';
import '../widgets/quick_record_row.dart';
import '../widgets/today_mission_card.dart';

/// 홈 화면 (탭 1: "오늘 우리 아이는?").
/// 개발기획서 5-3 기준.
///
/// 레이아웃 (위 -> 아래):
///   1. 아기 프로필 카드
///   2. 빠른 기록 영역 (수유/배변 +1)
///   3. 오늘의 미션 카드
///   4. 성장 요약 카드
///   5. 관찰 요약 카드
///
/// Vitality 강화: 카드 등장 시 staggered FadeIn + SlideUp 애니메이션.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;

  // 5 sections, each gets a staggered animation
  static const _sectionCount = 5;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // Start stagger animation on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  /// Creates a staggered FadeIn + SlideUp animation for section [index].
  Widget _staggeredChild(int index, Widget child) {
    final itemCount = _sectionCount + 2;
    final begin = index / itemCount;
    final end = (index + 2) / itemCount;

    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ),
    );

    final offset = Tween<Offset>(
      begin: const Offset(0.0, 24.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );

    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, _) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: offset.value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        key: const ValueKey('home_app_bar'),
        title: Text(
          AppStrings.appName,
          style: theme.textTheme.headlineSmall,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        key: const ValueKey('home_scroll_view'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 아기 프로필 카드
            _staggeredChild(0, const BabyProfileCard()),
            const SizedBox(height: AppDimensions.cardGap),

            // 2. 빠른 기록 영역
            _staggeredChild(1, const QuickRecordRow()),
            const SizedBox(height: AppDimensions.sectionGap),

            // 3. 오늘의 활동 섹션
            _staggeredChild(
              2,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.todayActivity,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  const TodayMissionCard(),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sectionGap),

            // 4. 성장 요약 섹션
            _staggeredChild(
              3,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.growthSummaryTitle,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  const GrowthSummaryCard(),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sectionGap),

            // 5. 이번 주 관찰 결과 섹션
            _staggeredChild(
              4,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.observationSummaryTitle,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  const ObservationSummaryCard(),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }
}
