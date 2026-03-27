import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/equipment.dart';

/// 교구/준비물 카드 (2-2-10).
/// 디자인컴포넌트 2-2-10 기준.
/// 배경 white, 모서리 12dp, 패딩 16dp, 그림자 AppShadows.low.
class EquipmentCard extends StatelessWidget {
  final Equipment equipment;

  const EquipmentCard({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      key: const ValueKey('equipment_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.low,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.equipmentTitle,
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.sm),
          if (!equipment.isRequired) ...[
            // 교구 불필요
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppColors.softGreen,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  AppStrings.equipmentNotRequired,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.softGreen,
                  ),
                ),
              ],
            ),
            if (equipment.diyAlternative != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Text(
                equipment.diyAlternative!,
                style: textTheme.bodySmall,
              ),
            ],
          ] else ...[
            // 교구 필요
            if (equipment.itemName != null)
              Text(
                equipment.itemName!,
                style: textTheme.bodyLarge,
              ),
            if (equipment.description != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Text(
                equipment.description!,
                style: textTheme.bodySmall,
              ),
            ],
            if (equipment.diyAlternative != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Text(
                '${AppStrings.equipmentAlternative}: ${equipment.diyAlternative}',
                style: textTheme.bodySmall,
              ),
            ],
            if (equipment.purchaseNote != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Text(
                equipment.purchaseNote!,
                style: textTheme.bodySmall,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
