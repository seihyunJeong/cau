import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../features/activity/screens/activity_detail_screen.dart';
import '../../features/activity/screens/activity_timer_screen.dart';
import '../../features/activity/screens/observation_form_screen.dart';
import '../../features/activity/screens/observation_result_screen.dart';
import '../../features/dev_check/screens/checklist_result_screen.dart';
import '../../features/dev_check/screens/checklist_screen.dart';
import '../../features/dev_check/screens/danger_sign_screen.dart';
import '../../features/dev_check/screens/trend_screen.dart';
import '../../features/main_shell/main_shell.dart';
import '../../features/my/screens/app_info_screen.dart';
import '../../features/my/screens/baby_edit_screen.dart';
import '../../features/onboarding/screens/baby_register_screen.dart';
import '../../features/onboarding/screens/notification_permission_screen.dart';
import '../../features/onboarding/screens/week_intro_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/record/screens/growth_chart_screen.dart';
import '../../features/record/screens/record_history_screen.dart';
import '../../services/app_settings_service.dart';

/// GoRouter Provider.
/// 개발기획서 4-4 기준.
///
/// - `isOnboardingComplete == false` -> initialLocation: `/onboarding`
/// - `isOnboardingComplete == true`  -> initialLocation: `/home`
///
/// 온보딩 라우트 4개 + 메인 ShellRoute 정의.
final goRouterProvider = Provider.family<GoRouter, AppSettingsService>(
  (ref, settings) {
    final isComplete = settings.isOnboardingComplete;

    return GoRouter(
      initialLocation: isComplete ? '/home' : '/onboarding',
      routes: [
        // ── 온보딩 라우트 ──
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const WelcomeScreen(),
          routes: [
            GoRoute(
              path: 'register',
              builder: (context, state) => const BabyRegisterScreen(),
            ),
            GoRoute(
              path: 'intro',
              builder: (context, state) => const WeekIntroScreen(),
            ),
            GoRoute(
              path: 'notification',
              builder: (context, state) =>
                  const NotificationPermissionScreen(),
            ),
          ],
        ),
        // ── 메인 ShellRoute ──
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainShell(),
        ),
        // ── 기록 하위 화면 (탭 바 위에 push) ──
        GoRoute(
          path: '/record/growth-chart',
          builder: (context, state) => const GrowthChartScreen(),
        ),
        GoRoute(
          path: '/record/history',
          builder: (context, state) => const RecordHistoryScreen(),
        ),
        // ── 활동 하위 화면 ──
        GoRoute(
          path: '/activity/history',
          builder: (context, state) => const _ActivityHistoryPlaceholder(),
        ),
        GoRoute(
          path: '/activity/:id',
          builder: (context, state) {
            final activityId = state.pathParameters['id']!;
            return ActivityDetailScreen(activityId: activityId);
          },
          routes: [
            GoRoute(
              path: 'timer',
              builder: (context, state) {
                final activityId = state.pathParameters['id']!;
                return ActivityTimerScreen(activityId: activityId);
              },
            ),
          ],
        ),
        // ── 발달 체크 하위 화면 ──
        GoRoute(
          path: '/dev-check/checklist',
          builder: (context, state) => const ChecklistScreen(),
          routes: [
            GoRoute(
              path: 'danger-signs',
              builder: (context, state) => const DangerSignScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/dev-check/result',
          builder: (context, state) => const ChecklistResultScreen(),
        ),
        GoRoute(
          path: '/dev-check/trend',
          builder: (context, state) => const TrendScreen(),
        ),
        // ── 마이 하위 화면 ──
        GoRoute(
          path: '/my/edit',
          builder: (context, state) => const BabyEditScreen(),
        ),
        GoRoute(
          path: '/my/info',
          builder: (context, state) => const AppInfoScreen(),
        ),
        // ── 관찰 기록 라우트 ──
        GoRoute(
          path: '/observation/:activityRecordId',
          builder: (context, state) {
            final activityRecordId =
                state.pathParameters['activityRecordId']!;
            return ObservationFormScreen(
              activityRecordId: activityRecordId,
            );
          },
          routes: [
            GoRoute(
              path: 'result',
              builder: (context, state) {
                final activityRecordId =
                    state.pathParameters['activityRecordId']!;
                final level = state.extra as int? ?? 0;
                return ObservationResultScreen(
                  activityRecordId: activityRecordId,
                  interpretationLevel: level,
                );
              },
            ),
          ],
        ),
      ],
    );
  },
);

/// 활동 히스토리 플레이스홀더 화면.
/// 실제 구현은 이후 스프린트에서 진행한다.
class _ActivityHistoryPlaceholder extends StatelessWidget {
  const _ActivityHistoryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.activityHistoryTitle),
      ),
      body: Center(
        child: Text(
          AppStrings.activityHistoryPlaceholder,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
