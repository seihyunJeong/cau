import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/activity_type_chip.dart';
import '../../../core/widgets/empty_state_card.dart';
import '../../../data/models/activity.dart';
import '../../../providers/activity_providers.dart';

/// 오늘의 미션 카드 (2-2-2).
/// 활동 1개를 크게 표시한다. UX 원칙: "하나만 해도 충분하다".
class TodayMissionCard extends ConsumerWidget {
  const TodayMissionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mission = ref.watch(todayMissionProvider);

    if (mission == null) {
      return const EmptyStateCard(
        icon: Icons.emoji_nature,
        message: AppStrings.noActivityToday,
        cardKey: ValueKey('today_mission_card'),
      );
    }

    return _MissionContent(activity: mission);
  }
}

class _MissionContent extends StatelessWidget {
  final Activity activity;

  const _MissionContent({required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: const ValueKey('today_mission_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 활동 유형 칩
          ActivityTypeChip(type: activity.type),
          const SizedBox(height: AppDimensions.sm),

          // 활동명
          Text(
            activity.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.sm),

          // 설명
          Text(
            activity.description,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.sm),

          // 권장 시간
          Text(
            '${AppStrings.recommendedTime}: ${activity.recommendedSeconds}${AppStrings.seconds}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppDimensions.base),

          // 시작하기 CTA 버튼
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              key: const ValueKey('mission_start_btn'),
              onPressed: () {
                // TODO: 활동 상세 화면 네비게이션 (Sprint 05+)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warmOrange,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
              child: Text(
                AppStrings.startActivity,
                style: theme.textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
