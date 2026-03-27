import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_strings.dart';

/// "저장됨" 토스트 헬퍼 (2-6-2).
/// 디자인컴포넌트 2-6-2 기준.
/// - 위치: 화면 하단 중앙, 하단 탭 바 위 16dp
/// - 배경: darkBrown 80% 불투명
/// - 텍스트: "저장됨" (Caption, 13sp, white)
/// - 모서리: 8dp
/// - 표시 시간: 1초
void showSavedToast(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        AppStrings.saved,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
            ),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.darkBrown.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      margin: const EdgeInsets.only(
        left: 80,
        right: 80,
        bottom: 16,
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  );
}
