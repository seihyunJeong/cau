import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radius.dart';

/// 위험 신호 안내 배너 위젯 (디자인컴포넌트 2-6-4).
/// softYellow 20% 불투명 배경, 16dp 모서리 둥글기.
/// 안심 톤의 안내 메시지를 표시한다.
class DangerSignBanner extends StatelessWidget {
  final String message;
  final ValueKey<String>? bannerKey;

  const DangerSignBanner({
    super.key,
    required this.message,
    this.bannerKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: bannerKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppColors.softYellow.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: AppDimensions.iconSizeMd,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
