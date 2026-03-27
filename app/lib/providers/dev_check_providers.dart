import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'checklist_providers.dart';

/// DevCheck 메인 화면 상태 열거형.
/// State A: 이번 주 체크 기록 없음
/// State B: 이번 주 체크 기록 있음
enum DevCheckState { stateA, stateB }

/// DevCheck 메인 화면 상태 Provider.
/// latestChecklistResult 기반으로 State A/B 분기.
final devCheckStateProvider = Provider<DevCheckState>((ref) {
  final resultAsync = ref.watch(latestChecklistResultProvider);
  final record = resultAsync.value;
  if (record == null) return DevCheckState.stateA;
  return DevCheckState.stateB;
});
