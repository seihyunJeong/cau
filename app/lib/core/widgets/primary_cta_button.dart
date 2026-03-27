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
class PrimaryCtaButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Container(
      decoration: isEnabled
          ? const BoxDecoration(boxShadow: AppShadows.low)
          : null,
      child: ElevatedButton(
        key: buttonKey,
        onPressed: onPressed,
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
          elevation: isEnabled ? 1 : 0,
          disabledBackgroundColor: AppColors.mutedBeige,
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.6),
        ),
        child: Text(label),
      ),
    );
  }
}
