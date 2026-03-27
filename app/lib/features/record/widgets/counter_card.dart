import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/saved_toast.dart';

/// 수유/배변 카운터 카드 (디자인컴포넌트 2-3-3).
/// +/- 버튼으로 카운트 조작. 0일 때 - 비활성.
/// 30 이상 시 경고 토스트. scale-up 애니메이션 + 햅틱 피드백.
class CounterCard extends StatefulWidget {
  final String label;
  final String emoji;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueKey<String> cardKey;
  final ValueKey<String> countKey;
  final ValueKey<String> plusKey;
  final ValueKey<String> minusKey;

  const CounterCard({
    super.key,
    required this.label,
    required this.emoji,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    required this.cardKey,
    required this.countKey,
    required this.plusKey,
    required this.minusKey,
  });

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    _scaleController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMinusDisabled = widget.count <= 0;

    return Container(
      key: widget.cardKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          // Header: emoji + label
          Text(
            '${widget.emoji} ${widget.label}',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.md),
          // Counter row: - [count] +
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minus button
              _CounterButton(
                key: widget.minusKey,
                icon: Icons.remove,
                onTap: isMinusDisabled
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        widget.onDecrement();
                        _triggerAnimation();
                        showSavedToast(context);
                      },
                isDisabled: isMinusDisabled,
              ),
              const SizedBox(width: AppDimensions.lg),
              // Count display
              ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  '${widget.count}${AppStrings.countSuffix}',
                  key: widget.countKey,
                  style: theme.textTheme.displayMedium,
                ),
              ),
              const SizedBox(width: AppDimensions.lg),
              // Plus button
              _CounterButton(
                key: widget.plusKey,
                icon: Icons.add,
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onIncrement();
                  _triggerAnimation();
                  showSavedToast(context);
                  if (widget.count + 1 >= 30) {
                    _showWarningToast(context);
                  }
                },
                isDisabled: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWarningToast(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.counterWarning,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.white,
              ),
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkBrown.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        margin: const EdgeInsets.only(
          left: 40,
          right: 40,
          bottom: AppDimensions.base,
        ),
        elevation: 0,
      ),
    );
  }
}

/// +/- 원형 버튼.
class _CounterButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _CounterButton({
    super.key,
    required this.icon,
    this.onTap,
    required this.isDisabled,
  });

  @override
  State<_CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<_CounterButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDisabled
        ? AppColors.mutedBeige.withValues(alpha: 0.3)
        : _isPressed
            ? AppColors.warmOrange
            : AppColors.paleCream;

    final iconColor = widget.isDisabled
        ? AppColors.mutedBeige
        : _isPressed
            ? AppColors.white
            : Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTapDown: widget.isDisabled ? null : (_) {
        setState(() => _isPressed = true);
      },
      onTapUp: widget.isDisabled ? null : (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: Container(
        width: AppDimensions.minTouchTarget,
        height: AppDimensions.minTouchTarget,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          widget.icon,
          size: AppDimensions.lg,
          color: iconColor,
        ),
      ),
    );
  }
}
