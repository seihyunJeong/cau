import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/constants/app_strings.dart';
import '../core/utils/date_utils.dart';
import 'notification_service.dart';

/// 알림 스케줄러.
/// 개발기획서 섹션 7-2 기준.
///
/// 데일리 미션, 기록 리마인더, 주차 전환, 마일스톤 알림을 스케줄링한다.
/// static 메서드로 구성하여 별도 Provider 없이도 호출 가능.
class NotificationScheduler {
  NotificationScheduler._();

  /// 마일스톤 기념일 목록 (일수).
  static const List<int> milestoneDays = [
    7, 14, 21, 28, 30, 60, 100, 200, 365,
  ];

  static FlutterLocalNotificationsPlugin get _plugin =>
      NotificationService.plugin;

  // ── 데일리 미션 알림 ──

  /// 매일 설정 시간에 "오늘의 활동이 준비되었어요!" 알림을 스케줄한다.
  /// [time] 형식: "HH:mm" (예: "09:00").
  static Future<void> scheduleDailyMission({String time = '09:00'}) async {
    try {
      final timeOfDay = _parseTimeString(time);
      final scheduledDate = _nextInstanceOfTime(timeOfDay);

      await _plugin.zonedSchedule(
        id: NotificationService.dailyMissionId,
        title: AppStrings.notifDailyMissionTitle,
        body: AppStrings.notifDailyMissionDefaultBody,
        scheduledDate: scheduledDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            NotificationService.channelDailyMission,
            '오늘의 활동',
            channelDescription: '매일 오늘의 활동 알림',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            playSound: false,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '/activity',
      );
    } catch (e) {
      debugPrint('데일리 미션 알림 스케줄 실패: $e');
    }
  }

  // ── 기록 리마인더 알림 ──

  /// 매일 설정 시간에 "오늘도 수고하셨어요. 간단히 기록해 볼까요?" 알림을 스케줄한다.
  /// [time] 형식: "HH:mm" (예: "20:00").
  static Future<void> scheduleRecordReminder({String time = '20:00'}) async {
    try {
      final timeOfDay = _parseTimeString(time);
      final scheduledDate = _nextInstanceOfTime(timeOfDay);

      await _plugin.zonedSchedule(
        id: NotificationService.recordReminderId,
        title: AppStrings.notifRecordReminderTitle,
        body: AppStrings.notifRecordReminderBody,
        scheduledDate: scheduledDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            NotificationService.channelRecordReminder,
            '기록 리마인더',
            channelDescription: '하루 기록 리마인더 알림',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            playSound: false,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '/home',
      );
    } catch (e) {
      debugPrint('기록 리마인더 알림 스케줄 실패: $e');
    }
  }

  // ── 주차 전환 알림 ──

  /// 다음 주차 전환일 오전 9:00에 알림을 스케줄한다.
  /// [birthDate] 아기 생년월일.
  /// [weekLabel] 전환될 주차 레이블 (예: "2-3주").
  static Future<void> scheduleWeekTransition({
    required DateTime birthDate,
    required String weekLabel,
  }) async {
    try {
      final nextTransitionDate = _calculateNextWeekTransitionDate(birthDate);
      if (nextTransitionDate == null) return;

      final seoul = tz.getLocation('Asia/Seoul');
      final scheduledDate = tz.TZDateTime(
        seoul,
        nextTransitionDate.year,
        nextTransitionDate.month,
        nextTransitionDate.day,
        9, // 오전 9:00 고정
        0,
      );

      // 이미 지난 시간이면 스케줄하지 않는다
      final now = nowKST();
      if (scheduledDate.isBefore(now)) return;

      await _plugin.zonedSchedule(
        id: NotificationService.weekTransitionId,
        title: AppStrings.notifWeekTransitionTitle,
        body: AppStrings.notifWeekTransitionBody(weekLabel),
        scheduledDate: scheduledDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            NotificationService.channelWeekTransition,
            '주차 전환',
            channelDescription: '새로운 주차 전환 알림',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            playSound: false,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: '/home',
      );
    } catch (e) {
      debugPrint('주차 전환 알림 스케줄 실패: $e');
    }
  }

