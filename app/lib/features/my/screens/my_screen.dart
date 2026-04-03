import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/baby.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/core_providers.dart';
import '../../../services/notification_scheduler.dart';
import '../../../services/notification_service.dart';
import '../widgets/disclaimer_dialog.dart';
import '../widgets/my_profile_card.dart';

/// 마이 탭 메인 화면.
/// 프로필 카드 + 알림 설정 + 화면 설정 + 데이터 + 정보 + 버전 표시.
/// 카드 그룹으로 각 섹션을 감싸고, 아이콘과 브랜드 컬러를 활용해 차별화.
class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  /// 알림 권한을 확인하고, 필요 시 권한을 요청하거나 설정 화면을 안내한다.
  Future<bool> _ensureNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;

    final granted = await NotificationService.requestPermission();
    if (granted) return true;

    await openAppSettings();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final settings = ref.watch(appSettingsServiceProvider);
    final babyAsync = ref.watch(activeBabyProvider);

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
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
        ),
        children: [
          const SizedBox(height: AppDimensions.sm),
          // ── 아기 프로필 영역 ──
          const MyProfileCard(),
          const SizedBox(height: AppDimensions.sm),
          // ── + 아기 추가하기 ──
          _buildAddBabyTile(theme, isDark),
          const SizedBox(height: AppDimensions.sectionGap),

          // ── 알림 설정 섹션 ──
          _buildSectionHeader(
            theme: theme,
            title: AppStrings.notificationSettingsHeader,
            icon: Icons.notifications_outlined,
            onTap: () => context.push('/my/notifications'),
          ),
          const SizedBox(height: AppDimensions.sm),
          _buildSettingsCard(
            theme: theme,
            isDark: isDark,
            children: [
              _buildIconSwitchTile(
                key: const ValueKey('daily_notification_switch'),
                icon: Icons.wb_sunny_outlined,
                title: AppStrings.dailyActivityNotification,
                subtitle: AppStrings.dailyActivityNotificationSub,
                value: settings.isDailyNotificationOn,
                onChanged: (v) async {
                  HapticFeedback.lightImpact();
                  if (v) {
                    final hasPermission =
                        await _ensureNotificationPermission();
                    if (!hasPermission) return;
                  }
                  await settings.setDailyNotificationOn(v);
                  if (v) {
                    await NotificationScheduler.scheduleDailyMission(
                      time: settings.dailyNotificationTime,
                    );
                  } else {
                    await NotificationScheduler.cancel(
                        NotificationService.dailyMissionId);
                  }
                  ref.invalidate(appSettingsServiceProvider);
                },
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconSwitchTile(
                key: const ValueKey('record_reminder_switch'),
                icon: Icons.edit_note_outlined,
                title: AppStrings.recordReminder,
                value: settings.isRecordReminderOn,
                onChanged: (v) async {
                  HapticFeedback.lightImpact();
                  if (v) {
                    final hasPermission =
                        await _ensureNotificationPermission();
                    if (!hasPermission) return;
                  }
                  await settings.setRecordReminderOn(v);
                  if (v) {
                    await NotificationScheduler.scheduleRecordReminder(
                      time: settings.recordReminderTime,
                    );
                  } else {
                    await NotificationScheduler.cancel(
                        NotificationService.recordReminderId);
                  }
                  ref.invalidate(appSettingsServiceProvider);
                },
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconSwitchTile(
                key: const ValueKey('week_transition_switch'),
                icon: Icons.auto_awesome_outlined,
                title: AppStrings.weekTransitionNotification,
                value: settings.isWeekTransitionOn,
                onChanged: (v) async {
                  HapticFeedback.lightImpact();
                  if (v) {
                    final hasPermission =
                        await _ensureNotificationPermission();
                    if (!hasPermission) return;
                  }
                  await settings.setWeekTransitionOn(v);
                  if (v) {
                    final baby = babyAsync.value;
                    if (baby != null) {
                      await NotificationScheduler.scheduleWeekTransition(
                        birthDate: baby.birthDate,
                        weekLabel: baby.weekLabel,
                      );
                    }
                  } else {
                    await NotificationScheduler.cancel(
                        NotificationService.weekTransitionId);
                  }
                  ref.invalidate(appSettingsServiceProvider);
                },
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconSwitchTile(
                key: const ValueKey('milestone_switch'),
                icon: Icons.celebration_outlined,
                title: AppStrings.growthMilestone,
                value: settings.isMilestoneOn,
                onChanged: (v) async {
                  HapticFeedback.lightImpact();
                  if (v) {
                    final hasPermission =
                        await _ensureNotificationPermission();
                    if (!hasPermission) return;
                  }
                  await settings.setMilestoneOn(v);
                  if (v) {
                    final baby = babyAsync.value;
                    if (baby != null) {
                      await NotificationScheduler.scheduleAllMilestones(
                        birthDate: baby.birthDate,
                        babyName: baby.name,
                      );
                    }
                  } else {
                    await NotificationScheduler.cancelAllMilestones();
                  }
                  ref.invalidate(appSettingsServiceProvider);
                },
                theme: theme,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sectionGap),

          // ── 화면 설정 섹션 ──
          _buildSectionHeader(
            theme: theme,
            title: AppStrings.displaySettingsHeader,
            icon: Icons.palette_outlined,
          ),
          const SizedBox(height: AppDimensions.sm),
          _buildSettingsCard(
            theme: theme,
            isDark: isDark,
            children: [
              _buildIconSwitchTile(
                key: const ValueKey('dark_mode_switch'),
                icon: Icons.dark_mode_outlined,
                title: AppStrings.darkMode,
                value: settings.themeMode == 'dark',
                onChanged: (v) async {
                  HapticFeedback.lightImpact();
                  await settings.setThemeMode(v ? 'dark' : 'light');
                  ref.invalidate(appSettingsServiceProvider);
                },
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconSwitchTile(
                key: const ValueKey('grandparent_mode_switch'),
                icon: Icons.text_increase_outlined,
                title: AppStrings.grandparentMode,
                subtitle: AppStrings.grandparentModeSub,
                value: settings.isGrandparentMode,
                onChanged: (v) async {
                  HapticFeedback.lightImpact();
                  await settings.setGrandparentMode(v);
                  ref.invalidate(appSettingsServiceProvider);
                },
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconSwitchTile(
                key: const ValueKey('silent_mode_switch'),
                icon: Icons.volume_off_outlined,
                title: AppStrings.silentMode,
                subtitle: AppStrings.silentModeSub,
                value: settings.isSilentMode,
                onChanged: (v) async {
                  HapticFeedback.lightImpact();
                  await settings.setSilentMode(v);
                  ref.invalidate(appSettingsServiceProvider);
                },
                theme: theme,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sectionGap),

          // ── 데이터 섹션 ──
          _buildSectionHeader(
            theme: theme,
            title: AppStrings.dataHeader,
            icon: Icons.folder_outlined,
          ),
          const SizedBox(height: AppDimensions.sm),
          _buildSettingsCard(
            theme: theme,
            isDark: isDark,
            children: [
              _buildIconNavTile(
                key: const ValueKey('export_report_tile'),
                icon: Icons.picture_as_pdf_outlined,
                title: AppStrings.exportReport,
                onTap: () => _showComingSoon(theme),
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconNavTile(
                key: const ValueKey('data_backup_tile'),
                icon: Icons.cloud_upload_outlined,
                title: AppStrings.dataBackup,
                onTap: () => _showComingSoon(theme),
                theme: theme,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sectionGap),

          // ── 정보 섹션 ──
          _buildSectionHeader(
            theme: theme,
            title: AppStrings.infoHeader,
            icon: Icons.info_outline,
          ),
          const SizedBox(height: AppDimensions.sm),
          _buildSettingsCard(
            theme: theme,
            isDark: isDark,
            children: [
              _buildIconNavTile(
                key: const ValueKey('app_info_tile'),
                icon: Icons.smartphone_outlined,
                title: AppStrings.appInfo,
                onTap: () => context.push('/my/info'),
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconNavTile(
                key: const ValueKey('terms_tile'),
                icon: Icons.description_outlined,
                title: AppStrings.termsOfService,
                onTap: () => _showComingSoon(theme),
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconNavTile(
                key: const ValueKey('privacy_tile'),
                icon: Icons.shield_outlined,
                title: AppStrings.privacyPolicy,
                onTap: () => _showComingSoon(theme),
                theme: theme,
                isDark: isDark,
              ),
              _divider(isDark),
              _buildIconNavTile(
                key: const ValueKey('content_source_tile'),
                icon: Icons.menu_book_outlined,
                title: AppStrings.contentSourceInfo,
                onTap: () => DisclaimerDialog.show(context),
                theme: theme,
                isDark: isDark,
              ),
            ],
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

  void _showComingSoon(ThemeData theme) {
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
  }

  /// Section header with warmOrange icon accent.
  Widget _buildSectionHeader({
    required ThemeData theme,
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final content = Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.warmOrange,
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.chevron_right,
            color: theme.textTheme.bodySmall?.color,
          ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }

  /// Rounded card container that groups settings items.
  Widget _buildSettingsCard({
    required ThemeData theme,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  /// Thin divider between items inside a settings card.
  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: AppDimensions.xxl + AppDimensions.sm,
      color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
    );
  }

  /// "+ 아기 추가하기" PlaceholderTile.
  Widget _buildAddBabyTile(ThemeData theme, bool isDark) {
    return GestureDetector(
      key: const ValueKey('add_baby_tile'),
      onTap: () => _showComingSoon(theme),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.cardPaddingCompact),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark
                ? AppColors.warmOrange.withValues(alpha: 0.3)
                : AppColors.warmOrange.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: AppDimensions.iconSizeMd,
              color: AppColors.warmOrange,
            ),
            const SizedBox(width: AppDimensions.xs),
            Text(
              AppStrings.myAddBaby,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.warmOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SwitchListTile with leading icon for visual differentiation.
  Widget _buildIconSwitchTile({
    required ValueKey<String> key,
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
    required bool isDark,
  }) {
    return SwitchListTile(
      key: key,
      secondary: Icon(
        icon,
        size: 22,
        color: isDark ? AppColors.darkTextSecondary : AppColors.warmGray,
      ),
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
      inactiveTrackColor: isDark ? AppColors.darkBorder : AppColors.mutedBeige,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPaddingCompact,
      ),
    );
  }

  /// Navigation ListTile with leading icon.
  Widget _buildIconNavTile({
    required ValueKey<String> key,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isDark,
  }) {
    return ListTile(
      key: key,
      leading: Icon(
        icon,
        size: 22,
        color: isDark ? AppColors.darkTextSecondary : AppColors.warmGray,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.textTheme.bodySmall?.color,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPaddingCompact,
      ),
      minTileHeight: AppDimensions.minTouchTarget,
      onTap: onTap,
    );
  }
}
