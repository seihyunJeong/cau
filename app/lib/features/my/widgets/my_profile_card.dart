import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/baby.dart';
import '../../../providers/baby_providers.dart';

/// 마이 화면 전용 프로필 카드 (2-2-1 마이 변형).
/// 강화된 디자인: 더 큰 아바타, warmOrange 악센트 바, 수정 버튼.
class MyProfileCard extends ConsumerWidget {
  const MyProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final babyAsync = ref.watch(activeBabyProvider);

    return Container(
      key: const ValueKey('my_profile_card'),
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top accent bar with warmOrange gradient
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.warmOrange,
                  AppColors.warmOrange.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.cardPadding),
            child: babyAsync.when(
              data: (baby) {
                if (baby == null) {
                  return _buildEmpty(context, theme);
                }
                return _buildContent(context, baby, theme);
              },
              loading: () => const SizedBox(
                height: AppDimensions.minTouchTarget,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => _buildEmpty(context, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Baby baby, ThemeData theme) {
    return Row(
      children: [
        // Larger avatar (28dp radius) with warmOrange ring
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.warmOrange.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor:
                theme.colorScheme.primary.withValues(alpha: 0.1),
            backgroundImage: baby.profileImagePath != null
                ? FileImage(File(baby.profileImagePath!))
                : null,
            child: baby.profileImagePath == null
                ? Icon(
                    Icons.child_care,
                    size: 28,
                    color: theme.colorScheme.primary,
                  )
                : null,
          ),
        ),
        const SizedBox(width: AppDimensions.base),
        // Name + week + days info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                baby.name,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppDimensions.xxs),
              Text(
                '${AppStrings.weekLabelSuffix(baby.weekLabel)} | ${_daysSinceBirthLabel(baby.daysSinceBirth)}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        // Edit button with warmOrange accent
        GestureDetector(
          key: const ValueKey('my_edit_button'),
          onTap: () => context.push('/my/edit'),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.minTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.warmOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Text(
              AppStrings.myEditButton,
              style: theme.textTheme.labelMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.warmOrange.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor:
                theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(
              Icons.child_care,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.base),
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
