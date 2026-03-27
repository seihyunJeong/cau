import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/observation_interpreter.dart';

/// 관찰 결과 화면 (화면 3-4).
/// 개발기획서 5-5 화면 3-4 기준.
/// 관찰 기록 제출 후 자동 전환되는 결과 화면.
/// 숫자 없이 말로만 결과를 표현한다 (UX 원칙 2).
class ObservationResultScreen extends ConsumerWidget {
  final String activityRecordId;
  final int interpretationLevel;

  const ObservationResultScreen({
    super.key,
    required this.activityRecordId,
    required this.interpretationLevel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final message = ObservationInterpreter.getMessage(interpretationLevel);
    final title = ObservationInterpreter.getTitle(interpretationLevel);
    final solutions =
        ObservationInterpreter.getSolutions(interpretationLevel);
    final icon = ObservationInterpreter.getIcon(interpretationLevel);
    final iconColor =
        ObservationInterpreter.getIconColor(interpretationLevel);

    // 메인 메시지를 첫 줄(title)과 나머지(sub)로 분리
    final messageParts = message.split('\n');
    final mainMessage = messageParts.isNotEmpty ? messageParts[0] : '';
    final subMessage =
        messageParts.length > 1 ? messageParts.sublist(1).join('\n') : '';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        key: const ValueKey('observation_result_screen'),
        appBar: AppBar(
          title: Text(AppStrings.resultTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.xl),
                // ── 안심 메시지 카드 (2-2-7) ──
                Container(
                  key: const ValueKey('observation_result_card'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCard
                        : AppColors.mintTint,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: AppDimensions.xl,
                        color: iconColor,
                      ),
                      const SizedBox(height: AppDimensions.md),
                      // 메인 타이틀
                      Text(
                        title,
                        style: textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      // 메인 메시지
                      Text(
                        mainMessage,
                        style: textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.warmGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (subMessage.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          subMessage,
                          style: textTheme.bodyLarge?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.warmGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),

                // ── 솔루션 카드 ──
                if (solutions.isNotEmpty)
                  Container(
                    key: const ValueKey('observation_solutions_card'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.cardPadding),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.solutionTitle,
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        ...solutions.map((solution) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppDimensions.sm),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: AppDimensions.xs),
                                    child: Icon(
                                      Icons.lightbulb_outline,
                                      size: 18,
                                      color: AppColors.warmOrange,
                                    ),
                                  ),
                                  const SizedBox(width: AppDimensions.sm),
                                  Expanded(
                                    child: Text(
                                      solution,
                                      style: textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                const SizedBox(height: AppDimensions.lg),

                // ── 안심 서브 메시지 ──
                Text(
                  AppStrings.observationGrowthPatternHint,
                  key: const ValueKey('observation_growth_pattern_hint'),
                  style: textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.warmGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── [홈으로] CTA 버튼 ──
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    key: const ValueKey('observation_go_home_button'),
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warmOrange,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.xl),
                      ),
                    ),
                    child: Text(
                      AppStrings.observationGoHome,
                      style: textTheme.labelLarge,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
