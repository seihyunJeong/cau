import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/score_calculator.dart';
import '../../../core/widgets/danger_sign_banner.dart';
import '../../../core/widgets/half_button_pair.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../core/widgets/reassurance_card.dart';
import '../../../core/widgets/text_link_button.dart';
import '../../../data/models/baby.dart';
import '../../../data/seed/week_content_seed.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/checklist_providers.dart';
import '../../../providers/danger_sign_providers.dart';
import '../../../providers/dev_check_providers.dart';
import '../widgets/radar_chart_card.dart';
import '../widgets/result_message_card.dart';
import '../widgets/week_info_card.dart';

/// 발달 탭 메인 화면 (탭 4).
/// 개발기획서 5-6 기준.
/// State A: 이번 주 체크 안 한 경우
/// State B: 이번 주 체크 한 경우
class DevCheckMainScreen extends ConsumerWidget {
  const DevCheckMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final babyAsync = ref.watch(activeBabyProvider);
    final baby = babyAsync.value;
    final devCheckState = ref.watch(devCheckStateProvider);
    final latestResultAsync = ref.watch(latestChecklistResultProvider);
    final latestDangerAsync = ref.watch(latestDangerSignProvider);

    final weekContent = baby != null
        ? getWeekContent(baby.currentWeek)
        : weekContentSeed.first;

    return Scaffold(
      key: const ValueKey('dev_check_main_screen'),
      appBar: AppBar(
        title: Text(
          AppStrings.devCheckTitle,
          style: theme.textTheme.headlineSmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.base),
            child: Center(
              child: Text(
                baby != null ? AppStrings.weekLabelSuffix(baby.weekLabel) : '',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.base),
            // 위험 신호 배너 (최근 위험 신호 있으면 표시)
            if (latestDangerAsync.value?.hasAnySign == true) ...[
              DangerSignBanner(
                message: AppStrings.dangerSignBannerMessage,
                bannerKey: const ValueKey('dev_check_danger_banner'),
              ),
              const SizedBox(height: AppDimensions.base),
            ],
            // State A 또는 B
            if (devCheckState == DevCheckState.stateA)
              _StateAContent(
                key: const ValueKey('dev_check_state_a'),
                weekContent: weekContent,
              )
            else
              _StateBContent(
                key: const ValueKey('dev_check_state_b'),
                latestResult: latestResultAsync.value,
              ),
            const SizedBox(height: AppDimensions.xl),
            // 면책 문구
            Center(
              child: Text(
                AppStrings.disclaimerShort,
                style: AppTextStyles.tiny.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }
}

/// State A: 이번 주 체크 안 한 경우
class _StateAContent extends ConsumerWidget {
  final WeekContent weekContent;

  const _StateAContent({
    super.key,
    required this.weekContent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 주차 정보 카드
        WeekInfoCard(
          weekLabel: weekContent.weekLabel,
          theme: weekContent.theme,
          cardKey: const ValueKey('dev_check_week_info'),
        ),
        const SizedBox(height: AppDimensions.sectionGap),
        // "이 시기 아기는..." 요약
        Text(
          AppStrings.devCheckThisPeriod,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: weekContent.keyPoints.map((point) {
              return Padding(
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
                        point,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppDimensions.sectionGap),
        // CTA 버튼
        PrimaryCtaButton(
          label: AppStrings.devCheckCtaStart,
          buttonKey: const ValueKey('dev_check_cta_start'),
          onPressed: () => context.push('/dev-check/checklist'),
        ),
        const SizedBox(height: AppDimensions.md),
        // 서브 링크
        TextLinkButton(
          label: AppStrings.devCheckTrendLink,
          buttonKey: const ValueKey('dev_check_trend_link'),
          onPressed: () => context.push('/dev-check/trend'),
        ),
      ],
    );
  }
}

/// State B: 이번 주 체크 한 경우
class _StateBContent extends ConsumerWidget {
  final dynamic latestResult;

  const _StateBContent({
    super.key,
    this.latestResult,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = latestResult;
    if (record == null) return const SizedBox.shrink();

    final tier = record.tier;
    final tierMessage = ScoreCalculator.getTierMessage(tier);
    final solutionMessages = ScoreCalculator.getSolutionMessages(tier);

    // Parse domain scores from JSON
    final domainScoresJson =
        jsonDecode(record.domainScores) as Map<String, dynamic>;
    final domainScores =
        domainScoresJson.map((k, v) => MapEntry(k, v as int));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 안심 메시지 카드
        ReassuranceCard(
          message: tierMessage,
          cardKey: const ValueKey('dev_check_reassurance'),
        ),
        const SizedBox(height: AppDimensions.base),
        // 레이더 차트 카드
        RadarChartCard(
          domainScores: domainScores,
          chartKey: const ValueKey('dev_check_radar_chart'),
        ),
        const SizedBox(height: AppDimensions.base),
        // 솔루션 메시지
        ResultMessageCard(
          messages: solutionMessages,
          cardKey: const ValueKey('dev_check_solution'),
        ),
        const SizedBox(height: AppDimensions.sectionGap),
        // 반 너비 버튼 쌍
        HalfButtonPair(
          leftLabel: AppStrings.devCheckRecheckButton,
          rightLabel: AppStrings.devCheckTrendButton,
          leftKey: const ValueKey('dev_check_recheck_button'),
          rightKey: const ValueKey('dev_check_trend_button'),
          onLeftTap: () => context.push('/dev-check/checklist'),
          onRightTap: () => context.push('/dev-check/trend'),
        ),
      ],
    );
  }
}
