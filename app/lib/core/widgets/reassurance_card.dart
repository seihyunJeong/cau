import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radius.dart';

/// 안심 메시지 카드 (디자인컴포넌트 2-2-7).
/// 성장 곡선, 관찰 결과 등에서 안심을 주는 메시지를 표시한다.
/// 배경: mintTint(#F0F9F0), 모서리 16dp, 패딩 24dp.
class ReassuranceCard extends StatelessWidget {
  /// 메인 안심 메시지 텍스트.
  final String message;

  /// 서브 메시지 (선택).
  final String? subMessage;

  /// Marionette MCP 테스트용 키.
  final ValueKey<String>? cardKey;

  const ReassuranceCard({
    super.key,
    required this.message,
    this.subMessage,
    this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dark mode: use darkCard background with high-contrast text.
    // Light mode: use mintTint background with darkBrown text.
    final bgColor = isDark ? AppColors.darkCard : AppColors.mintTint;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.darkBrown;
    final subTextColor = isDark ? AppColors.darkTextSecondary : AppColors.warmGray;
    final iconColor = AppColors.softGreen;

    return Container(
      key: cardKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: isDark
            ? Border.all(color: AppColors.softGreen.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: AppDimensions.lg,
            color: iconColor,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            message,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (subMessage != null) ...[
            const SizedBox(height: AppDimensions.sm),
            Text(
              subMessage!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: subTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
