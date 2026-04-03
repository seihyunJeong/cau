import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

/// 알림 서비스 코어.
/// 개발기획서 섹션 7-1 기준.
///
/// flutter_local_notifications 플러그인 초기화, 권한 요청,
/// Android 알림 채널 설정, 알림 탭 시 GoRouter 이동 처리.
/// static 메서드로 구성하여 별도 Provider 없이도 호출 가능.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 외부에서 플러그인 인스턴스에 접근할 때 사용한다.
  static FlutterLocalNotificationsPlugin get plugin => _plugin;

  // ── 알림 ID 상수 ──
  static const int dailyMissionId = 1;
  static const int recordReminderId = 2;
  static const int weekTransitionId = 3;
  static const int milestoneId = 4;
  static const int dangerSignTrackingId = 5;

  // ── Android 채널 ID ──
  static const String channelDailyMission = 'daily_mission';
  static const String channelRecordReminder = 'record_reminder';
  static const String channelWeekTransition = 'week_transition';
  static const String channelMilestone = 'milestone';

  /// GoRouter 인스턴스 참조. 알림 탭 시 화면 이동에 사용.
  static GoRouter? _router;

  /// GoRouter를 설정한다. app.dart에서 라우터 생성 후 호출해야 한다.
  static void setRouter(GoRouter router) {
    _router = router;
  }

  /// 알림 플러그인을 초기화한다.
  /// main.dart에서 runApp() 이전에 호출한다.
  static Future<void> initialize() async {
    try {
      // Android 초기화 설정
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS 초기화 설정 (무음 모드 기본: sound=false)
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Android 알림 채널 생성
      if (Platform.isAndroid) {
        await _createAndroidChannels();
      }
    } catch (e) {
      debugPrint('NotificationService 초기화 실패: $e');
    }
  }

  /// Android 알림 채널 4개를 생성한다.
  static Future<void> _createAndroidChannels() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    const channels = [
      AndroidNotificationChannel(
        channelDailyMission,
        '오늘의 활동',
        description: '매일 오늘의 활동 알림',
        importance: Importance.defaultImportance,
        playSound: false,
      ),
      AndroidNotificationChannel(
        channelRecordReminder,
        '기록 리마인더',
        description: '하루 기록 리마인더 알림',
        importance: Importance.defaultImportance,
        playSound: false,
      ),
      AndroidNotificationChannel(
        channelWeekTransition,
        '주차 전환',
        description: '새로운 주차 전환 알림',
        importance: Importance.defaultImportance,
        playSound: false,
      ),
      AndroidNotificationChannel(
        channelMilestone,
        '성장 마일스톤',
        description: '성장 마일스톤 기념일 알림',
        importance: Importance.defaultImportance,
        playSound: false,
      ),
    ];

    for (final channel in channels) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  /// OS 알림 권한을 요청한다.
  /// 반환값: 권한 허용 여부.
  static Future<bool> requestPermission() async {
    try {
      if (Platform.isAndroid) {
        // Android 13+ (API 33) POST_NOTIFICATIONS 권한 요청
        final status = await Permission.notification.request();

        // Android 12+ (API 31) SCHEDULE_EXACT_ALARM 권한 요청
        await Permission.scheduleExactAlarm.request();

        return status.isGranted;
      } else if (Platform.isIOS) {
        // iOS 알림 권한 요청
        final iosPlugin =
            _plugin.resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        if (iosPlugin != null) {
          final granted = await iosPlugin.requestPermissions(
            alert: true,
            badge: true,
            sound: false,
          );
          return granted ?? false;
        }
        return false;
      }
      return false;
    } catch (e) {
      debugPrint('알림 권한 요청 실패: $e');
      return false;
    }
  }

  /// 알림 탭 시 호출되는 콜백.
  /// payload에 포함된 라우트 경로로 GoRouter 이동을 수행한다.
  static void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty && _router != null) {
      try {
        _router!.go(payload);
      } catch (e) {
        debugPrint('알림 탭 라우팅 실패: $e');
      }
    }
  }
}
