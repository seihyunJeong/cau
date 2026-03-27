import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/score_calculator.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../data/models/checklist_item.dart';
import '../../../providers/checklist_providers.dart';
import '../widgets/checklist_item_tile.dart';

/// 체크리스트 18문항 폼 화면 (화면 4-1).
/// 개발기획서 5-6 기준.
/// 6개 영역 x 3문항 = 18문항, 각 0~4점 ScoreSelector.
/// 프로그레스 바 + 하단 고정 [결과 보기] CTA 버튼.
class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final items = ref.watch(currentChecklistItemsProvider);
    final responses = ref.watch(checklistInProgressProvider);
    final memos = ref.watch(checklistMemosInProgressProvider);

    // 진행률 계산 (0~1)
    final progress = items.isNotEmpty
        ? responses.length / items.length
        : 0.0;

    // 영역별 그룹화
    final groupedItems = <String, List<ChecklistItem>>{};
    for (final item in items) {
      groupedItems.putIfAbsent(item.domain, () => []).add(item);
    }

    return Scaffold(
      key: const ValueKey('checklist_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.devCheckCtaStart,
          style: theme.textTheme.headlineSmall,
        ),
      ),
      body: Column(
        children: [
          // 프로그레스 바
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.sm),
                ClipRRect(
                  key: const ValueKey('checklist_progress_bar'),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: AppDimensions.xs,
                    backgroundColor: AppColors.trackGray,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.warmOrange,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  AppStrings.checklistProgressLabel,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          // 문항 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              itemCount: groupedItems.length,
              itemBuilder: (context, sectionIndex) {
                final domain = groupedItems.keys.elementAt(sectionIndex);
                final sectionItems = groupedItems[domain]!;
                final displayName =
                    ScoreCalculator.domainDisplayNames[domain] ?? domain;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sectionIndex > 0)
                      const SizedBox(height: AppDimensions.base),
                    // 영역 헤더
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.sm,
                      ),
                      child: Text(
                        displayName,
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    // 문항들
                    ...sectionItems.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      // 첫 번째 문항(physical_0)에만 (?) 아이콘 표시
                      final isFirstItem =
                          sectionIndex == 0 && idx == 0;

                      return ChecklistItemTile(
                        item: item,
                        selectedScore: responses[item.id],
                        memo: memos[item.id],
                        showScoreGuide: isFirstItem,
                        onScoreSelected: (score) {
                          ref
                              .read(checklistInProgressProvider.notifier)
                              .setResponse(item.id, score);
                        },
                        onMemoChanged: (memo) {
                          ref
                              .read(
                                  checklistMemosInProgressProvider.notifier)
                              .setMemo(item.id, memo);
                        },
                        onScoreGuidePressed: isFirstItem
                            ? () => _showScoreGuide(context)
                            : null,
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          // 하단 고정 [결과 보기] CTA 버튼
          Container(
            padding: const EdgeInsets.all(AppDimensions.base),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
            ),
            child: SafeArea(
              top: false,
              child: PrimaryCtaButton(
                label: AppStrings.checklistSubmitButton,
                buttonKey: const ValueKey('checklist_submit_button'),
                onPressed: () {
                  context.push('/dev-check/checklist/danger-signs');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showScoreGuide(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.checklistScoreGuideTitle,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppDimensions.base),
              _scoreGuideRow(theme, AppStrings.checklistScoreGuide4),
              _scoreGuideRow(theme, AppStrings.checklistScoreGuide3),
              _scoreGuideRow(theme, AppStrings.checklistScoreGuide2),
              _scoreGuideRow(theme, AppStrings.checklistScoreGuide1),
              _scoreGuideRow(theme, AppStrings.checklistScoreGuide0),
              const SizedBox(height: AppDimensions.base),
            ],
          ),
        );
      },
    );
  }

  Widget _scoreGuideRow(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}
