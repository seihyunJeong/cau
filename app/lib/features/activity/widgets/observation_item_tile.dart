import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/info_term.dart';
import '../../../data/models/observation_item.dart';
import '../../../data/seed/observation_reflex_data.dart';

/// 관찰 항목 타일 위젯.
/// 질문 텍스트 + 3단 라디오 그룹(2-4-2)을 표시한다.
/// 2단계 항목은 InfoTerm 툴팁을 함께 표시한다.
class ObservationItemTile extends StatelessWidget {
  /// 관찰 항목 데이터.
  final ObservationItem item;

  /// 현재 선택된 값. null이면 미선택.
  final int? selectedValue;

  /// 선택 변경 콜백. value: 0~2 (옵션 인덱스의 역순 값).
  final ValueChanged<int> onChanged;

  const ObservationItemTile({
    super.key,
    required this.item,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: ValueKey('obs_item_${item.id}'),
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 항목 텍스트 (2단계는 InfoTerm 포함)
          if (item.step == 2)
            InfoTerm(
              parentLabel: item.text,
              termName: ObservationReflexData.getTermName(item.id),
              description: ObservationReflexData.getDescription(item.id),
            )
          else
            Text(
              item.text,
              style: theme.textTheme.bodyLarge,
            ),
          const SizedBox(height: AppDimensions.md),
          // 3단 라디오 그룹
          _RadioGroup(
            itemId: item.id,
            options: item.options,
            selectedValue: selectedValue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// 3단 라디오 그룹 (2-4-2).
/// 옵션 인덱스 0 -> 값 2 (예/뚜렷함)
/// 옵션 인덱스 1 -> 값 1 (보통/약하게)
/// 옵션 인덱스 2 -> 값 0 (아니오/잘 안 보임)
class _RadioGroup extends StatelessWidget {
  final String itemId;
  final List<String> options;
  final int? selectedValue;
  final ValueChanged<int> onChanged;

  const _RadioGroup({
    required this.itemId,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: List.generate(options.length, (index) {
        // 옵션 인덱스 0 -> 값 2, 인덱스 1 -> 값 1, 인덱스 2 -> 값 0
        final value = options.length - 1 - index;
        final isSelected = selectedValue == value;
        final bgColor = isSelected
            ? AppColors.warmOrange
            : (isDark ? AppColors.darkCard : AppColors.paleCream);
        final textColor = isSelected
            ? AppColors.white
            : theme.colorScheme.onSurface;
        final borderColor = isSelected
            ? AppColors.warmOrange
            : (isDark ? AppColors.darkBorder : AppColors.paleCream);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index > 0 ? AppDimensions.sm : 0,
            ),
            child: GestureDetector(
              key: ValueKey('obs_option_${itemId}_$index'),
              onTap: () => onChanged(value),
              child: Container(
                height: AppDimensions.minTouchTarget,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Text(
                  options[index],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
