import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/seed/reassurance_messages.dart';

/// 타이머 완료 축하 화면.
/// Lottie 애니메이션 + "잘 하셨어요!" + 안심 메시지 + CTA 버튼.
class TimerCompletionView extends StatefulWidget {
  final VoidCallback onGoToObservation;
  final VoidCallback onGoHome;

  const TimerCompletionView({
    super.key,
    required this.onGoToObservation,
    required this.onGoHome,
  });

  @override
  State<TimerCompletionView> createState() => _TimerCompletionViewState();
}

class _TimerCompletionViewState extends State<TimerCompletionView> {
  late final String _reassuranceMessage;

  @override
  void initState() {
    super.initState();
    _reassuranceMessage =
        ReassuranceMessages.getRandomActivityCompleteMessage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Lottie 애니메이션 (에셋이 없을 경우 플레이스홀더)
            SizedBox(
              key: const ValueKey('completion_lottie'),
              width: 150,
              height: 150,
              child: _buildLottie(),
            ),
            const SizedBox(height: AppDimensions.lg),
            // "잘 하셨어요!" 축하 메시지
            Text(
              AppStrings.completionCongrats,
              style: textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.md),
            // 안심 메시지
            Text(
              _reassuranceMessage,
              key: const ValueKey('completion_reassurance_message'),
              style: textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            // "오늘 아기는 어땠나요? (관찰 기록하기)" CTA 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                key: const ValueKey('go_to_observation_button'),
                onPressed: widget.onGoToObservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                ),
                child: Text(
                  AppStrings.goToObservation,
                  style: textTheme.labelLarge,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // "홈으로 돌아가기" 보조 버튼
            SizedBox(
              width: double.infinity,
              height: AppDimensions.minTouchTarget,
              child: OutlinedButton(
                key: const ValueKey('go_home_button'),
                onPressed: widget.onGoHome,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  side: BorderSide(
                    color: AppColors.lightBeige,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                ),
                child: Text(
                  AppStrings.goHome,
                  style: textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildLottie() {
    // 먼저 Lottie 에셋을 시도하고, 없으면 플레이스홀더 아이콘을 표시한다.
    return Lottie.asset(
      'assets/lottie/celebration.json',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.celebration,
          size: 100,
          color: AppColors.warmOrange,
        );
      },
    );
  }
}
