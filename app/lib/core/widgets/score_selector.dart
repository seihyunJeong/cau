import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radius.dart';

/// 점수 선택기 위젯 (디자인컴포넌트 2-4-1).
/// 0~4점 5버튼 수평 배치. 최소 터치 영역 48x40dp.
/// 비선택: paleCream 배경, darkBrown 텍스트
/// 선택: warmOrange 배경, white 텍스트 + 바운스 애니메이션
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
    return Row(
      key: ValueKey('score_selector_$questionId'),
      children: List.generate(5, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < 4 ? AppDimensions.xs : 0,
            ),
            child: _ScoreButton(
              questionId: questionId,
              score: index,
              isSelected: selectedScore == index,
              onTap: () {
                HapticFeedback.lightImpact();
                onScoreSelected(index);
              },
            ),
          ),
        );
      }),
    );
  }
}

/// Individual score button with bounce animation on selection.
class _ScoreButton extends StatefulWidget {
  final String questionId;
  final int score;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScoreButton({
    required this.questionId,
    required this.score,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ScoreButton> createState() => _ScoreButtonState();
}

class _ScoreButtonState extends State<_ScoreButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.15),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 0.95),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(covariant _ScoreButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger bounce when newly selected
    if (widget.isSelected && !oldWidget.isSelected) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = widget.isSelected
        ? theme.colorScheme.primary
        : (isDark ? AppColors.darkCard : AppColors.paleCream);
    final textColor = widget.isSelected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return SizedBox(
      height: AppDimensions.scoreSelectorHeight,
      child: ScaleTransition(
        scale: _bounceAnimation,
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: InkWell(
            key: ValueKey('score_${widget.questionId}_${widget.score}'),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            onTap: widget.onTap,
            child: Center(
              child: Text(
                '${widget.score}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
