import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/activity_type_chip.dart';
import '../../../providers/activity_providers.dart';

/// 활동 유형 필터 칩 행.
/// 수평 스크롤 가능한 FilterChip 목록.
/// 영역별 색상으로 선택 상태를 시각적으로 구분한다.
class ActivityFilterChips extends ConsumerWidget {
  const ActivityFilterChips({super.key});

  static const _filterTypes = AppStrings.activityFilterTypes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(activityFilterProvider);
    final theme = Theme.of(context);

    return SizedBox(
      height: AppDimensions.minTouchTarget,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
        itemCount: _filterTypes.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final type = _filterTypes[index];
          final isSelected = selectedFilter == type;

          // "전체" 필터는 warmOrange, 나머지는 영역별 색상 사용
          final domainFg = type == AppStrings.activityFilterAll
              ? AppColors.warmOrange
              : ActivityTypeChip.domainColor(type);
          final domainBg = type == AppStrings.activityFilterAll
              ? AppColors.paleCream
              : ActivityTypeChip.domainBgColor(type);

          return FilterChip(
            key: ValueKey('activity_filter_$type'),
            label: Text(type),
            selected: isSelected,
            onSelected: (_) {
              ref.read(activityFilterProvider.notifier).setFilter(type);
            },
            backgroundColor: theme.cardColor,
            selectedColor: domainBg,
            checkmarkColor: domainFg,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: isSelected
                  ? domainFg
                  : theme.textTheme.bodySmall?.color,
            ),
            side: BorderSide(
              color: isSelected
                  ? domainFg
                  : theme.dividerColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}
