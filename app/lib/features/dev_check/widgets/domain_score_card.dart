import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/utils/score_calculator.dart';
import '../../../core/widgets/filled_dots_indicator.dart';

/// 영역별 결과 카드 위젯 (디자인컴포넌트 2-2-9).
/// 영역명 + 영역 메시지 + 채워진 도트 인디케이터를 표시한다.
class DomainScoreCard extends StatelessWidget {
  final String domain;
  final int score;

  /// 이전 주차 대비 변화 메시지 (선택).
  final String? trendMessage;
  final ValueKey<String>? cardKey;

  const DomainScoreCard({
    super.key,
    required this.domain,
    required this.score,
    this.trendMessage,
    this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName =
        ScoreCalculator.domainDisplayNames[domain] ?? domain;
    final message = ScoreCalculator.getDomainMessage(domain, score);
    final dots = FilledDotsIndicator.scoreToDots(score);

    return Container(
      key: cardKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayName,
                style: theme.textTheme.headlineSmall,
              ),
              FilledDotsIndicator(filledCount: dots),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
          ),
          if (trendMessage != null) ...[
            const SizedBox(height: AppDimensions.xs),
            Text(
              trendMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
