import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_strings.dart';
import '../data/models/activity.dart';
import '../data/models/activity_record.dart';
import '../data/models/baby.dart';
import '../data/models/timer_state.dart';
import '../data/seed/activity_seed.dart';
import '../core/utils/date_utils.dart';
import 'baby_providers.dart';
import 'core_providers.dart';

/// 현재 주차 활동 목록 Provider.
/// 활성 아기의 weekIndex에 해당하는 활동 시드 데이터를 반환한다.
final currentActivitiesProvider = Provider<List<Activity>>((ref) {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return [];

  final weekIndex = baby.currentWeek;
  return getActivitiesForWeek(weekIndex);
});

/// 오늘 추천 활동 1개 Provider.
/// 현재 주차 활동 목록에서 날짜 기반으로 1개를 선택한다.
/// 같은 날에는 항상 같은 활동이 추천된다.
final todayMissionProvider = Provider<Activity?>((ref) {
  final activities = ref.watch(currentActivitiesProvider);
  if (activities.isEmpty) return null;

  // 오늘 날짜 기반으로 고정된 인덱스를 선택한다.
  final now = nowKST();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  final index = dayOfYear % activities.length;
  return activities[index];
});

/// 활동 유형 필터 상태 Notifier.
class ActivityFilterNotifier extends Notifier<String> {
  @override
  String build() => AppStrings.activityFilterAll;

  void setFilter(String filter) {
    state = filter;
  }
}

/// 활동 유형 필터 Provider.
final activityFilterProvider =
    NotifierProvider<ActivityFilterNotifier, String>(
  ActivityFilterNotifier.new,
);

/// 필터 적용된 활동 목록 Provider.
final filteredActivitiesProvider = Provider<List<Activity>>((ref) {
  final activities = ref.watch(currentActivitiesProvider);
  final filter = ref.watch(activityFilterProvider);

  if (filter == AppStrings.activityFilterAll) return activities;
  return activities.where((a) => a.type == filter).toList();
});

/// 오늘 완료한 활동 ID 목록 Provider (FutureProvider).
final todayCompletedActivityIdsProvider =
    FutureProvider<List<String>>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null || baby.id == null) return [];

  final dao = ref.watch(activityRecordDaoProvider);
  return dao.getTodayCompletedActivityIds(baby.id!);
});

/// 활동 타이머 Notifier.
class ActivityTimerNotifier extends Notifier<TimerState> {
  Timer? _timer;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    // 초기값은 0초. 실제 사용 시 initTimer()로 초기화한다.
    return TimerState.initial(totalSeconds: 0);
  }

  /// totalSeconds를 설정하고 타이머를 초기화한다.
  void initTimer(int totalSeconds) {
    _timer?.cancel();
    _timer = null;
    state = TimerState.initial(totalSeconds: totalSeconds);
  }

  void start() {
    if (state.isCompleted || state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 1) {
        state = state.copyWith(
          remainingSeconds: 0,
          isRunning: false,
          isCompleted: true,
        );
        _timer?.cancel();
        _timer = null;
      } else {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      }
    });
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    state = TimerState.initial(totalSeconds: state.totalSeconds);
  }

  void completeWithoutTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(
      isRunning: false,
      isCompleted: true,
    );
  }
}

/// 활동 타이머 Provider.
final activityTimerProvider =
    NotifierProvider<ActivityTimerNotifier, TimerState>(
  ActivityTimerNotifier.new,
);

/// 활동 완료 기록을 저장하고 completedActivityIds를 갱신한다.
/// 삽입된 activity_record의 ID를 반환한다.
Future<int> saveActivityRecord(
  WidgetRef ref, {
  required int babyId,
  required String activityId,
  required int weekNumber,
  required bool timerUsed,
  int? timerDurationSec,
}) async {
  final dao = ref.read(activityRecordDaoProvider);
  final record = ActivityRecord(
    babyId: babyId,
    activityId: activityId,
    weekNumber: weekNumber,
    completedAt: nowKST(),
    timerUsed: timerUsed,
    timerDurationSec: timerDurationSec,
  );
  final id = await dao.insert(record);
  // 완료 목록을 갱신한다.
  ref.invalidate(todayCompletedActivityIdsProvider);
  return id;
}
