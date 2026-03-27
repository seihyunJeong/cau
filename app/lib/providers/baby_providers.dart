import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/baby.dart';
import 'core_providers.dart';

/// 활성 아기(현재 선택된 아기) Provider.
/// AppSettingsService.activeBabyId를 기반으로 BabyDao에서 조회한다.
final activeBabyProvider = FutureProvider<Baby?>((ref) async {
  final settings = ref.watch(appSettingsServiceProvider);
  final dao = ref.watch(babyDaoProvider);
  final id = settings.activeBabyId;
  if (id == null) return null;
  return dao.getById(id);
});

/// 모든 아기 목록 Provider (다자녀 확장용).
final allBabiesProvider = FutureProvider<List<Baby>>((ref) async {
  final dao = ref.watch(babyDaoProvider);
  return dao.getAll();
});
