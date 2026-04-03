import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'data/database/database_helper.dart';
import 'providers/core_providers.dart';
import 'services/app_settings_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  // ── 바인딩 초기화 ──
  // 디버그 모드: MarionetteBinding (WidgetsFlutterBinding 대체)
  // 릴리즈 모드: WidgetsFlutterBinding
  if (kDebugMode) {
    _initMarionette();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // ── 한국 전용 설정 (KST 고정) ──
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  await initializeDateFormatting('ko_KR');

  // ── SharedPreferences 초기화 (앱 설정용) ──
  final prefs = await SharedPreferences.getInstance();

  // ── sqflite 데이터베이스 초기화 (싱글톤 -- 최초 접근 시 자동 생성) ──
  await DatabaseHelper.instance.database;

  // ── 로컬 알림 초기화 ──
  await NotificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        databaseHelperProvider.overrideWithValue(DatabaseHelper.instance),
        appSettingsServiceProvider
            .overrideWithValue(AppSettingsService(prefs)),
      ],
      child: const HaruHanGajiApp(),
    ),
  );
}

/// MarionetteBinding 초기화 (디버그 모드 전용).
/// dev_dependencies에서만 사용 가능하므로 별도 함수로 분리.
void _initMarionette() {
  try {
    // marionette_flutter는 dev_dependencies에 있으므로
    // 런타임에서 동적으로 초기화를 시도한다.
    // 패키지가 없는 환경(릴리즈)에서는 catch로 안전하게 무시한다.
    _tryInitMarionette();
  } catch (e) {
    debugPrint('MarionetteBinding 초기화 생략: $e');
  }
}

void _tryInitMarionette() {
  MarionetteBinding.ensureInitialized();
  debugPrint('MarionetteBinding: 초기화 완료');
}
