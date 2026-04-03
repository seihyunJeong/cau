import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/activity_type_chip.dart';
import '../../../core/widgets/empty_state_card.dart';
import '../../../data/models/activity.dart';
import '../../../providers/activity_providers.dart';

/// 오늘의 미션 카드 (2-2-2).
/// 활동 1개를 크게 표시한다. UX 원칙: "하나만 해도 충분하다".
/// 히어로 카드: medium 그림자 + 영역별 색상 상단 스트라이프.
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
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = ActivityTypeChip.domainColor(activity.type);

    return Container(
      key: const ValueKey('today_mission_card'),
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // 히어로 카드: 더 큰 radius(lg=16) + 강한 그림자 + 그라데이션 배경
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkCardElevated,
                  AppColors.darkCard,
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.cardColor,
                  AppColors.paleCream.withValues(alpha: 0.5),
                ],
              ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.adaptiveMedium(isDark),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1.5)
            : Border.all(
                color: accentColor.withValues(alpha: 0.15),
                width: 1,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 영역별 색상 상단 스트라이프
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor,
                  accentColor.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.cardPadding),
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
                  child: ElevatedButton.icon(
                    key: const ValueKey('mission_start_btn'),
                    onPressed: () {
                      context.push('/activity/${activity.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warmOrange,
                      foregroundColor: AppColors.white,
                      elevation: 2,
                      shadowColor:
                          AppColors.warmOrange.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.xl),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: Text(
                      AppStrings.startActivity,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