  // ── 마일스톤 알림 ──

  /// 특정 마일스톤 알림을 스케줄한다.
  /// [birthDate] 아기 생년월일.
  /// [targetDays] 기념일 일수 (7, 14, 21, 28, 30, 60, 100, 200, 365).
  /// [babyName] 아기 이름 (알림 메시지에 사용).
  static Future<void> scheduleMilestone({
    required DateTime birthDate,
    required int targetDays,
    required String babyName,
  }) async {
    try {
      final seoul = tz.getLocation('Asia/Seoul');
      final milestoneDate = birthDate.add(Duration(days: targetDays));
      final scheduledDate = tz.TZDateTime(
        seoul,
        milestoneDate.year,
        milestoneDate.month,
        milestoneDate.day,
        9, // 오전 9:00 고정
        0,
      );

      // 이미 지난 날짜는 스케줄하지 않는다
      final now = nowKST();
      if (scheduledDate.isBefore(now)) return;

      final notificationId = NotificationService.milestoneId + targetDays;

      await _plugin.zonedSchedule(
        id: notificationId,
        title: AppStrings.notifMilestoneTitle,
        body: AppStrings.notifMilestoneBody(babyName, targetDays),
        scheduledDate: scheduledDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            NotificationService.channelMilestone,
            '성장 마일스톤',
            channelDescription: '성장 마일스톤 기념일 알림',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            playSound: false,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: '/home',
      );
    } catch (e) {
      debugPrint('마일스톤 알림 스케줄 실패 ($targetDays일): $e');
    }
  }

  /// 9개 마일스톤 알림을 일괄 등록한다.
  /// [birthDate] 아기 생년월일.
  /// [babyName] 아기 이름.
  static Future<void> scheduleAllMilestones({
    required DateTime birthDate,
    required String babyName,
  }) async {
    for (final days in milestoneDays) {
      await scheduleMilestone(
        birthDate: birthDate,
        targetDays: days,
        babyName: babyName,
      );
    }
  }

  /// 마일스톤 관련 모든 알림을 취소한다.
  static Future<void> cancelAllMilestones() async {
    for (final days in milestoneDays) {
      await cancel(NotificationService.milestoneId + days);
    }
  }

  // ── 취소 ──

  /// 모든 알림을 취소한다.
  static Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('알림 전체 취소 실패: $e');
    }
  }

  /// 특정 알림을 취소한다.
  static Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (e) {
      debugPrint('알림 취소 실패 (id=$id): $e');
    }
  }

  // ── 유틸 ──

  /// "HH:mm" 형식의 문자열을 TimeOfDay로 변환한다.
  static TimeOfDay _parseTimeString(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// 주어진 시간의 다음 인스턴스를 TZDateTime으로 반환한다.
  /// 현재 시간 이전이면 다음 날로 계산한다.
  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final seoul = tz.getLocation('Asia/Seoul');
    final now = tz.TZDateTime.now(seoul);
    var scheduled = tz.TZDateTime(
      seoul,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// 다음 주차 전환 날짜를 계산한다.
  /// WeekCalculator의 주차 구간 경계를 기반으로 계산한다.
  static DateTime? _calculateNextWeekTransitionDate(DateTime birthDate) {
    final now = nowKST();
    final daysSinceBirth = now.difference(birthDate).inDays;

    // 주차 전환 경계일 목록 (생후 일수 기준)
    // 0-1주(0~13일) -> 2-3주(14일) -> 4-5주(28일) -> 6-7주(42일) -> 2개월(56일)
    final boundaries = <int>[14, 28, 42, 56];

    // 2개월 이후: 4주(28일) 단위로 추가
    for (int months = 3; months <= 60; months++) {
      boundaries.add(months * 28);
    }

    for (final boundary in boundaries) {
      if (boundary > daysSinceBirth) {
        return birthDate.add(Duration(days: boundary));
      }
    }

    return null; // 60개월 이후에는 전환 알림 없음
  }
}
