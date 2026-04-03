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
/// AnimatedSwitcher로 숫자 변경 시 전환 효과 적용.
///
/// [accentColor]로 카드 좌측 악센트 바 색상을 지정하여
/// 수유/배변 카드 간 시각적 리듬(구분)을 만든다.
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

  /// 카드 좌측 악센트 바 색상. 지정하지 않으면 warmOrange 사용.
  final Color? accentColor;

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
    this.accentColor,
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

    final isDark = theme.brightness == Brightness.dark;
    final accent = widget.accentColor ?? AppColors.warmOrange;

    return Container(
      key: widget.cardKey,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left accent bar for visual rhythm between cards
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.md),
                  bottomLeft: Radius.circular(AppRadius.md),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.cardPadding),
                child: Row(
                  children: [
                    // Emoji area - larger for visual interest
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
                        borderRadius:
                            BorderRadius.circular(AppRadius.sm),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    // Label + counter group
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.label,
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          // Counter row: - [count] +
                          Row(
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
                              const SizedBox(width: AppDimensions.base),
                              // Count display with AnimatedSwitcher
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.5),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      )),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '${widget.count}${AppStrings.countSuffix}',
                                    key: ValueKey<int>(widget.count),
                                    style: theme.textTheme.displayMedium,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.base),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
/// Both buttons now share consistent styling: warmOrange tinted background
/// with warmOrange border. Disabled state uses reduced opacity.
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor;
    final Color iconColor;
    final Color borderColor;

    if (widget.isDisabled) {
      bgColor = (isDark ? AppColors.darkBorder : AppColors.mutedBeige)
          .withValues(alpha: 0.5);
      iconColor = (isDark ? AppColors.darkTextSecondary : AppColors.warmGray)
          .withValues(alpha: 0.6);
      borderColor = (isDark ? AppColors.darkBorder : AppColors.mutedBeige)
          .withValues(alpha: 0.6);
    } else if (_isPressed) {
      bgColor = AppColors.warmOrange;
      iconColor = AppColors.white;
      borderColor = AppColors.warmOrange;
    } else {
      bgColor = AppColors.warmOrange.withValues(alpha: isDark ? 0.15 : 0.1);
      iconColor = AppColors.warmOrange;
      borderColor = AppColors.warmOrange.withValues(alpha: 0.4);
    }

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: AppDimensions.minTouchTarget,
        height: AppDimensions.minTouchTarget,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: borderColor, width: 1.5),
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
