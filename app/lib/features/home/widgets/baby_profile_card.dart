import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/baby.dart';
import '../../../providers/baby_providers.dart';

/// 아기 프로필 카드 (컴팩트) (2-2-1).
/// 디자인컴포넌트 2-2-1 기준.
/// - 좌측: CircleAvatar 40dp (프로필 이미지 또는 기본 아기 아이콘)
/// - 우측: 이름 + 주차 (headlineSmall / H3), "태어난 지 N일째" (bodySmall / Caption)
/// - 카드 배경: 미묘한 그라데이션 배경 (cream -> paleCream)
/// - 모서리 12dp, 패딩 12dp (compact)
class BabyProfileCard extends ConsumerWidget {
  const BabyProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final babyAsync = ref.watch(activeBabyProvider);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: const ValueKey('baby_profile_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPaddingCompact),
      decoration: BoxDecoration(
        // Subtle gradient background for visual warmth
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkCard,
                  AppColors.darkCard.withValues(alpha: 0.85),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cream,
                  AppColors.paleCream,
                ],
              ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : Border.all(
                color: AppColors.warmOrange.withValues(alpha: 0.08),
                width: 1,
              ),
      ),
      child: babyAsync.when(
        data: (baby) {
          if (baby == null) {
            return _buildEmpty(theme);
          }
          return _buildContent(context, baby);
        },
        loading: () => const SizedBox(
          height: 48,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => _buildEmpty(theme),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Baby baby) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // 프로필 이미지
        CircleAvatar(
          radius: 20,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          backgroundImage: baby.profileImagePath != null
              ? FileImage(File(baby.profileImagePath!))
              : null,
          child: baby.profileImagePath == null
              ? Icon(
                  Icons.child_care,
                  size: 24,
                  color: theme.colorScheme.primary,
                )
              : null,
        ),
        const SizedBox(width: AppDimensions.md),
        // 이름 + 주차 + 태어난 지 N일째
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${baby.name} (${baby.weekLabel}차)',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.xxs),
              Text(
                _daysSinceBirthLabel(baby.daysSinceBirth),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            Icons.child_care,
            size: 24,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Text(
            AppStrings.emptyBabyProfile,
            style: theme.textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }

  static String _daysSinceBirthLabel(int days) {
    if (days <= 0) return AppStrings.bornToday;
    return AppStrings.daysSinceBirth(days);
  }
}
