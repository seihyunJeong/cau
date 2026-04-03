import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radius.dart';
import '../constants/app_shadows.dart';

/// 빈 상태 카드 (2-2-8).
/// 데이터가 없을 때 표시하는 재사용 가능한 빈 상태 위젯.
/// 큰 아이콘(56dp) + 메인 메시지 + 선택적 서브 메시지로 풍부한 빈 상태를 표현한다.
class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String message;
  final String? subMessage;
  final ValueKey<String>? cardKey;

  const EmptyStateCard({
    super.key,
    required this.icon,
    this.iconSize = 56,
    required this.message,
    this.subMessage,
    this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: cardKey,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.xl,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.adaptiveSubtle(isDark),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with a circular tinted background for visual emphasis
          Container(
            width: iconSize + 24,
            height: iconSize + 24,
            decoration: BoxDecoration(
              color: AppColors.warmOrange.withValues(alpha: isDark ? 0.12 : 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: AppColors.warmOrange.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppDimensions.base),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (subMessage != null) ...[
            const SizedBox(height: AppDimensions.sm),
            Text(
              subMessage!,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
