import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/danger_sign_banner.dart';
import '../../../data/models/baby.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/checklist_providers.dart';
import '../../../providers/danger_sign_providers.dart';

/// 위험 신호 선택 화면.
/// 체크리스트 "결과 보기" 후 별도 화면으로 분리.
/// "한 가지만 더 확인할게요 (선택)" 제목.
/// 6항목 체크박스 + 메모 필드 + [건너뛰기] [결과 보기] 버튼.
class DangerSignScreen extends ConsumerWidget {
  const DangerSignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dangerItems = ref.watch(currentDangerSignItemsProvider);
    final signs = ref.watch(dangerSignInProgressProvider);
    ref.watch(dangerSignMemoProvider);
    final babyAsync = ref.watch(activeBabyProvider);
    final baby = babyAsync.value;

    final hasAnyChecked = signs.values.any((v) => v == true);

    return Scaffold(
      key: const ValueKey('danger_sign_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.dangerSignTitle,
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
            // 제목
            Text(
              AppStrings.dangerSignScreenTitle,
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: AppDimensions.md),
            // 안내 문구
            Text(
              AppStrings.dangerSignGuideText,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppDimensions.sectionGap),
            // 위험 신호 체크박스 목록
            ...dangerItems.map((item) {
              final isChecked = signs[item.id] ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: Container(
                  key: ValueKey('danger_sign_${item.id}'),
                  decoration: BoxDecoration(
                    color: isChecked
                        ? theme.colorScheme.primary.withValues(alpha: 0.05)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: CheckboxListTile(
                    value: isChecked,
                    onChanged: (value) {
                      ref
                          .read(dangerSignInProgressProvider.notifier)
                          .toggleSign(item.id, value ?? false);
                    },
                    title: Text(
                      item.text,
                      style: theme.textTheme.bodyLarge,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.xs,
                    ),
                    activeColor: theme.colorScheme.primary,
                    checkColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              );
            }),
            // 위험 신호 배너 (1개 이상 체크 시)
            if (hasAnyChecked) ...[
              const SizedBox(height: AppDimensions.base),
              DangerSignBanner(
                message: AppStrings.dangerSignBannerMessage,
                bannerKey: const ValueKey('danger_sign_banner'),
              ),
            ],
            const SizedBox(height: AppDimensions.sectionGap),
            // 메모 필드
            TextField(
              key: const ValueKey('danger_sign_memo_field'),
              decoration: InputDecoration(
                hintText: AppStrings.dangerSignMemoPlaceholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                contentPadding: const EdgeInsets.all(AppDimensions.base),
              ),
              maxLines: 3,
              onChanged: (value) {
                ref.read(dangerSignMemoProvider.notifier).setMemo(value);
              },
            ),
            const SizedBox(height: AppDimensions.sectionGap),
            // 반 너비 버튼 쌍
            Row(
              children: [
                // 건너뛰기 버튼
                Expanded(
                  child: SizedBox(
                    height: AppDimensions.minTouchTarget,
                    child: OutlinedButton(
                      key: const ValueKey('danger_sign_skip_button'),
                      onPressed: () => _navigateToResult(
                        context,
                        ref,
                        baby,
                        skipDangerSigns: true,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary),
                        foregroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        AppStrings.dangerSignSkipButton,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                // 결과 보기 버튼
                Expanded(
                  child: SizedBox(
                    height: AppDimensions.minTouchTarget,
                    child: ElevatedButton(
                      key: const ValueKey('danger_sign_submit_button'),
                      onPressed: () => _navigateToResult(
                        context,
                        ref,
                        baby,
                        skipDangerSigns: false,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        AppStrings.dangerSignSubmitButton,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToResult(
    BuildContext context,
    WidgetRef ref,
    Baby? baby, {
    required bool skipDangerSigns,
  }) async {
    if (baby == null || baby.id == null) return;

    // 체크리스트 결과 저장
    await saveChecklistRecord(
      ref,
      babyId: baby.id!,
      weekNumber: baby.currentWeek,
    );

    // 위험 신호 저장 (건너뛰기가 아닌 경우)
    if (!skipDangerSigns) {
      await saveDangerSignRecord(
        ref,
        babyId: baby.id!,
        weekNumber: baby.currentWeek,
      );
    } else {
      // 상태 초기화
      ref.read(dangerSignInProgressProvider.notifier).reset();
      ref.read(dangerSignMemoProvider.notifier).reset();
    }

    if (context.mounted) {
      context.go('/dev-check/result');
    }
  }
}
