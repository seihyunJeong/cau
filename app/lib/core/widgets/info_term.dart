import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radius.dart';
import '../constants/app_text_styles.dart';

/// 전문 용어를 부모 언어로 표시하고, 탭하면 Tooltip으로 전문 용어 설명을 보여주는 위젯.
/// 앱 전체에서 전문 용어가 등장하는 모든 곳에 이 위젯을 사용한다.
///
/// 사용 예:
/// ```dart
/// InfoTerm(
///   parentLabel: '깜짝 놀라며 팔을 벌리는 반응',
///   termName: '모로반사 (Moro Reflex)',
///   description: '갑작스러운 소리나 움직임에 놀라 양팔을 벌렸다가 모으는 자연스러운 반응이에요.',
/// )
/// ```
class InfoTerm extends StatelessWidget {
  /// 부모 언어 (기본 표시 텍스트). 예: "깜짝 놀라며 팔을 벌리는 반응"
  final String parentLabel;

  /// 전문 용어명 (툴팁 제목). 예: "모로반사 (Moro Reflex)"
  final String termName;

  /// 전문 용어 설명 (툴팁 본문).
  final String description;

  const InfoTerm({
    super.key,
    required this.parentLabel,
    required this.termName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final tooltipBg = isDark ? AppColors.darkCard : AppColors.cream;

    // tooltipTitle/tooltipBody는 TextTheme에 매핑되지 않으므로
    // AppTextStyles에서 가져와 테마 색상을 적용한다.
    final tooltipTitleStyle = AppTextStyles.tooltipTitle.copyWith(
      color: isDark ? AppColors.darkTextPrimary : AppColors.darkBrown,
    );
    final tooltipBodyStyle = AppTextStyles.tooltipBody.copyWith(
      color: isDark ? AppColors.darkTextSecondary : AppColors.warmGray,
    );

    return JustTheTooltip(
      triggerMode: TooltipTriggerMode.tap,
      backgroundColor: tooltipBg,
      borderRadius: BorderRadius.circular(AppRadius.md),
      tailLength: 8,
      tailBaseWidth: 12,
      content: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              termName,
              style: tooltipTitleStyle,
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              description,
              style: tooltipBodyStyle,
            ),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              parentLabel,
              style: textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: AppDimensions.xs),
          Icon(
            Icons.info_outline,
            size: 16,
            color: isDark ? AppColors.darkTextSecondary : AppColors.warmGray,
          ),
        ],
      ),
    );
  }
}
