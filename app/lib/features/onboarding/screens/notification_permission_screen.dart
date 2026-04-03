import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../data/models/baby.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/core_providers.dart';
import '../../../services/app_settings_service.dart';
import '../../../services/notification_scheduler.dart';
import '../../../services/notification_service.dart';
import '../../../shared/widgets/bell_animation.dart';

/// 온보딩 화면 D: 알림 권한 화면.
/// 개발기획서 5-1 화면 D 기준.
/// 알림 가치 설명, "알림 받기" CTA, "나중에 설정할게요" 텍스트 링크.
/// 완료 시 `isOnboardingComplete = true` 설정 후 홈으로 이동.
class NotificationPermissionScreen extends ConsumerWidget {
  const NotificationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      key: const ValueKey('notification_screen'),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // -- 벨 애니메이션 (CustomPainter 기반) --
              _buildBellAnimation(theme.brightness == Brightness.dark),
              const SizedBox(height: AppDimensions.xl),
              // -- 제목 --
              Text(
                AppStrings.notificationTitle,
                key: const ValueKey('notification_title'),
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.lg),
              // -- 알림 가치 설명 (불릿 리스트) --
              _buildBenefitsList(textTheme),
              const Spacer(flex: 3),
              // -- "알림 받기" CTA 버튼 --
              PrimaryCtaButton(
                label: AppStrings.notificationAllowButton,
                buttonKey: const ValueKey('notification_allow_button'),
                onPressed: () => _onAllowNotification(context, ref),
              ),
              const SizedBox(height: AppDimensions.base),
              // -- "나중에 설정할게요" 텍스트 링크 (2-3-6) --
              SizedBox(
                height: AppDimensions.minTouchTarget,
                child: TextButton(
                  key: const ValueKey('notification_skip_button'),
                  onPressed: () => _onSkipNotification(context, ref),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.warmOrange,
                    textStyle: textTheme.labelMedium,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.base,
                    ),
                  ),
                  child: const Text(AppStrings.notificationSkipButton),
                ),
              ),
              const SizedBox(height: AppDimensions.base),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBellAnimation(bool isDark) {
    // CustomPainter 기반 BellAnimation으로 Lottie placeholder를 대체.
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.paleCream,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: BellAnimation(
          size: 72,
          autoPlay: true,
          duration: Duration(milliseconds: 1500),
        ),
      ),
    );
  }

  Widget _buildBenefitsList(TextTheme textTheme) {
    final benefits = [
      AppStrings.notificationBenefit1,
      AppStrings.notificationBenefit2,
      AppStrings.notificationBenefit3,
    ];

    return Column(
      children: benefits
          .map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 7),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.warmOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: Text(
                        benefit,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Future<void> _onAllowNotification(
      BuildContext context, WidgetRef ref) async {
    final settings = ref.read(appSettingsServiceProvider);

    try {
      // NotificationService를 통한 OS 알림 권한 요청
      final granted = await NotificationService.requestPermission();

      if (granted) {
        await settings.setDailyNotificationOn(true);
        await settings.setRecordReminderOn(true);
        await settings.setWeekTransitionOn(true);
        await settings.setMilestoneOn(true);

        // 기본 알림 3종 스케줄 등록
        await NotificationScheduler.scheduleDailyMission(
          time: settings.dailyNotificationTime,
        );

        // 아기 정보 기반 알림 스케줄 등록
        final baby = ref.read(activeBabyProvider).value;
        if (baby != null) {
          await NotificationScheduler.scheduleWeekTransition(
            birthDate: baby.birthDate,
            weekLabel: baby.weekLabel,
          );
          await NotificationScheduler.scheduleAllMilestones(
            birthDate: baby.birthDate,
            babyName: baby.name,
          );
        }
      } else {
        // 거부 시에도 부정적 메시지 없이 진행
        await settings.setDailyNotificationOn(false);
      }
    } catch (e) {
      // 권한 요청 실패 시에도 진행 (플랫폼 미지원 등)
      await settings.setDailyNotificationOn(false);
      debugPrint('알림 권한 요청 실패: $e');
    }

    if (!context.mounted) return;
    await _completeOnboarding(context, settings);
  }

  Future<void> _onSkipNotification(
      BuildContext context, WidgetRef ref) async {
    final settings = ref.read(appSettingsServiceProvider);
    await settings.setDailyNotificationOn(false);
    if (!context.mounted) return;
    await _completeOnboarding(context, settings);
  }

  Future<void> _completeOnboarding(
      BuildContext context, AppSettingsService settings) async {
    await settings.setOnboardingComplete(true);
    if (context.mounted) {
      // go()를 사용하여 라우트 스택을 클리어 -- 뒤로 가기로 온보딩 재진입 불가
      context.go('/home');
    }
  }
}
