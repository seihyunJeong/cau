import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_cta_button.dart';
import '../../../data/models/baby.dart';
import '../../../data/seed/week_content_seed.dart';
import '../../../providers/baby_providers.dart';

/// 온보딩 화면 C: 주차 소개 화면.
/// 개발기획서 5-1 화면 C 기준.
/// Lottie 축하 애니메이션, 아기 이름 인사, 주차 정보 카드, "다음" 버튼.
class WeekIntroScreen extends ConsumerWidget {
  const WeekIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final babyAsync = ref.watch(activeBabyProvider);
    final theme = Theme.of(context);

    return Scaffold(
      key: const ValueKey('intro_screen'),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: babyAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.warmOrange),
          ),
          error: (e, st) => const Center(child: Text('오류가 발생했어요')),
          data: (baby) {
            if (baby == null) {
              return const Center(child: Text('아기 정보를 찾을 수 없어요'));
            }
            return _buildContent(context, baby);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Baby baby) {
    final weekIndex = baby.currentWeek;
    final weekContent = getWeekContent(weekIndex);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    // 한국어 이름에 따른 조사 처리: 받침 유무에 따라 "아" 또는 "야"
    final lastChar = baby.name.runes.last;
    final hasBatchim = ((lastChar - 0xAC00) % 28) != 0;
    final suffix = hasBatchim ? '아' : '야';
    final greeting = '${baby.name}$suffix, 반가워!';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      child: Column(
        children: [
          const Spacer(flex: 1),
          // -- Lottie 축하 애니메이션 --
          _buildLottieAnimation(isDark),
          const SizedBox(height: AppDimensions.lg),
          // -- 인사 텍스트 --
          Text(
            greeting,
            key: const ValueKey('intro_greeting'),
            style: textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.lg),
          // -- 주차 정보 카드 (2-2-12) --
          _buildWeekInfoCard(context, weekContent),
          const SizedBox(height: AppDimensions.lg),
          // -- CTA 메시지 --
          Text(
            AppStrings.introCtaMessage,
            style: textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.warmGray,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
          // -- "다음" CTA 버튼 --
          PrimaryCtaButton(
            label: AppStrings.introNextButton,
            buttonKey: const ValueKey('intro_next_button'),
            onPressed: () => context.go('/onboarding/notification'),
          ),
          const SizedBox(height: AppDimensions.xl),
        ],
      ),
    );
  }

  Widget _buildLottieAnimation(bool isDark) {
    // Lottie 애니메이션을 시도하고, 실패 시 플레이스홀더 아이콘으로 대체
    return SizedBox(
      width: 150,
      height: 150,
      child: Lottie.asset(
        'assets/lottie/celebration.json',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.paleCream,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration,
              size: 64,
              color: AppColors.warmOrange,
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekInfoCard(BuildContext context, WeekContent content) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      key: const ValueKey('intro_week_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.low,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- 주차 레이블 --
          Text(
            '${content.weekLabel}차',
            key: const ValueKey('intro_week_label'),
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.warmOrange,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          // -- 테마 제목 --
          Text(
            content.theme,
            key: const ValueKey('intro_week_theme'),
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.md),
          // -- 핵심 포인트 목록 (불릿 리스트) --
          ...content.keyPoints.map((point) => Padding(
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
                        point,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
