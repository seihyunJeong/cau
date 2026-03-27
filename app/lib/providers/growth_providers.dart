import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/growth_record.dart';
import '../core/utils/date_utils.dart';
import 'baby_providers.dart';
import 'core_providers.dart';

/// 최근 성장 기록 Provider.
/// 활성 아기의 가장 최근 GrowthRecord를 반환한다.
final latestGrowthProvider = FutureProvider<GrowthRecord?>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return null;

  final dao = ref.read(growthRecordDaoProvider);
  return dao.getLatestRecord(baby.id!);
});

/// 활성 아기의 전체 성장 기록 (성장 곡선 그래프용, ASC 정렬).
final allGrowthRecordsProvider =
    FutureProvider<List<GrowthRecord>>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return [];

  final dao = ref.read(growthRecordDaoProvider);
  return dao.getAllByBabyId(baby.id!);
});

/// 오늘 성장 기록 (ExpansionTile 상태 판단용).
final todayGrowthRecordProvider = FutureProvider<GrowthRecord?>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return null;

  final dao = ref.read(growthRecordDaoProvider);
  return dao.getByDate(baby.id!, nowKST());
});
