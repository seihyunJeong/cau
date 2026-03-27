import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/daily_record.dart';
import '../core/utils/date_utils.dart';
import 'baby_providers.dart';
import 'core_providers.dart';

/// 기록 화면에서 현재 선택된 날짜를 관리하는 Notifier.
/// 초기값은 KST 기준 오늘 날짜.
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = nowKST();
    return DateTime(now.year, now.month, now.day);
  }

  void setDate(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }

  void goToPreviousDay() {
    state = state.subtract(const Duration(days: 1));
  }

  void goToNextDay() {
    final now = nowKST();
    final today = DateTime(now.year, now.month, now.day);
    final nextDay = state.add(const Duration(days: 1));
    if (!nextDay.isAfter(today)) {
      state = nextDay;
    }
  }
}

/// 선택된 날짜 Provider.
final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

/// 선택된 날짜의 DailyRecord를 조회한다.
final selectedDateRecordProvider = FutureProvider<DailyRecord?>((ref) async {
  final date = ref.watch(selectedDateProvider);
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return null;

  final dao = ref.read(dailyRecordDaoProvider);
  return dao.getByDate(baby.id!, date);
});

/// 히스토리 목록 (전체 기록 최신순, 페이징 지원).
final recordHistoryProvider =
    FutureProvider.family<List<DailyRecord>, int>((ref, offset) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return [];

  final dao = ref.read(dailyRecordDaoProvider);
  return dao.getAllByBabyId(baby.id!, limit: 20, offset: offset);
});
