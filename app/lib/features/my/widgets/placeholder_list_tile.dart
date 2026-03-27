import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

/// 플레이스홀더 ListTile.
/// 탭 시 "곧 준비될 기능이에요" 토스트를 표시한다.
/// MVP에서 아직 구현되지 않은 기능에 사용한다.
class PlaceholderListTile extends StatelessWidget {
  final String title;
  final ValueKey<String>? tileKey;

  const PlaceholderListTile({
    super.key,
    required this.title,
    this.tileKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      key: tileKey,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.textTheme.bodySmall?.color,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      minTileHeight: AppDimensions.minTouchTarget,
      onTap: () {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.featureComingSoon,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}
