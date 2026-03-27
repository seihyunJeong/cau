import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/daos/daily_record_dao.dart';
import '../data/models/daily_record.dart';
import '../core/utils/date_utils.dart';
import 'baby_providers.dart';
import 'core_providers.dart';

/// 오늘의 DailyRecord를 관리하는 AsyncNotifier.
/// activeBabyProvider를 watch하여 활성 아기 변경 시 자동 갱신.
class TodayRecordNotifier extends AsyncNotifier<DailyRecord?> {
  @override
  Future<DailyRecord?> build() async {
    final babyAsync = ref.watch(activeBabyProvider);
    final baby = babyAsync.value;
    if (baby == null) return null;

    final dao = ref.read(dailyRecordDaoProvider);
    return _getOrCreateTodayRecord(baby.id!, dao);
  }

  /// 오늘 레코드가 없으면 새로 insert하고 반환한다.
  Future<DailyRecord> _getOrCreateTodayRecord(
    int babyId,
    DailyRecordDao dao,
  ) async {
    final existing = await dao.getTodayRecord(babyId);
    if (existing != null) return existing;

    final newRecord = DailyRecord.today(babyId);
    final id = await dao.insert(newRecord);
    return newRecord.copyWith(id: id);
  }

  /// 수유 카운트를 1 증가시킨다.
  Future<void> incrementFeeding() async {
    final current = state.value;
    if (current == null) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = current.copyWith(
      feedingCount: current.feedingCount + 1,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidateSelf();
  }

  /// 배변 카운트를 1 증가시킨다.
  Future<void> incrementDiaper() async {
    final current = state.value;
    if (current == null) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = current.copyWith(
      diaperCount: current.diaperCount + 1,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidateSelf();
  }

  /// 수유 카운트를 1 감소시킨다 (최소 0).
  Future<void> decrementFeeding() async {
    final current = state.value;
    if (current == null || current.feedingCount <= 0) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = current.copyWith(
      feedingCount: current.feedingCount - 1,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidateSelf();
  }

  /// 배변 카운트를 1 감소시킨다 (최소 0).
  Future<void> decrementDiaper() async {
    final current = state.value;
    if (current == null || current.diaperCount <= 0) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = current.copyWith(
      diaperCount: current.diaperCount - 1,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidateSelf();
  }

  /// 수면 시간을 업데이트한다.
  Future<void> updateSleep(double hours) async {
    final current = state.value;
    if (current == null) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = current.copyWith(
      sleepHours: hours,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidateSelf();
  }

  /// 메모를 업데이트한다.
  Future<void> updateMemo(String memo) async {
    final current = state.value;
    if (current == null) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = current.copyWith(
      memo: memo,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidateSelf();
  }
}

/// todayRecordProvider: 오늘의 DailyRecord.
final todayRecordProvider =
    AsyncNotifierProvider<TodayRecordNotifier, DailyRecord?>(
  TodayRecordNotifier.new,
);

/// 날짜별 DailyRecord를 조회/생성하는 FutureProvider (family).
/// 해당 날짜의 record가 없으면 자동 생성한다.
final dateRecordProvider =
    FutureProvider.family<DailyRecord?, DateTime>((ref, date) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return null;

  final dao = ref.read(dailyRecordDaoProvider);
  final existing = await dao.getByDate(baby.id!, date);
  if (existing != null) return existing;

  // Create new record for this date
  final now = nowKST();
  final newRecord = DailyRecord(
    babyId: baby.id!,
    date: DateTime(date.year, date.month, date.day),
    createdAt: now,
  );
  final id = await dao.insert(newRecord);
  return newRecord.copyWith(id: id);
});

/// 날짜별 DailyRecord를 수정하는 유틸리티 클래스.
/// FutureProvider.family는 notifier가 없으므로, 외부에서 DB를 직접 변경 후
/// provider를 invalidate하는 패턴을 사용한다.
class DateRecordActions {
  final WidgetRef ref;
  final DateTime date;

  const DateRecordActions(this.ref, this.date);

  Future<void> incrementFeeding() async {
    final record = ref.read(dateRecordProvider(date)).value;
    if (record == null) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = record.copyWith(
      feedingCount: record.feedingCount + 1,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidate(dateRecordProvider(date));
    _invalidateTodayIfNeeded();
  }

  Future<void> decrementFeeding() async {
    final record = ref.read(dateRecordProvider(date)).value;
    if (record == null || record.feedingCount <= 0) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = record.copyWith(
      feedingCount: record.feedingCount - 1,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidate(dateRecordProvider(date));
    _invalidateTodayIfNeeded();
  }

  Future<void> incrementDiaper() async {
    final record = ref.read(dateRecordProvider(date)).value;
    if (record == null) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = record.copyWith(
      diaperCount: record.diaperCount + 1,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidate(dateRecordProvider(date));
    _invalidateTodayIfNeeded();
  }

  Future<void> decrementDiaper() async {
    final record = ref.read(dateRecordProvider(date)).value;
    if (record == null || record.diaperCount <= 0) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = record.copyWith(
      diaperCount: record.diaperCount - 1,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidate(dateRecordProvider(date));
    _invalidateTodayIfNeeded();
  }

  Future<void> updateSleep(double hours) async {
    final record = ref.read(dateRecordProvider(date)).value;
    if (record == null) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = record.copyWith(
      sleepHours: hours,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidate(dateRecordProvider(date));
    _invalidateTodayIfNeeded();
  }

  Future<void> updateMemo(String memo) async {
    final record = ref.read(dateRecordProvider(date)).value;
    if (record == null) return;

    final dao = ref.read(dailyRecordDaoProvider);
    final updated = record.copyWith(
      memo: memo,
      updatedAt: nowKST(),
    );
    await dao.update(updated);
    ref.invalidate(dateRecordProvider(date));
    _invalidateTodayIfNeeded();
  }

  void _invalidateTodayIfNeeded() {
    final now = nowKST();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      ref.invalidate(todayRecordProvider);
    }
  }
}
