import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_shadows.dart';
import '../constants/app_text_styles.dart';

/// 기본 CTA 버튼 (2-3-1).
/// 디자인컴포넌트 2-3-1 기준.
///
/// - 배경: warmOrange (#F5A623)
/// - 텍스트: Button (16sp, SemiBold, white)
/// - 모서리 둥글기: 24dp
/// - 높이: 52dp
/// - 너비: 전체 너비 (좌우 패딩 제외)
/// - 비활성 시: mutedBeige (#C4B5A5) 배경, white 60% 텍스트
/// - Press 시: 스케일 0.97 + 그림자 subtle로 변경 (생동감 강화)
class PrimaryCtaButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ValueKey<String>? buttonKey;

  const PrimaryCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.buttonKey,
  });

  @override
  State<PrimaryCtaButton> createState() => _PrimaryCtaButtonState();
}

class _PrimaryCtaButtonState extends State<PrimaryCtaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: isEnabled
                ? (_isPressed
                    ? AppShadows.adaptiveSubtle(isDark)
                    : AppShadows.adaptiveMedium(isDark))
                : null,
          ),
          child: ElevatedButton(
            key: widget.buttonKey,
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEnabled ? AppColors.warmOrange : AppColors.mutedBeige,
              foregroundColor: isEnabled
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.6),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              textStyle: AppTextStyles.button,
              elevation: 0,
              disabledBackgroundColor: AppColors.mutedBeige,
              disabledForegroundColor:
                  AppColors.white.withValues(alpha: 0.6),
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
