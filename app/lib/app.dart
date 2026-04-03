import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/grandparent_theme.dart';
import 'providers/core_providers.dart';
import 'services/notification_service.dart';

/// 앱 루트 위젯.
/// MaterialApp.router + Riverpod ProviderScope 래핑. GoRouter + 테마 적용.
class HaruHanGajiApp extends ConsumerWidget {
  const HaruHanGajiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 설정 서비스에서 테마 모드와 조부모 모드 읽기
    final settings = ref.watch(appSettingsServiceProvider);
    final themeModeStr = settings.themeMode;
    final isGrandparent = settings.isGrandparentMode;

    // 문자열 -> ThemeMode 변환
    final ThemeMode themeMode;
    switch (themeModeStr) {
      case 'light':
        themeMode = ThemeMode.light;
      case 'dark':
        themeMode = ThemeMode.dark;
      default:
        themeMode = ThemeMode.system;
    }

    // 기본 테마 생성
    ThemeData light = lightTheme();
    ThemeData dark = darkTheme();

    // 조부모 모드 적용 (텍스트 +4sp)
    if (isGrandparent) {
      light = grandparentTheme(light);
      dark = grandparentTheme(dark);
    }

    // GoRouter 생성 (isOnboardingComplete 기반 initialLocation)
    final router = ref.watch(goRouterProvider(settings));

    // 알림 탭 시 라우팅을 위해 GoRouter 참조 설정
    NotificationService.setRouter(router);

    return MaterialApp.router(
      title: AppStrings.appName,
      theme: light,
      darkTheme: dark,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
