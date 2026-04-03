import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/baby.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/core_providers.dart';
import '../../../services/notification_scheduler.dart';
import '../../../services/notification_service.dart';

/// 알림 설정 상세 화면.
/// 개발기획서 화면 5-2 기준.
///
/// 4개 알림 유형별 ON/OFF 토글과 TimePicker를 제공한다.
/// - 데일리 활동 알림: ON/OFF + 시간 설정 (기본 09:00)
/// - 기록 리마인더: ON/OFF + 시간 설정 (기본 20:00)
/// - 주차 전환 알림: ON/OFF (시간 고정 09:00)
/// - 성장 마일스톤 알림: ON/OFF (시간 고정 09:00)
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final settings = ref.watch(appSettingsServiceProvider);
    final babyAsync = ref.watch(activeBabyProvider);

    return Scaffold(
      key: const ValueKey('notification_settings_screen'),
      appBar: AppBar(
        title: Text(
          AppStrings.notifSettingsTitle,
          style: textTheme.headlineSmall,
        ),
        centerTitle: false,
        leading: IconButton(
          key: const ValueKey('notification_settings_back'),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        key: const ValueKey('notification_settings_list'),
        children: [
          const SizedBox(height: AppDimensions.sm),
          // ── 데일리 활동 알림 ──
          _buildNotificationSection(
            theme: theme,
            switchKey: 'daily_notification_detail_switch',
            title: AppStrings.notifDailyActivityLabel,
            subtitle: AppStrings.notifDailyActivitySub,
            value: settings.isDailyNotificationOn,
            onChanged: (v) => _onDailyNotificationToggle(v, settings, babyAsync),
            timeKey: 'daily_notification_time_picker',
            timeLabel: AppStrings.notifDailyTimeLabel,
            timeValue: settings.dailyNotificationTime,
            timeEnabled: settings.isDailyNotificationOn,
            onTimeTap: () => _onDailyTimePick(settings),
          ),
          _buildDivider(theme),
          // ── 기록 리마인더 ──
          _buildNotificationSection(
            theme: theme,
            switchKey: 'record_reminder_detail_switch',
            title: AppStrings.notifRecordReminderLabel,
            subtitle: AppStrings.notifRecordReminderSub,
            value: settings.isRecordReminderOn,
            onChanged: (v) => _onRecordReminderToggle(v, settings),
            timeKey: 'record_reminder_time_picker',
            timeLabel: AppStrings.notifDailyTimeLabel,
            timeValue: settings.recordReminderTime,
            timeEnabled: settings.isRecordReminderOn,
            onTimeTap: () => _onRecordReminderTimePick(settings),
          ),
          _buildDivider(theme),
          // ── 주차 전환 알림 ──
          _buildSimpleNotificationTile(
            theme: theme,
            switchKey: 'week_transition_detail_switch',
            title: AppStrings.notifWeekTransitionLabel,
            subtitle: AppStrings.notifWeekTransitionSub,
            value: settings.isWeekTransitionOn,
            onChanged: (v) =>
                _onWeekTransitionToggle(v, settings, babyAsync),
          ),
          _buildDivider(theme),
          // ── 성장 마일스톤 알림 ──
          _buildSimpleNotificationTile(
            theme: theme,
            switchKey: 'milestone_detail_switch',
            title: AppStrings.notifMilestoneLabel,
            subtitle: AppStrings.notifMilestoneSub,
            value: settings.isMilestoneOn,
            onChanged: (v) =>
                _onMilestoneToggle(v, settings, babyAsync),
          ),
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    );
  }

  /// 시간 설정이 있는 알림 섹션 (데일리, 기록 리마인더).
  Widget _buildNotificationSection({
    required ThemeData theme,
    required String switchKey,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required String timeKey,
    required String timeLabel,
    required String timeValue,
    required bool timeEnabled,
    required VoidCallback onTimeTap,
  }) {
    return Column(
      children: [
        SwitchListTile(
          key: ValueKey(switchKey),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall,
          ),
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
        ),
        // 시간 설정 영역
        InkWell(
          key: ValueKey(timeKey),
          onTap: timeEnabled ? onTimeTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
              vertical: AppDimensions.md,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: AppDimensions.minTouchTarget,
                  height: AppDimensions.minTouchTarget,
                  child: Icon(
                    Icons.access_time,
                    size: AppDimensions.iconSizeMd,
                    color: timeEnabled
                        ? theme.textTheme.bodySmall?.color
                        : (theme.brightness == Brightness.dark
                            ? AppColors.darkBorder
                            : AppColors.mutedBeige),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  timeLabel,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: timeEnabled
                        ? null
                        : (theme.brightness == Brightness.dark
                            ? AppColors.darkBorder
                            : AppColors.mutedBeige),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimeForDisplay(timeValue),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: timeEnabled
                        ? AppColors.warmOrange
                        : (theme.brightness == Brightness.dark
                            ? AppColors.darkBorder
                            : AppColors.mutedBeige),
                  ),
                ),
                const SizedBox(width: AppDimensions.xs),
                Icon(
                  Icons.chevron_right,
                  color: timeEnabled
                      ? theme.textTheme.bodySmall?.color
                      : (theme.brightness == Brightness.dark
                          ? AppColors.darkBorder
                          : AppColors.mutedBeige),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 시간 설정이 없는 알림 타일 (주차 전환, 마일스톤).
  Widget _buildSimpleNotificationTile({
    required ThemeData theme,
    required String switchKey,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      key: ValueKey(switchKey),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall,
      ),
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

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      indent: AppDimensions.screenPaddingH,
      endIndent: AppDimensions.screenPaddingH,
      color: theme.dividerColor,
    );
  }

  /// "HH:mm" 형식을 한국어 표시 형식으로 변환한다.
  /// 예: "09:00" -> "오전 9:00", "20:00" -> "오후 8:00"
  String _formatTimeForDisplay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$period $displayHour:$displayMinute';
  }

  /// TimeOfDay를 "HH:mm" 형식 문자열로 변환한다.
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// "HH:mm" 문자열을 TimeOfDay로 변환한다.
  TimeOfDay _parseTimeString(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// 알림 권한을 확인하고, 필요 시 권한을 요청하거나 설정 화면을 안내한다.
  /// 반환값: 권한이 있으면 true, 없으면 false.
  Future<bool> _ensureNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;

    // 권한이 없으면 요청
    final granted = await NotificationService.requestPermission();
    if (granted) return true;

    // 거부된 경우 설정 화면으로 안내
    if (mounted) {
      await openAppSettings();
    }
    return false;
  }

  // ── 토글 핸들러 ──

  Future<void> _onDailyNotificationToggle(
    bool value,
    dynamic settings,
    AsyncValue<Baby?> babyAsync,
  ) async {
    HapticFeedback.lightImpact();

    if (value) {
      final hasPermission = await _ensureNotificationPermission();
      if (!hasPermission) return;

      await settings.setDailyNotificationOn(true);
      await NotificationScheduler.scheduleDailyMission(
        time: settings.dailyNotificationTime,
      );
    } else {
      await settings.setDailyNotificationOn(false);
      await NotificationScheduler.cancel(NotificationService.dailyMissionId);
    }
    ref.invalidate(appSettingsServiceProvider);
  }

  Future<void> _onRecordReminderToggle(
    bool value,
    dynamic settings,
  ) async {
    HapticFeedback.lightImpact();

    if (value) {
      final hasPermission = await _ensureNotificationPermission();
      if (!hasPermission) return;

      await settings.setRecordReminderOn(true);
      await NotificationScheduler.scheduleRecordReminder(
        time: settings.recordReminderTime,
      );
    } else {
      await settings.setRecordReminderOn(false);
      await NotificationScheduler.cancel(
          NotificationService.recordReminderId);
    }
    ref.invalidate(appSettingsServiceProvider);
  }

  Future<void> _onWeekTransitionToggle(
    bool value,
    dynamic settings,
    AsyncValue<Baby?> babyAsync,
  ) async {
    HapticFeedback.lightImpact();

    if (value) {
      final hasPermission = await _ensureNotificationPermission();
      if (!hasPermission) return;

      await settings.setWeekTransitionOn(true);

      final baby = babyAsync.value;
      if (baby != null) {
        await NotificationScheduler.scheduleWeekTransition(
          birthDate: baby.birthDate,
          weekLabel: baby.weekLabel,
        );
      }
    } else {
      await settings.setWeekTransitionOn(false);
      await NotificationScheduler.cancel(
          NotificationService.weekTransitionId);
    }
    ref.invalidate(appSettingsServiceProvider);
  }

  Future<void> _onMilestoneToggle(
    bool value,
    dynamic settings,
    AsyncValue<Baby?> babyAsync,
  ) async {
    HapticFeedback.lightImpact();

    if (value) {
      final hasPermission = await _ensureNotificationPermission();
      if (!hasPermission) return;

      await settings.setMilestoneOn(true);

      final baby = babyAsync.value;
      if (baby != null) {
        await NotificationScheduler.scheduleAllMilestones(
          birthDate: baby.birthDate,
          babyName: baby.name,
        );
      }
    } else {
      await settings.setMilestoneOn(false);
      await NotificationScheduler.cancelAllMilestones();
    }
    ref.invalidate(appSettingsServiceProvider);
  }

  // ── TimePicker 핸들러 ──

  Future<void> _onDailyTimePick(dynamic settings) async {
    final currentTime = _parseTimeString(settings.dailyNotificationTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked == null) return;

    final newTime = _formatTimeOfDay(picked);
    await settings.setDailyNotificationTime(newTime);
    await NotificationScheduler.cancel(NotificationService.dailyMissionId);
    await NotificationScheduler.scheduleDailyMission(time: newTime);
    ref.invalidate(appSettingsServiceProvider);
  }

  Future<void> _onRecordReminderTimePick(dynamic settings) async {
    final currentTime = _parseTimeString(settings.recordReminderTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked == null) return;

    final newTime = _formatTimeOfDay(picked);
    await settings.setRecordReminderTime(newTime);
    await NotificationScheduler.cancel(NotificationService.recordReminderId);
    await NotificationScheduler.scheduleRecordReminder(time: newTime);
    ref.invalidate(appSettingsServiceProvider);
  }
}
