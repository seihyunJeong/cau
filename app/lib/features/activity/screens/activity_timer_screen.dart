import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/activity.dart';
import '../../../data/seed/activity_seed.dart';
import '../../../providers/activity_providers.dart';
import '../../../providers/baby_providers.dart';
import '../widgets/timer_completion_view.dart';
import '../widgets/timer_ring_painter.dart';

/// 활동 타이머 화면 (화면 3-2).
/// 개발기획서 5-5 화면 3-2 기준.
/// 원형 프로그레스 타이머 + 카운트다운 + 완료 화면.
class ActivityTimerScreen extends ConsumerStatefulWidget {
  final String activityId;

  const ActivityTimerScreen({super.key, required this.activityId});

  @override
  ConsumerState<ActivityTimerScreen> createState() =>
      _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends ConsumerState<ActivityTimerScreen> {
  Activity? _activity;
  bool _completionSaved = false;
  bool _timerInitialized = false;
  int? _savedActivityRecordId;

  @override
  void initState() {
    super.initState();
    _activity = activitySeed.cast<Activity?>().firstWhere(
          (a) => a?.id == widget.activityId,
          orElse: () => null,
        );
  }

  void _ensureTimerInitialized() {
    if (!_timerInitialized && _activity != null) {
      _timerInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(activityTimerProvider.notifier)
            .initTimer(_activity!.recommendedSeconds);
      });
    }
  }

  /// 완료 시 DB 저장 + 진동.
  Future<void> _handleCompletion({
    required bool timerUsed,
    int? timerDurationSec,
  }) async {
    if (_completionSaved) return;
    _completionSaved = true;

    // 진동 알림
    HapticFeedback.heavyImpact();

    final baby = ref.read(activeBabyProvider).value;
    if (baby == null || baby.id == null || _activity == null) return;

    final recordId = await saveActivityRecord(
      ref,
      babyId: baby.id!,
      activityId: _activity!.id,
      weekNumber: _activity!.weekIndex,
      timerUsed: timerUsed,
      timerDurationSec: timerDurationSec,
    );
    _savedActivityRecordId = recordId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (_activity == null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.activityTitle)),
        body: Center(
          child: Text(
            AppStrings.activityEmptyWeek,
            style: textTheme.bodyLarge,
          ),
        ),
      );
    }

    _ensureTimerInitialized();

    final activity = _activity!;
    final timerState = ref.watch(activityTimerProvider);
    final timerNotifier = ref.read(activityTimerProvider.notifier);

    // 타이머 완료 시 자동 저장
    if (timerState.isCompleted && !_completionSaved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleCompletion(
          timerUsed: true,
          timerDurationSec: timerState.elapsedSeconds,
        );
      });
    }

    // 완료 화면
    if (timerState.isCompleted) {
      return Scaffold(
        key: const ValueKey('activity_timer_screen'),
        appBar: AppBar(
          title: Text(activity.name),
          automaticallyImplyLeading: false,
        ),
        body: TimerCompletionView(
          onGoToObservation: () {
            if (_savedActivityRecordId != null) {
              context.go('/observation/$_savedActivityRecordId');
            } else {
              context.go('/home');
            }
          },
          onGoHome: () {
            context.go('/home');
          },
        ),
      );
    }

    // 타이머 화면
    return Scaffold(
      key: const ValueKey('activity_timer_screen'),
      appBar: AppBar(
        title: Text(activity.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            key: const ValueKey('timer_skip_button'),
            onPressed: () {
              _handleCompletion(timerUsed: false);
              timerNotifier.completeWithoutTimer();
            },
            child: Text(
              AppStrings.timerSkip,
              style: textTheme.labelMedium,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // 원형 타이머
            SizedBox(
              key: const ValueKey('circular_timer'),
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: TimerRingPainter(
                  progress: timerState.progress,
                ),
                child: Center(
                  child: Text(
                    timerState.formattedTime,
                    style: textTheme.displaySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // 거의 다 됐어요 (5초 이하)
            if (timerState.isRunning && timerState.remainingSeconds <= 5)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: Text(
                  AppStrings.timerAlmostDone,
                  key: const ValueKey('timer_almost_done_text'),
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.warmOrange,
                  ),
                ),
              ),

            // 타이머 안내 문구
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: Text(
                _getCurrentGuideText(timerState.elapsedSeconds, activity),
                key: const ValueKey('timer_guide_text'),
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 2),

            // 타이머 컨트롤 버튼들
            _TimerControls(
              isRunning: timerState.isRunning,
              onStart: () => timerNotifier.start(),
              onPause: () => timerNotifier.pause(),
              onReset: () => timerNotifier.reset(),
            ),
            const SizedBox(height: AppDimensions.lg),

            // "타이머 없이 완료하기" 보조 버튼
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.minTouchTarget,
                child: OutlinedButton(
                  key: const ValueKey('complete_without_timer_button'),
                  onPressed: () {
                    _handleCompletion(timerUsed: false);
                    timerNotifier.completeWithoutTimer();
                  },
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
                    AppStrings.completeWithoutTimer,
                    style: textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
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

  /// 현재 경과 시간에 맞는 가이드 텍스트를 반환한다.
  String _getCurrentGuideText(int elapsedSeconds, Activity activity) {
    final guideSteps = activity.steps
        .where((s) => s.timerGuideText != null)
        .toList();
    if (guideSteps.isEmpty) return '';

    // 전체 시간을 guideSteps 수로 나누어 순차 전환
    final totalSeconds = activity.recommendedSeconds;
    final segmentLength =
        totalSeconds > 0 ? totalSeconds / guideSteps.length : 1;
    final currentIndex = (elapsedSeconds / segmentLength)
        .floor()
        .clamp(0, guideSteps.length - 1);

    return guideSteps[currentIndex].timerGuideText ?? '';
  }

}

/// 타이머 컨트롤 버튼 (시작/일시정지/리셋).
class _TimerControls extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  const _TimerControls({
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 리셋 버튼
        _ControlButton(
          key: const ValueKey('timer_reset_button'),
          icon: Icons.replay,
          onTap: onReset,
          theme: theme,
        ),
        const SizedBox(width: AppDimensions.xl),
        // 시작/일시정지 버튼
        if (isRunning)
          _ControlButton(
            key: const ValueKey('timer_pause_button'),
            icon: Icons.pause,
            onTap: onPause,
            theme: theme,
            isPrimary: true,
          )
        else
          _ControlButton(
            key: const ValueKey('timer_start_button'),
            icon: Icons.play_arrow,
            onTap: onStart,
            theme: theme,
            isPrimary: true,
          ),
        const SizedBox(width: AppDimensions.xl),
        // 플레이스홀더 (대칭 레이아웃)
        const SizedBox(width: AppDimensions.minTouchTarget),
      ],
    );
  }
}

/// 개별 컨트롤 버튼 (press 시 스케일 + 색상 피드백 포함).
class _ControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool isPrimary;

  const _ControlButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.theme,
    this.isPrimary = false,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.isPrimary ? 64.0 : AppDimensions.minTouchTarget;
    final bgColor = widget.isPrimary
        ? (_isPressed
            ? widget.theme.colorScheme.primary.withValues(alpha: 0.85)
            : widget.theme.colorScheme.primary)
        : (_isPressed
            ? AppColors.warmOrange.withValues(alpha: 0.15)
            : AppColors.paleCream);
    final iconColor = widget.isPrimary
        ? widget.theme.colorScheme.onPrimary
        : (_isPressed ? AppColors.warmOrange : widget.theme.colorScheme.onSurface);

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _pressController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _pressController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: widget.isPrimary && !_isPressed
                ? [
                    BoxShadow(
                      color: widget.theme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            widget.icon,
            color: iconColor,
            size: widget.isPrimary ? 32 : 24,
          ),
        ),
      ),
    );
  }
}
