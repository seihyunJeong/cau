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
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const BabyProfileCard(),
            const SizedBox(height: AppDimensions.cardGap),

            // 2. 빠른 기록 영역
            const QuickRecordRow(),
            const SizedBox(height: AppDimensions.base),

            // 3. 오늘의 활동 섹션
            Text(
              AppStrings.todayActivity,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppDimensions.sm),
            const TodayMissionCard(),
            const SizedBox(height: AppDimensions.base),

            // 4. 성장 요약 섹션
            Text(
              AppStrings.growthSummaryTitle,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppDimensions.sm),
            const GrowthSummaryCard(),
            const SizedBox(height: AppDimensions.base),

            // 5. 이번 주 관찰 결과 섹션
            Text(
              AppStrings.observationSummaryTitle,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppDimensions.sm),
            const ObservationSummaryCard(),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }
}
