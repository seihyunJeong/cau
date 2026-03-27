import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

/// 활동 유형 칩 (2-3-9).
/// 디자인컴포넌트 2-3-9 기준.
/// paleCream 배경, warmOrange 텍스트, labelSmall (theme), 모서리 8dp.
class ActivityTypeChip extends StatelessWidget {
  final String type;

  const ActivityTypeChip({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('activity_type_chip'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.paleCream,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.warmOrange,
            ),
      ),
    );
  }
}
