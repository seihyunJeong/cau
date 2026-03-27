import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/score_calculator.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../core/widgets/reassurance_card.dart';
import '../../../data/models/baby.dart';
import '../../../data/models/checklist_record.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/checklist_providers.dart';
import '../../../providers/core_providers.dart';
import '../widgets/domain_score_card.dart';
import '../widgets/radar_chart_card.dart';
import '../widgets/result_message_card.dart';

/// 체크리스트 결과 화면 (화면 4-2).
/// 개발기획서 5-6 기준.
/// 안심 메시지 + 레이더 차트 + 영역별 카드 + 솔루션 메시지.
/// 숫자(총점/퍼센트) 완전 제거.
class ChecklistResultScreen extends ConsumerStatefulWidget {
  const ChecklistResultScreen({super.key});

  @override
  ConsumerState<ChecklistResultScreen> createState() =>
      _ChecklistResultScreenState();
}

class _ChecklistResultScreenState
    extends ConsumerState<ChecklistResultScreen> {
  ChecklistRecord? _previousRecord;

  @override
  void initState() {
    super.initState();
    _loadPreviousRecord();
  }

  Future<void> _loadPreviousRecord() async {
    final baby = ref.read(activeBabyProvider).value;
    if (baby == null || baby.id == null) return;

    final dao = ref.read(checklistRecordDaoProvider);
    final previous =
        await dao.getPreviousRecord(baby.id!, baby.currentWeek);

    if (mounted) {
      setState(() {
        _previousRecord = previous;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latestAsync = ref.watch(latestChecklistResultProvider);
    final record = latestAsync.value;

    if (record == null) {
      return Scaffold(
        key: const ValueKey('checklist_result_screen'),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
          title: Text(
            AppStrings.checklistResultTitle,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final tier = record.tier;
    final tierMessage = ScoreCalculator.getTierMessage(tier);
    final solutionMessages = ScoreCalculator.getSolutionMessages(tier);

    // Parse domain scores from JSON
    final domainScoresJson =
        jsonDecode(record.domainScores) as Map<String, dynamic>;
    final domainScores =
        domainScoresJson.map((k, v) => MapEntry(k, v as int));

    // Parse previous domain scores for trend comparison
    Map<String, int>? previousDomainScores;
    if (_previousRecord != null) {
      final prevJson = jsonDecode(_previousRecord!.domainScores)
          as Map<String, dynamic>;
      previousDomainScores =
          prevJson.map((k, v) => MapEntry(k, v as int));
    }

    return Scaffold(
      key: const ValueKey('checklist_result_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          AppStrings.checklistResultTitle,
          style: theme.textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.base),
            // 안심 메시지 카드
            ReassuranceCard(
              message: tierMessage,
              cardKey: const ValueKey('result_reassurance_card'),
            ),
            const SizedBox(height: AppDimensions.sectionGap),
            // 영역별 살펴보기 섹션
            Text(
              AppStrings.checklistResultDomainSection,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppDimensions.md),
            // 레이더 차트
            RadarChartCard(
              domainScores: domainScores,
              chartKey: const ValueKey('result_radar_chart'),
            ),
            const SizedBox(height: AppDimensions.md),
            // 영역별 카드
            ...ScoreCalculator.domains.map((domain) {
              final score = domainScores[domain] ?? 0;
              String? trendMsg;
              if (previousDomainScores != null) {
                final prevScore = previousDomainScores[domain] ?? 0;
                final currPct = (score / 12) * 100;
                final prevPct = (prevScore / 12) * 100;
                trendMsg =
                    ScoreCalculator.getTrendMessage(currPct, prevPct);
              }

              return Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.sm),
                child: DomainScoreCard(
                  domain: domain,
                  score: score,
                  trendMessage: trendMsg,
                  cardKey:
                      ValueKey('result_domain_$domain'),
                ),
              );
            }),
            const SizedBox(height: AppDimensions.base),
            // 솔루션 메시지
            ResultMessageCard(
              messages: solutionMessages,
              cardKey: const ValueKey('result_solution_section'),
            ),
            const SizedBox(height: AppDimensions.sectionGap),
            // CTA 버튼
            PrimaryCtaButton(
              label: AppStrings.checklistResultGoHome,
              buttonKey: const ValueKey('result_go_home_button'),
              onPressed: () => context.go('/home'),
            ),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }
}
