import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/score_calculator.dart';
import '../../../core/widgets/empty_state_card.dart';
import '../../../core/widgets/reassurance_card.dart';
import '../../../data/models/checklist_record.dart';
import '../../../providers/checklist_providers.dart';
import '../widgets/trend_chart_card.dart';

/// 발달 추이 화면 (화면 4-3).
/// 개발기획서 5-6 기준.
/// 상단 탭: [주간] [월간] 전환.
/// 전체 추이 라인 차트 + 영역별 추이 칩 선택.
class TrendScreen extends ConsumerStatefulWidget {
  const TrendScreen({super.key});

  @override
  ConsumerState<TrendScreen> createState() => _TrendScreenState();
}

class _TrendScreenState extends ConsumerState<TrendScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDomain = 'all';

  static const _domainChips = [
    ('all', AppStrings.domainChipAll),
    ('physical', AppStrings.domainChipBody),
    ('sensory', AppStrings.domainChipSensory),
    ('cognitive', AppStrings.domainChipFocus),
    ('language', AppStrings.domainChipSound),
    ('emotional', AppStrings.domainChipHeart),
    ('regulation', AppStrings.domainChipRhythm),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final historyAsync = ref.watch(checklistHistoryProvider);
    final records = historyAsync.value ?? [];

    return Scaffold(
      key: const ValueKey('trend_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.trendTitle,
          style: theme.textTheme.headlineSmall,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              key: const ValueKey('trend_tab_weekly'),
              text: AppStrings.trendTabWeekly,
            ),
            Tab(
              key: const ValueKey('trend_tab_monthly'),
              text: AppStrings.trendTabMonthly,
            ),
          ],
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.textTheme.bodySmall?.color,
          indicatorColor: theme.colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTrendContent(context, records, isWeekly: true),
          _buildTrendContent(context, records, isWeekly: false),
        ],
      ),
    );
  }

  Widget _buildTrendContent(
    BuildContext context,
    List<ChecklistRecord> records, {
    required bool isWeekly,
  }) {
    final theme = Theme.of(context);

    if (records.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.xl),
            EmptyStateCard(
              icon: Icons.insights_outlined,
              message: AppStrings.trendEmpty,
              cardKey: const ValueKey('trend_empty_state'),
            ),
          ],
        ),
      );
    }

    // Filter records based on weekly/monthly
    final filteredRecords = isWeekly
        ? records
        : _groupByMonth(records);

    // Build overall chart spots
    final overallSpots = <FlSpot>[];
    final xLabels = <String>[];
    for (int i = 0; i < filteredRecords.length; i++) {
      overallSpots.add(FlSpot(i.toDouble(), filteredRecords[i].percentage));
      xLabels.add(AppStrings.weekSuffix(filteredRecords[i].weekNumber));
    }

    // Build domain-specific chart spots
    List<FlSpot> domainSpots = [];
    if (_selectedDomain != 'all' && filteredRecords.isNotEmpty) {
      for (int i = 0; i < filteredRecords.length; i++) {
        final domainScoresJson =
            jsonDecode(filteredRecords[i].domainScores)
                as Map<String, dynamic>;
        final score = domainScoresJson[_selectedDomain] as int? ?? 0;
        final pct = (score / 12) * 100;
        domainSpots.add(FlSpot(i.toDouble(), pct));
      }
    }

    // Compare message
    String compareMessage = AppStrings.trendCompareSimilar;
    if (filteredRecords.length >= 2) {
      final current = filteredRecords.last.percentage;
      final previous =
          filteredRecords[filteredRecords.length - 2].percentage;
      compareMessage =
          ScoreCalculator.getTrendMessage(current, previous);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.base),
          // 안심 메시지
          ReassuranceCard(
            message: AppStrings.trendReassurance,
            cardKey: const ValueKey('trend_reassurance'),
          ),
          const SizedBox(height: AppDimensions.base),
          // 전체 추이 차트
          TrendChartCard(
            spots: overallSpots,
            xLabels: xLabels,
            title: AppStrings.trendOverallTitle,
            chartKey: const ValueKey('trend_overall_chart'),
          ),
          const SizedBox(height: AppDimensions.sm),
          // 비교 메시지
          if (filteredRecords.length >= 2)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.sm,
              ),
              child: Text(
                compareMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          const SizedBox(height: AppDimensions.sectionGap),
          // 영역별 추이 섹션
          Text(
            AppStrings.trendDomainTitle,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.md),
          // 영역 칩
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: _domainChips.map((chip) {
              final isSelected = _selectedDomain == chip.$1;
              return ChoiceChip(
                key: ValueKey('trend_domain_chip_${chip.$1}'),
                label: Text(chip.$2),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedDomain = chip.$1;
                  });
                },
                selectedColor: theme.colorScheme.primary,
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
                backgroundColor: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.md),
          // 영역별 추이 차트 (전체 외 선택 시)
          if (_selectedDomain != 'all' && domainSpots.isNotEmpty)
            TrendChartCard(
              spots: domainSpots,
              xLabels: xLabels,
              title: ScoreCalculator.domainDisplayNames[_selectedDomain],
              chartKey: const ValueKey('trend_domain_chart'),
            ),
          if (_selectedDomain == 'all')
            TrendChartCard(
              spots: overallSpots,
              xLabels: xLabels,
              title: AppStrings.domainChipAll,
              chartKey: const ValueKey('trend_domain_chart'),
            ),
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    );
  }

  /// 월 단위로 기록을 그룹화한다 (각 월의 마지막 기록만 사용).
  List<ChecklistRecord> _groupByMonth(List<ChecklistRecord> records) {
    if (records.isEmpty) return [];

    final Map<String, ChecklistRecord> monthly = {};
    for (final record in records) {
      final key =
          '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}';
      monthly[key] = record; // 마지막 기록으로 덮어씀
    }

    return monthly.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
