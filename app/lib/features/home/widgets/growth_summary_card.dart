import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/text_link_button.dart';
import '../../../providers/growth_providers.dart';

/// 성장 요약 카드 (2-2-5).
/// 디자인컴포넌트 2-2-5 기준.
/// - 데이터 있을 때: 안심 메시지 + 최근 체중/키 + "더보기" 링크
/// - 데이터 없을 때: "아직 성장 기록이 없어요" 빈 상태
class GrowthSummaryCard extends ConsumerWidget {
  const GrowthSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final growthAsync = ref.watch(latestGrowthProvider);

    final isDark = theme.brightness == Brightness.dark;

    // 정보 카드: 좌측 색상 바 + 컴팩트 패딩 + 적응형 그림자
    return Container(
      key: const ValueKey('growth_summary_card'),
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.adaptiveLow(isDark),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 좌측 색상 바 (정보 카드 스타일)
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.md),
                  bottomLeft: Radius.circular(AppRadius.md),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.cardPaddingCompact),
                child: growthAsync.when(
                  data: (growth) {
                    if (growth == null) {
                      return _buildEmptyState(theme);
                    }
                    return _buildContent(context, theme, growth);
                  },
                  loading: () => const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => _buildEmptyState(theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    dynamic growth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 안심 메시지 (숫자보다 먼저/크게 표시)
        Row(
          children: [
            Icon(
              Icons.check_circle,
              size: 20,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text(
                AppStrings.growthReassurance,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),

        // 체중/키 수치 (안심 메시지보다 작게)
        if (growth.weightKg != null)
          Text(
            AppStrings.weightValue(growth.weightKg!.toStringAsFixed(1)),
            style: theme.textTheme.bodyMedium,
          ),
        if (growth.heightCm != null)
          Text(
            AppStrings.heightValue(growth.heightCm!.toStringAsFixed(1)),
            style: theme.textTheme.bodyMedium,
          ),

        // 더보기 링크
        TextLinkButton(
          label: AppStrings.moreLink,
          buttonKey: const ValueKey('growth_more_link'),
          onPressed: () {
            // TODO: 성장 곡선 화면 네비게이션 (미구현)
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Larger icon in a tinted circle for visual emphasis
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.warmOrange.withValues(alpha: isDark ? 0.12 : 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.straighten,
            size: 36,
            color: AppColors.warmOrange.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          AppStrings.emptyGrowth,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          AppStrings.emptyGrowthSub,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
