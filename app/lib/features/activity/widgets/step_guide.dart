import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/activity_step.dart';

/// 단계별 가이드 위젯 (2-6-7).
/// 디자인컴포넌트 2-6-7 기준.
/// warmOrange 원형 28dp 번호, warmOrange 2px 수직 연결선, Body1 텍스트.
class StepGuide extends StatelessWidget {
  final List<ActivityStep> steps;

  const StepGuide({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          key: ValueKey('step_guide_${step.stepNumber}'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 좌측: 번호 원형 + 연결선
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    // 번호 원형
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.warmOrange,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${step.stepNumber}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // 수직 연결선 (마지막이 아닌 경우)
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.warmOrange,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              // 우측: 안내 텍스트
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : AppDimensions.base,
                  ),
                  child: Text(
                    step.instruction,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
