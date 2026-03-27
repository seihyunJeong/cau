import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/activity_type_chip.dart';
import '../../../core/widgets/info_term.dart';
import '../../../data/models/activity.dart';
import '../../../data/seed/activity_seed.dart';
import '../../../data/seed/reflex_data.dart';
import '../widgets/equipment_card.dart';
import '../widgets/step_guide.dart';

/// 활동 상세 화면 (화면 3-1).
/// 개발기획서 5-5 화면 3-1 기준.
/// Layer 1: 하기 모드, Layer 2: 더 알아보기.
class ActivityDetailScreen extends ConsumerWidget {
  final String activityId;

  const ActivityDetailScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // 시드 데이터에서 활동을 찾는다.
    final activity = activitySeed.cast<Activity?>().firstWhere(
          (a) => a?.id == activityId,
          orElse: () => null,
        );

    if (activity == null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.activityDetailTitle)),
        body: Center(
          child: Text(
            AppStrings.activityEmptyWeek,
            style: textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Scaffold(
      key: const ValueKey('activity_detail_screen'),
      appBar: AppBar(
        title: Text(AppStrings.activityDetailTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.screenPaddingH,
          0,
          AppDimensions.screenPaddingH,
          80, // 하단 sticky 버튼 영역만큼 패딩
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.base),
            // ── Layer 1: 하기 모드 ──

            // 활동 유형 칩 + 주차/순서 라벨
            Row(
              children: [
                ActivityTypeChip(type: activity.type),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  AppStrings.weekOrderLabel(
                      activity.weekIndex, activity.order),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),

            // 활동명
            Text(
              activity.name,
              style: textTheme.headlineLarge,
            ),
            const SizedBox(height: AppDimensions.xs),

            // 한 줄 설명
            Text(
              activity.description,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.lg),

            // "이렇게 해보세요" 단계별 가이드
            Text(
              AppStrings.stepGuideTitle,
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: AppDimensions.base),
            StepGuide(steps: activity.steps),
            const SizedBox(height: AppDimensions.lg),

            // ── Layer 2: 더 알아보기 (기본 접힘) ──
            _LearnMoreExpansion(activity: activity),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
      // 하단 고정 "시작하기 (N초)" 버튼
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: AppShadows.high,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenPaddingH,
              AppDimensions.md,
              AppDimensions.screenPaddingH,
              AppDimensions.base,
            ),
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                key: const ValueKey('start_activity_button'),
                onPressed: () =>
                    context.push('/activity/${activity.id}/timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                ),
                child: Text(
                  AppStrings.startActivityWithDuration(
                      activity.recommendedSeconds),
                  style: textTheme.labelLarge,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "더 알아보기" 확장 타일 (2-4-6).
class _LearnMoreExpansion extends StatelessWidget {
  final Activity activity;

  const _LearnMoreExpansion({required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleCream,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: const ValueKey('learn_more_expansion'),
          title: Text(
            AppStrings.learnMore,
            style: textTheme.headlineSmall,
          ),
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.cardPadding,
            vertical: AppDimensions.xs,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppDimensions.cardPadding,
            0,
            AppDimensions.cardPadding,
            AppDimensions.base,
          ),
          children: [
            Divider(color: theme.dividerColor),
            const SizedBox(height: AppDimensions.base),

            // 관찰 포인트
            _SectionTitle(title: AppStrings.observationPointsTitle),
            const SizedBox(height: AppDimensions.sm),
            ...activity.observationPoints.map(
              (point) => _BulletPoint(text: point),
            ),
            const SizedBox(height: AppDimensions.base),

            // 왜 하나요?
            _SectionTitle(title: AppStrings.rationaleTitle),
            const SizedBox(height: AppDimensions.sm),
            Text(
              activity.rationale,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              AppStrings.expertDesigned,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.softGreen,
              ),
            ),
            const SizedBox(height: AppDimensions.base),

            // 기대 효과
            _SectionTitle(title: AppStrings.expectedEffectsTitle),
            const SizedBox(height: AppDimensions.sm),
            ...activity.expectedEffects.map(
              (effect) => _BulletPoint(text: effect),
            ),
            const SizedBox(height: AppDimensions.base),

            // 이런 때는 잠깐 멈춰주세요
            _SectionTitle(title: AppStrings.cautionsTitle),
            const SizedBox(height: AppDimensions.sm),
            ...activity.cautions.map(
              (caution) => _BulletPoint(text: caution),
            ),
            const SizedBox(height: AppDimensions.base),

            // 활용 TIP
            _SectionTitle(title: AppStrings.tipsTitle),
            const SizedBox(height: AppDimensions.sm),
            ...activity.tips.map(
              (tip) => _BulletPoint(text: tip),
            ),
            const SizedBox(height: AppDimensions.base),

            // 필요 교구
            EquipmentCard(equipment: activity.equipment),
            const SizedBox(height: AppDimensions.base),

            // 연결 반사
            _SectionTitle(title: AppStrings.linkedReflexTitle),
            const SizedBox(height: AppDimensions.sm),
            InfoTerm(
              parentLabel: activity.linkedReflex,
              termName: ReflexData.getTermName(activity.linkedReflex),
              description: ReflexData.getDescription(activity.linkedReflex),
            ),
          ],
        ),
      ),
    );
  }

}

/// 섹션 제목 위젯.
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

/// 불릿 포인트 위젯.
class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.sm, right: AppDimensions.sm),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.warmOrange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
