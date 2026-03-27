import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';

/// 면책 조항 + 콘텐츠 출처 다이얼로그 (2-6-6 변형).
/// "콘텐츠 출처 안내" 탭 시 표시된다.
class DisclaimerDialog extends StatelessWidget {
  const DisclaimerDialog({super.key});

  /// 다이얼로그를 표시한다.
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const DisclaimerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      key: const ValueKey('disclaimer_dialog'),
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
              AppStrings.disclaimerDialogTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.base),
            // 면책 문구
            Text(
              AppStrings.disclaimerMain,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.md),
            // 콘텐츠 출처
            Text(
              AppStrings.disclaimerSource,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.lg),
            // 닫기 버튼
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const ValueKey('disclaimer_close_button'),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppStrings.disclaimerDialogClose,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
