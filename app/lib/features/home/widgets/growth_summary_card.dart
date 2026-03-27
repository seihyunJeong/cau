import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
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

    return Container(
      key: const ValueKey('growth_summary_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
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
    return Column(
      children: [
        Icon(
          Icons.straighten,
          size: 36,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          AppStrings.emptyGrowth,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
