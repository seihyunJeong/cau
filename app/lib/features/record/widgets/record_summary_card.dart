import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/daily_record.dart';

/// 기록 요약 카드 -- 히스토리용 (디자인컴포넌트 2-2-4).
/// 날짜 헤더 + 카드 내부에 수유/배변/수면/메모 표시.
/// 각 기록 유형별 색상 배경 아이콘으로 시각적 구분을 강화한다.
class RecordSummaryCard extends StatelessWidget {
  final DailyRecord record;

  const RecordSummaryCard({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = nowKST();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate =
        DateTime(record.date.year, record.date.month, record.date.day);
    final isToday = recordDate == today;
    final dateFormat = DateFormat('M월 d일', 'ko_KR');
    final dateStr = isToday
        ? '${dateFormat.format(record.date)} (${AppStrings.today})'
        : dateFormat.format(record.date);
    final cardKeyStr =
        'record_card_${record.date.year.toString().padLeft(4, '0')}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header (outside card)
        Text(
          dateStr,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.sm),
        // Card
        Container(
          key: ValueKey(cardKeyStr),
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.cardPaddingCompact),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow(
                theme,
                emoji: String.fromCharCode(0x1F37C),
                label: AppStrings.feedingLabel,
                value: '${record.feedingCount}${AppStrings.countSuffix}',
                accentColor: AppColors.warmOrange,
              ),
              _divider(),
              _buildRow(
                theme,
                emoji: String.fromCharCode(0x1F9F7),
                label: AppStrings.diaperLabel,
                value: '${record.diaperCount}${AppStrings.countSuffix}',
                accentColor: AppColors.softGreen,
              ),
              if (record.sleepHours != null) ...[
                _divider(),
                _buildRow(
                  theme,
                  emoji: String.fromCharCode(0x1F4A4),
                  label: AppStrings.sleepLabel,
                  value: _formatSleep(record.sleepHours!),
                  accentColor: AppColors.domainVision,
                ),
              ],
              if (record.memo != null && record.memo!.isNotEmpty) ...[
                _divider(),
                _buildRow(
                  theme,
                  emoji: String.fromCharCode(0x1F4DD),
                  label: AppStrings.memoLabel.replaceAll(' (선택)', ''),
                  value: record.memo!,
                  accentColor: AppColors.warmGray,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
    ThemeData theme, {
    required String emoji,
    required String label,
    required String value,
    required Color accentColor,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
      child: Row(
        children: [
          // 색상 배경 이모지 아이콘
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            label,
            style: theme.textTheme.bodyLarge,
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color: AppColors.lightBeige,
    );
  }

  String _formatSleep(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return AppStrings.sleepValue(h, m);
  }
}
