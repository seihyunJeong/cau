import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/date_utils.dart';
import '../data/models/baby.dart';
import '../data/models/danger_sign_item.dart';
import '../data/models/danger_sign_record.dart';
import '../data/seed/danger_signs_seed.dart';
import 'baby_providers.dart';
import 'core_providers.dart';

/// 현재 주차 위험 신호 항목 리스트 Provider.
final currentDangerSignItemsProvider = Provider<List<DangerSignItem>>((ref) {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return getDangerSignItems(0);
  return getDangerSignItems(baby.currentWeek);
});

/// 위험 신호 진행 중 상태 Notifier.
class DangerSignInProgressNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  void toggleSign(String signId, bool value) {
    final updated = Map<String, bool>.from(state);
    updated[signId] = value;
    state = updated;
  }

  void reset() {
    state = {};
  }
}

final dangerSignInProgressProvider =
    NotifierProvider<DangerSignInProgressNotifier, Map<String, bool>>(
  DangerSignInProgressNotifier.new,
);

/// 위험 신호 메모 상태.
class DangerSignMemoNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setMemo(String memo) {
    state = memo;
  }

  void reset() {
    state = '';
  }
}

final dangerSignMemoProvider =
    NotifierProvider<DangerSignMemoNotifier, String>(
  DangerSignMemoNotifier.new,
);

/// 최근 위험 신호 기록 Provider.
final latestDangerSignProvider =
    FutureProvider<DangerSignRecord?>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null || baby.id == null) return null;

  final dao = ref.watch(dangerSignRecordDaoProvider);
  return dao.getLatest(baby.id!);
});

/// 위험 신호 기록을 저장한다.
Future<DangerSignRecord> saveDangerSignRecord(
  WidgetRef ref, {
  required int babyId,
  required int weekNumber,
}) async {
  final signs = ref.read(dangerSignInProgressProvider);
  final memo = ref.read(dangerSignMemoProvider);
  final dao = ref.read(dangerSignRecordDaoProvider);

  final hasAnySign = signs.values.any((v) => v == true);
  final now = nowKST();

  final record = DangerSignRecord(
    babyId: babyId,
    weekNumber: weekNumber,
    date: now,
    signsJson: jsonEncode(signs),
    memo: memo.isNotEmpty ? memo : null,
    hasAnySign: hasAnySign,
    createdAt: now,
  );

  final id = await dao.insert(record);

  // 상태 초기화
  ref.read(dangerSignInProgressProvider.notifier).reset();
  ref.read(dangerSignMemoProvider.notifier).reset();

  // Provider 갱신
  ref.invalidate(latestDangerSignProvider);

  return DangerSignRecord(
    id: id,
    babyId: record.babyId,
    weekNumber: record.weekNumber,
    date: record.date,
    signsJson: record.signsJson,
    memo: record.memo,
    hasAnySign: record.hasAnySign,
    createdAt: record.createdAt,
  );
}
