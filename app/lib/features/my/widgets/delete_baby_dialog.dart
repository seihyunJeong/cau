import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';

/// 아기 삭제 확인 다이얼로그 (2-6-6).
/// "정말 삭제할까요?" 제목 + "삭제하면 모든 기록이 함께 사라져요." 본문.
/// "취소" (warmGray) + "삭제" (softRed Bold).
class DeleteBabyDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteBabyDialog({
    super.key,
    required this.onConfirm,
  });

  /// 다이얼로그를 표시하고 삭제 확인 시 콜백을 실행한다.
  static void show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => DeleteBabyDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      key: const ValueKey('delete_baby_dialog'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              AppStrings.deleteBabyDialogTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // 본문
            Text(
              AppStrings.deleteBabyDialogMessage,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.lg),
            // 버튼 행
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 취소 버튼
                TextButton(
                  key: const ValueKey('delete_baby_cancel_button'),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppStrings.deleteBabyDialogCancel,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.warmGray,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                // 삭제 버튼
                TextButton(
                  key: const ValueKey('delete_baby_confirm_button'),
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Text(
                    AppStrings.deleteBabyDialogConfirm,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.softRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
