import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../data/seed/reassurance_messages.dart';
import '../../../shared/widgets/confetti_animation.dart';

/// 타이머 완료 축하 화면.
/// ConfettiAnimation (CustomPainter) + "잘 하셨어요!" + 안심 메시지 + CTA 버튼.
/// Lottie placeholder를 실제 confetti 애니메이션으로 교체.
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

class _TimerCompletionViewState extends State<TimerCompletionView>
    with SingleTickerProviderStateMixin {
  late final String _reassuranceMessage;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _reassuranceMessage =
        ReassuranceMessages.getRandomActivityCompleteMessage();

    // Fade in the text content after confetti starts
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    // Delay slightly so confetti appears first
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
            // Confetti animation (code-based, replaces Lottie placeholder)
            const SizedBox(
              key: ValueKey('completion_confetti'),
              width: 180,
              height: 180,
              child: ConfettiAnimation(
                width: 180,
                height: 180,
                duration: Duration(milliseconds: 2500),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            // "잘 하셨어요!" 축하 메시지 with fade-in
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                AppStrings.completionCongrats,
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // 안심 메시지 with fade-in
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                _reassuranceMessage,
                key: const ValueKey('completion_reassurance_message'),
                style: textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 3),
            // "오늘 아기는 어땠나요? (관찰 기록하기)" CTA 버튼
            PrimaryCtaButton(
              label: AppStrings.goToObservation,
              buttonKey: const ValueKey('go_to_observation_button'),
              onPressed: widget.onGoToObservation,
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
}
