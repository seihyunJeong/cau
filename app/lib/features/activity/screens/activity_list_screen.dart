import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/empty_state_card.dart';
import '../../../providers/activity_providers.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_filter_chips.dart';

/// 활동 탭 메인 화면 (탭 3: 활동).
/// 개발기획서 5-5 기준.
/// 현재 주차의 활동 5개를 카드 리스트로 표시한다.
class ActivityListScreen extends ConsumerWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final filteredActivities = ref.watch(filteredActivitiesProvider);
    final allActivities = ref.watch(currentActivitiesProvider);
    final todayMission = ref.watch(todayMissionProvider);
    final completedIdsAsync = ref.watch(todayCompletedActivityIdsProvider);
    final completedIds = completedIdsAsync.value ?? [];

    return Scaffold(
      key: const ValueKey('activity_list_screen'),
      appBar: AppBar(
        title: Text(AppStrings.activityTitle),
        actions: [
          TextButton(
            key: const ValueKey('activity_history_button'),
            onPressed: () => context.push('/activity/history'),
            child: Text(
              AppStrings.activityHistory,
              style: textTheme.labelMedium,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 안심 메시지
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.activityReassurance,
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  AppStrings.activitySubReassurance,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.base),
          // 필터 칩 행
          const ActivityFilterChips(),
          const SizedBox(height: AppDimensions.base),
          // 활동 리스트
          Expanded(
            child: _buildActivityList(
              context,
              allActivities: allActivities,
              filteredActivities: filteredActivities,
              todayMissionId: todayMission?.id,
              completedIds: completedIds,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(
    BuildContext context, {
    required List allActivities,
    required List filteredActivities,
    required String? todayMissionId,
    required List<String> completedIds,
  }) {
    // 전체 활동이 비어 있으면 주차 빈 상태
    if (allActivities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
        child: EmptyStateCard(
          icon: Icons.star_outline,
          message: AppStrings.activityEmptyWeek,
          cardKey: const ValueKey('activity_empty_week'),
        ),
      );
    }

    // 필터 적용 후 비어 있으면 필터 빈 상태
    if (filteredActivities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
        child: EmptyStateCard(
          icon: Icons.filter_list,
          message: AppStrings.activityEmptyFilter,
          cardKey: const ValueKey('activity_empty_filter'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: AppDimensions.base,
      ),
      itemCount: filteredActivities.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.cardGap),
      itemBuilder: (context, index) {
        final activity = filteredActivities[index];
        return ActivityCard(
          activity: activity,
          isCompleted: completedIds.contains(activity.id),
          isTodayMission: activity.id == todayMissionId,
          onTap: () => context.push('/activity/${activity.id}'),
        );
      },
    );
  }
}
