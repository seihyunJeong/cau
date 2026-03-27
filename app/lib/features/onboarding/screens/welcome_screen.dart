import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_cta_button.dart';
import 'package:go_router/go_router.dart';

/// 온보딩 화면 A: 웰컴 화면.
/// 개발기획서 5-1 화면 A 기준.
/// 앱 브랜딩, 태그라인, "시작하기" CTA 버튼을 표시한다.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      key: const ValueKey('welcome_screen'),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // -- 일러스트 (플레이스홀더) --
              _buildIllustration(context),
              const SizedBox(height: AppDimensions.xl),
              // -- 앱 이름 --
              Text(
                AppStrings.appName,
                key: const ValueKey('welcome_title'),
                style: textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.lg),
              // -- 태그라인 3줄 --
              _buildTagline(context),
              const Spacer(flex: 3),
              // -- "시작하기" CTA 버튼 --
              PrimaryCtaButton(
                label: AppStrings.startButton,
                buttonKey: const ValueKey('welcome_start_button'),
                onPressed: () => context.go('/onboarding/register'),
              ),
              const SizedBox(height: AppDimensions.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 플레이스홀더 아이콘 (실제 일러스트가 없을 때)
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.paleCream,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.child_care,
        size: 80,
        color: AppColors.warmOrange,
      ),
    );
  }

  Widget _buildTagline(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final taglineStyle = textTheme.bodyLarge?.copyWith(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkTextSecondary
          : AppColors.warmGray,
    );

    return Column(
      key: const ValueKey('welcome_tagline'),
      children: [
        Text(
          AppStrings.welcomeTagline1,
          style: taglineStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          AppStrings.welcomeTagline2,
          style: taglineStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          AppStrings.welcomeTagline3,
          style: taglineStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
