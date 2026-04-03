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
import '../../features/my/screens/notification_settings_screen.dart';
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
/// 페이지 전환 애니메이션 적용:
/// - 온보딩: SlideTransition (우측에서 진입)
/// - 탭 내 네비게이션: SlideTransition (우측에서 진입)
/// - 모달/결과 화면: FadeTransition
/// - 타이머 완료->결과: ScaleTransition
final goRouterProvider = Provider.family<GoRouter, AppSettingsService>(
  (ref, settings) {
    final isComplete = settings.isOnboardingComplete;

    return GoRouter(
      initialLocation: isComplete ? '/home' : '/onboarding',
      routes: [
        // -- 온보딩 라우트 --
        GoRoute(
          path: '/onboarding',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const WelcomeScreen(),
          ),
          routes: [
            GoRoute(
              path: 'register',
              pageBuilder: (context, state) => _slideTransitionPage(
                key: state.pageKey,
                child: const BabyRegisterScreen(),
              ),
            ),
            GoRoute(
              path: 'intro',
              pageBuilder: (context, state) => _slideTransitionPage(
                key: state.pageKey,
                child: const WeekIntroScreen(),
              ),
            ),
            GoRoute(
              path: 'notification',
              pageBuilder: (context, state) => _slideTransitionPage(
                key: state.pageKey,
                child: const NotificationPermissionScreen(),
              ),
            ),
          ],
        ),
        // -- 메인 ShellRoute --
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _fadeTransitionPage(
            key: state.pageKey,
            child: const MainShell(),
          ),
        ),
        // -- 기록 하위 화면 (탭 바 위에 push) --
        GoRoute(
          path: '/record/growth-chart',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const GrowthChartScreen(),
          ),
        ),
        GoRoute(
          path: '/record/history',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const RecordHistoryScreen(),
          ),
        ),
        // -- 활동 하위 화면 --
        GoRoute(
          path: '/activity/history',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const _ActivityHistoryPlaceholder(),
          ),
        ),
        GoRoute(
          path: '/activity/:id',
          pageBuilder: (context, state) {
            final activityId = state.pathParameters['id']!;
            return _slideTransitionPage(
              key: state.pageKey,
              child: ActivityDetailScreen(activityId: activityId),
            );
          },
          routes: [
            GoRoute(
              path: 'timer',
              pageBuilder: (context, state) {
                final activityId = state.pathParameters['id']!;
                return _slideTransitionPage(
                  key: state.pageKey,
                  child: ActivityTimerScreen(activityId: activityId),
                );
              },
            ),
          ],
        ),
        // -- 발달 체크 하위 화면 --
        GoRoute(
          path: '/dev-check/checklist',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const ChecklistScreen(),
          ),
          routes: [
            GoRoute(
              path: 'danger-signs',
              pageBuilder: (context, state) => _slideTransitionPage(
                key: state.pageKey,
                child: const DangerSignScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/dev-check/result',
          pageBuilder: (context, state) => _scaleTransitionPage(
            key: state.pageKey,
            child: const ChecklistResultScreen(),
          ),
        ),
        GoRoute(
          path: '/dev-check/trend',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const TrendScreen(),
          ),
        ),
        // -- 마이 하위 화면 --
        GoRoute(
          path: '/my/edit',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const BabyEditScreen(),
          ),
        ),
        GoRoute(
          path: '/my/info',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const AppInfoScreen(),
          ),
        ),
        GoRoute(
          path: '/my/notifications',
          pageBuilder: (context, state) => _slideTransitionPage(
            key: state.pageKey,
            child: const NotificationSettingsScreen(),
          ),
        ),
        // -- 관찰 기록 라우트 --
        GoRoute(
          path: '/observation/:activityRecordId',
          pageBuilder: (context, state) {
            final activityRecordId =
                state.pathParameters['activityRecordId']!;
            return _slideTransitionPage(
              key: state.pageKey,
              child: ObservationFormScreen(
                activityRecordId: activityRecordId,
              ),
            );
          },
          routes: [
            GoRoute(
              path: 'result',
              pageBuilder: (context, state) {
                final activityRecordId =
                    state.pathParameters['activityRecordId']!;
                final level = state.extra as int? ?? 0;
                return _scaleTransitionPage(
                  key: state.pageKey,
                  child: ObservationResultScreen(
                    activityRecordId: activityRecordId,
                    interpretationLevel: level,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  },
);

/// Slide transition from right (standard navigation push).
CustomTransitionPage<void> _slideTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideIn = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );

      return FadeTransition(
        opacity: fadeIn,
        child: SlideTransition(
          position: slideIn,
          child: child,
        ),
      );
    },
  );
}

/// Fade transition for modals and overlays.
CustomTransitionPage<void> _fadeTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

/// Scale transition for result/completion screens (timer -> result, checklist -> result).
CustomTransitionPage<void> _scaleTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );

      final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      );

      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: child,
        ),
      );
    },
  );
}

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
