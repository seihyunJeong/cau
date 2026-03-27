import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/baby.dart';
import '../../../providers/baby_providers.dart';

/// 마이 화면 전용 프로필 카드 (2-2-1 마이 변형).
/// 이름 + 주차 + "태어난 지 N일째" + 우측 끝 "수정 ->" 텍스트 링크 버튼.
class MyProfileCard extends ConsumerWidget {
  const MyProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final babyAsync = ref.watch(activeBabyProvider);

    return Container(
      key: const ValueKey('my_profile_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPaddingCompact),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
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
    );
  }

  Widget _buildContent(BuildContext context, Baby baby, ThemeData theme) {
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
                '${baby.name} (${AppStrings.weekLabelSuffix(baby.weekLabel)})',
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
        // "수정 ->" 텍스트 링크 버튼
        GestureDetector(
          key: const ValueKey('my_edit_button'),
          onTap: () => context.push('/my/edit'),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.minTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.sm,
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
