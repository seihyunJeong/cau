import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/core_providers.dart';
import '../widgets/disclaimer_dialog.dart';
import '../widgets/my_profile_card.dart';
import '../widgets/placeholder_list_tile.dart';
import '../widgets/settings_section_header.dart';

/// 마이 탭 메인 화면.
/// 프로필 카드 + 알림 설정 + 화면 설정 + 데이터 + 정보 + 버전 표시.
/// ListView 기반 스크롤 가능 구조.
class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsServiceProvider);

    return Scaffold(
      key: const ValueKey('my_screen'),
      appBar: AppBar(
        title: Text(
          AppStrings.myTitle,
          style: theme.textTheme.headlineSmall,
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        key: const ValueKey('my_screen_list'),
        children: [
          // ── 아기 프로필 영역 ──
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
              vertical: AppDimensions.sm,
            ),
            child: const MyProfileCard(),
          ),
          // ── + 아기 추가하기 ──
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
            ),
            child: _buildAddBabyTile(theme),
          ),

          // ── 알림 설정 섹션 ──
          SettingsSectionHeader(
            title: AppStrings.notificationSettingsHeader,
            headerKey: const ValueKey('notification_settings_header'),
          ),
          _buildSwitchTile(
            key: const ValueKey('daily_notification_switch'),
            title: AppStrings.dailyActivityNotification,
            subtitle: AppStrings.dailyActivityNotificationSub,
            value: settings.isDailyNotificationOn,
            onChanged: (v) async {
              HapticFeedback.lightImpact();
              await settings.setDailyNotificationOn(v);
              ref.invalidate(appSettingsServiceProvider);
            },
            theme: theme,
          ),
          _buildSwitchTile(
            key: const ValueKey('record_reminder_switch'),
            title: AppStrings.recordReminder,
            value: settings.isRecordReminderOn,
            onChanged: (v) async {
              HapticFeedback.lightImpact();
              await settings.setRecordReminderOn(v);
              ref.invalidate(appSettingsServiceProvider);
            },
            theme: theme,
          ),
          _buildSwitchTile(
            key: const ValueKey('week_transition_switch'),
            title: AppStrings.weekTransitionNotification,
            value: settings.isWeekTransitionOn,
            onChanged: (v) async {
              HapticFeedback.lightImpact();
              await settings.setWeekTransitionOn(v);
              ref.invalidate(appSettingsServiceProvider);
            },
            theme: theme,
          ),
          _buildSwitchTile(
            key: const ValueKey('milestone_switch'),
            title: AppStrings.growthMilestone,
            value: settings.isMilestoneOn,
            onChanged: (v) async {
              HapticFeedback.lightImpact();
              await settings.setMilestoneOn(v);
              ref.invalidate(appSettingsServiceProvider);
            },
            theme: theme,
          ),

          // ── 화면 설정 섹션 ──
          SettingsSectionHeader(
            title: AppStrings.displaySettingsHeader,
            headerKey: const ValueKey('display_settings_header'),
          ),
          _buildSwitchTile(
            key: const ValueKey('dark_mode_switch'),
            title: AppStrings.darkMode,
            value: settings.themeMode == 'dark',
            onChanged: (v) async {
              HapticFeedback.lightImpact();
              await settings.setThemeMode(v ? 'dark' : 'light');
              ref.invalidate(appSettingsServiceProvider);
            },
            theme: theme,
          ),
          _buildSwitchTile(
            key: const ValueKey('grandparent_mode_switch'),
            title: AppStrings.grandparentMode,
            subtitle: AppStrings.grandparentModeSub,
            value: settings.isGrandparentMode,
            onChanged: (v) async {
              HapticFeedback.lightImpact();
              await settings.setGrandparentMode(v);
              ref.invalidate(appSettingsServiceProvider);
            },
            theme: theme,
          ),
          _buildSwitchTile(
            key: const ValueKey('silent_mode_switch'),
            title: AppStrings.silentMode,
            subtitle: AppStrings.silentModeSub,
            value: settings.isSilentMode,
            onChanged: (v) async {
              HapticFeedback.lightImpact();
              await settings.setSilentMode(v);
              ref.invalidate(appSettingsServiceProvider);
            },
            theme: theme,
          ),

          // ── 데이터 섹션 ──
          SettingsSectionHeader(
            title: AppStrings.dataHeader,
            headerKey: const ValueKey('data_header'),
          ),
          PlaceholderListTile(
            title: AppStrings.exportReport,
            tileKey: const ValueKey('export_report_tile'),
          ),
          PlaceholderListTile(
            title: AppStrings.dataBackup,
            tileKey: const ValueKey('data_backup_tile'),
          ),

          // ── 정보 섹션 ──
          SettingsSectionHeader(
            title: AppStrings.infoHeader,
            headerKey: const ValueKey('info_header'),
          ),
          _buildInfoTile(
            key: const ValueKey('app_info_tile'),
            title: AppStrings.appInfo,
            onTap: () => context.push('/my/info'),
            theme: theme,
          ),
          PlaceholderListTile(
            title: AppStrings.termsOfService,
            tileKey: const ValueKey('terms_tile'),
          ),
          PlaceholderListTile(
            title: AppStrings.privacyPolicy,
            tileKey: const ValueKey('privacy_tile'),
          ),
          _buildInfoTile(
            key: const ValueKey('content_source_tile'),
            title: AppStrings.contentSourceInfo,
            onTap: () => DisclaimerDialog.show(context),
            theme: theme,
          ),

          // ── 버전 표시 ──
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.lg,
            ),
            child: Text(
              AppStrings.versionLabel,
              key: const ValueKey('version_text'),
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// "+ 아기 추가하기" PlaceholderTile.
  Widget _buildAddBabyTile(ThemeData theme) {
    return GestureDetector(
      key: const ValueKey('add_baby_tile'),
      onTap: () {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.featureComingSoon,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.cardPaddingCompact),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: AppDimensions.iconSizeMd,
              color: theme.textTheme.bodySmall?.color,
            ),
            const SizedBox(width: AppDimensions.xs),
            Text(
              AppStrings.myAddBaby,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  /// SwitchListTile (2-4-8 스펙).
  Widget _buildSwitchTile({
    required ValueKey<String> key,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    return SwitchListTile(
      key: key,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall,
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.white,
      activeTrackColor: AppColors.warmOrange,
      inactiveThumbColor: AppColors.white,
      inactiveTrackColor: theme.brightness == Brightness.dark
          ? AppColors.darkBorder
          : AppColors.mutedBeige,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
    );
  }

  /// 정보 섹션 ListTile.
  Widget _buildInfoTile({
    required ValueKey<String> key,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return ListTile(
      key: key,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.textTheme.bodySmall?.color,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      minTileHeight: AppDimensions.minTouchTarget,
      onTap: onTap,
    );
  }
}
