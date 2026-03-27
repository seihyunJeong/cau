import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';

/// 주차 정보 카드 위젯 (디자인컴포넌트 2-2-12).
/// State A에서 주차 레이블과 테마 제목을 표시한다.
/// 배경: white(라이트)/darkCard(다크), 모서리 16dp, 패딩 24dp.
class WeekInfoCard extends StatelessWidget {
  final String weekLabel;
  final String theme;
  final ValueKey<String>? cardKey;

  const WeekInfoCard({
    super.key,
    required this.weekLabel,
    required this.theme,
    this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      key: cardKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: themeData.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.weekLabelSuffix(weekLabel),
            style: themeData.textTheme.bodySmall,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            theme,
            style: themeData.textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
