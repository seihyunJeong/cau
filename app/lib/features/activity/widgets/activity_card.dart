import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/activity_type_chip.dart';
import '../../../data/models/activity.dart';

/// 활동 카드 위젯 (2-2-3).
/// 디자인컴포넌트 2-2-3 기준.
/// 배경 white, 모서리 12dp, 패딩 16dp, 그림자 AppShadows.low.
/// 좌측에 영역별 색상 악센트바를 표시하여 활동 유형을 시각적으로 구분한다.
class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isCompleted;
  final bool isTodayMission;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.activity,
    this.isCompleted = false,
    this.isTodayMission = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final accentColor = ActivityTypeChip.domainColor(activity.type);

    return GestureDetector(
      key: ValueKey('activity_card_${activity.id}'),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppDimensions.minTouchTarget,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.low,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 좌측: 영역별 색상 악센트바
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.md),
                    bottomLeft: Radius.circular(AppRadius.md),
                  ),
                ),
              ),
              // 메인 컨텐츠
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.cardPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 좌측: 완료 체크 (완료 시만 표시)
                      if (isCompleted)
                        Padding(
                          padding:
                              const EdgeInsets.only(right: AppDimensions.md),
                          child: Icon(
                            Icons.check_circle,
                            color: AppColors.softGreen,
                            size: 24,
                          ),
                        ),
                      // 중앙: 활동 정보
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 상단: 유형 칩 + 오늘의 추천 배지
                            Row(
                              children: [
                                ActivityTypeChip(type: activity.type),
                                if (isTodayMission) ...[
                                  const SizedBox(width: AppDimensions.sm),
                                  Container(
                                    key: const ValueKey(
                                        'today_mission_badge'),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimensions.sm,
                                      vertical: AppDimensions.xxs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.warmOrange,
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.sm),
                                    ),
                                    child: Text(
                                      AppStrings.todayRecommend,
                                      style: textTheme.labelSmall?.copyWith(
                                        color:
                                            theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            // 활동명
                            Text(
                              activity.name,
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppDimensions.xs),
                            // 권장 시간
                            Text(
                              AppStrings.recommendedDuration(
                                  activity.recommendedSeconds),
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: AppDimensions.xs),
                            // 한 줄 설명
                            Text(
                              activity.description,
                              style: textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // 우측: chevron
                      Icon(
                        Icons.chevron_right,
                        color: theme.textTheme.bodySmall?.color,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
