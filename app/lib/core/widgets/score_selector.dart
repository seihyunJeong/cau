import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radius.dart';


/// 점수 선택기 위젯 (디자인컴포넌트 2-4-1).
/// 0~4점 5버튼 수평 배치. 최소 터치 영역 48x40dp.
/// 비선택: paleCream 배경, darkBrown 텍스트
/// 선택: warmOrange 배경, white 텍스트
class ScoreSelector extends StatelessWidget {
  final String questionId;
  final int? selectedScore;
  final ValueChanged<int> onScoreSelected;

  const ScoreSelector({
    super.key,
    required this.questionId,
    this.selectedScore,
    required this.onScoreSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      key: ValueKey('score_selector_$questionId'),
      children: List.generate(5, (index) {
        final isSelected = selectedScore == index;
        final bgColor = isSelected
            ? theme.colorScheme.primary
            : (isDark ? AppColors.darkCard : AppColors.paleCream);
        final textColor = isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < 4 ? AppDimensions.xs : 0,
            ),
            child: SizedBox(
              height: AppDimensions.scoreSelectorHeight,
              child: Material(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: InkWell(
                  key: ValueKey('score_${questionId}_$index'),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onScoreSelected(index);
                  },
                  child: Center(
                    child: Text(
                      '$index',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
