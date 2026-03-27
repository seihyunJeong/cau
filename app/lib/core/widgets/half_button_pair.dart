import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_radius.dart';

/// 반으로 나눈 버튼 쌍 (디자인컴포넌트 2-3-8).
/// Row + Expanded + OutlinedButton, 높이 48dp, 간격 8dp, 모서리 12dp.
class HalfButtonPair extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final ValueKey<String>? leftKey;
  final ValueKey<String>? rightKey;

  const HalfButtonPair({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    this.onLeftTap,
    this.onRightTap,
    this.leftKey,
    this.rightKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppDimensions.minTouchTarget,
            child: OutlinedButton(
              key: leftKey,
              onPressed: onLeftTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                foregroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                leftLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: SizedBox(
            height: AppDimensions.minTouchTarget,
            child: OutlinedButton(
              key: rightKey,
              onPressed: onRightTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                foregroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                rightLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
