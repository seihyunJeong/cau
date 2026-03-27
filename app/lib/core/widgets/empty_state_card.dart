import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_radius.dart';

/// 빈 상태 카드 (2-2-8).
/// 데이터가 없을 때 표시하는 재사용 가능한 빈 상태 위젯.
/// 소프트 아이콘 + 긍정적 톤의 메시지를 표시한다.
class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String message;
  final ValueKey<String>? cardKey;

  const EmptyStateCard({
    super.key,
    required this.icon,
    this.iconSize = 48,
    required this.message,
    this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: cardKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
