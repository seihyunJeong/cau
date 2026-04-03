import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';

/// 솔루션 메시지 카드 위젯.
/// "이렇게 해보세요" + 불릿 포인트 솔루션 목록을 표시한다.
class ResultMessageCard extends StatelessWidget {
  final List<String> messages;
  final ValueKey<String>? cardKey;

  const ResultMessageCard({
    super.key,
    required this.messages,
    this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: cardKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.solutionTitle,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.md),
          ...messages.map((msg) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\u2022 ',
                      style: theme.textTheme.bodyLarge,
                    ),
                    Expanded(
                      child: Text(
                        msg,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
