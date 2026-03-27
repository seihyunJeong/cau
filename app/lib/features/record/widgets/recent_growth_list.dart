import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/growth_record.dart';

/// 최근 성장 기록 리스트.
/// 각 항목: 날짜 + 값 + 변화 방향 아이콘.
class RecentGrowthList extends StatelessWidget {
  /// 전체 성장 기록 (ASC 정렬, 가장 오래된 것이 먼저).
  final List<GrowthRecord> records;

  /// 탭 종류: 0=체중, 1=키, 2=머리둘레.
  final int tabIndex;

  const RecentGrowthList({
    super.key,
    required this.records,
    required this.tabIndex,
  });

  double? _extractValue(GrowthRecord record) {
    switch (tabIndex) {
      case 0:
        return record.weightKg;
      case 1:
        return record.heightCm;
      case 2:
        return record.headCircumCm;
      default:
        return null;
    }
  }

  String _getUnit() {
    switch (tabIndex) {
      case 0:
        return AppStrings.weightUnit;
      case 1:
        return AppStrings.heightUnit;
      case 2:
        return AppStrings.headCircumUnit;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('M/d', 'ko_KR');

    // Filter records that have a value for the current tab, reverse for newest first
    final filtered = records
        .where((r) => _extractValue(r) != null)
        .toList()
        .reversed
        .take(10)
        .toList();

    if (filtered.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      key: const ValueKey('recent_growth_list'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.growthRecentTitle,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.sm),
        ...List.generate(filtered.length, (index) {
          final record = filtered[index];
          final value = _extractValue(record)!;
          final unit = _getUnit();

          // Compare with previous record (next in list since reversed)
          String changeLabel = AppStrings.growthSame;
          Color changeColor = AppColors.warmGray;
          IconData changeIcon = Icons.remove;

          if (index < filtered.length - 1) {
            final prevRecord = filtered[index + 1];
            final prevValue = _extractValue(prevRecord);
            if (prevValue != null) {
              final diff = value - prevValue;
              if (diff > 0.05) {
                changeLabel = AppStrings.growthIncreased;
                changeColor = theme.colorScheme.secondary;
                changeIcon = Icons.arrow_upward;
              } else {
                changeLabel = AppStrings.growthSame;
                changeColor = AppColors.warmGray;
                changeIcon = Icons.remove;
              }
            }
          }

          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.sm,
              horizontal: AppDimensions.md,
            ),
            decoration: BoxDecoration(
              border: index < filtered.length - 1
                  ? Border(
                      bottom: BorderSide(
                        color: AppColors.lightBeige,
                        width: 0.5,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Text(
                  dateFormat.format(record.date),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: AppDimensions.md),
                Text(
                  '${value.toStringAsFixed(1)}$unit',
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(
                  changeIcon,
                  size: AppDimensions.base,
                  color: changeColor,
                ),
                const SizedBox(width: AppDimensions.xs),
                Text(
                  changeLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: changeColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
