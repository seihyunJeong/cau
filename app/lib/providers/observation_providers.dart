import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/date_utils.dart';
import '../core/utils/observation_interpreter.dart';
import '../data/models/observation_record.dart';
import 'baby_providers.dart';
import 'core_providers.dart';

/// 관찰 폼 상태.
/// step1/step2 응답 Map과 메모를 관리한다.
class ObservationFormState {
  /// 1단계 응답. key: 항목 ID, value: 0(아니오) / 1(보통) / 2(예).
  final Map<String, int> step1Responses;

  /// 2단계 응답. key: 항목 ID, value: 0(잘안보임) / 1(약하게) / 2(뚜렷함).
  final Map<String, int> step2Responses;

  /// 인라인 메모.
  final String? memo;

  const ObservationFormState({
    this.step1Responses = const {},
    this.step2Responses = const {},
    this.memo,
  });

  ObservationFormState copyWith({
    Map<String, int>? step1Responses,
    Map<String, int>? step2Responses,
    String? memo,
    bool clearMemo = false,
  }) {
    return ObservationFormState(
      step1Responses: step1Responses ?? this.step1Responses,
      step2Responses: step2Responses ?? this.step2Responses,
      memo: clearMemo ? null : (memo ?? this.memo),
    );
  }

  /// 1단계 핵심 항목(obs_s1_0 ~ obs_s1_3) 중 응답한 개수.
  int get coreResponseCount {
    const coreIds = ['obs_s1_0', 'obs_s1_1', 'obs_s1_2', 'obs_s1_3'];
    return coreIds.where((id) => step1Responses.containsKey(id)).length;
  }

  /// 핵심 3항목 이상 선택되었는지 여부.
  bool get isSubmittable => coreResponseCount >= 3;
}

/// 관찰 폼 상태 관리 Notifier.
class ObservationFormNotifier extends Notifier<ObservationFormState> {
  @override
  ObservationFormState build() => const ObservationFormState();

  /// 1단계 항목 응답을 설정한다.
  void setStep1Response(String itemId, int value) {
    final updated = Map<String, int>.from(state.step1Responses);
    updated[itemId] = value;
    state = state.copyWith(step1Responses: updated);
  }

  /// 2단계 항목 응답을 설정한다.
  void setStep2Response(String itemId, int value) {
    final updated = Map<String, int>.from(state.step2Responses);
    updated[itemId] = value;
    state = state.copyWith(step2Responses: updated);
  }

  /// 인라인 메모를 설정한다.
  void setMemo(String? memo) {
    state = state.copyWith(
      memo: memo,
      clearMemo: memo == null || memo.isEmpty,
    );
  }

  /// 폼 상태를 초기화한다.
  void reset() {
    state = const ObservationFormState();
  }
}

/// 관찰 폼 Provider.
final observationFormProvider =
    NotifierProvider<ObservationFormNotifier, ObservationFormState>(
  ObservationFormNotifier.new,
);

/// 최근 관찰 기록 Provider (홈 화면 연동용).
final latestObservationProvider =
    FutureProvider<ObservationRecord?>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null || baby.id == null) return null;

  final dao = ref.watch(observationRecordDaoProvider);
  return dao.getLatestByBabyId(baby.id!);
});

/// 관찰 기록을 저장하고 저장된 레코드를 반환한다.
Future<ObservationRecord> saveObservationRecord(
  WidgetRef ref, {
  required int babyId,
  required int activityRecordId,
}) async {
  final formState = ref.read(observationFormProvider);
  final dao = ref.read(observationRecordDaoProvider);

  // 해석 레벨 계산
  final level = ObservationInterpreter.interpret(
    step1Responses: formState.step1Responses,
    step2Responses: formState.step2Responses,
  );

  final now = nowKST();

  final record = ObservationRecord(
    babyId: babyId,
    activityRecordId: activityRecordId,
    date: now,
    step1Responses: jsonEncode(formState.step1Responses),
    step2Responses: jsonEncode(formState.step2Responses),
    adjustmentNote:
        formState.memo != null && formState.memo!.isNotEmpty
            ? formState.memo
            : null,
    interpretationLevel: level,
    createdAt: now,
  );

  final id = await dao.insert(record);

  // Provider 갱신
  ref.invalidate(latestObservationProvider);

  // 폼 초기화
  ref.read(observationFormProvider.notifier).reset();

  return ObservationRecord(
    id: id,
    babyId: record.babyId,
    activityRecordId: record.activityRecordId,
    date: record.date,
    step1Responses: record.step1Responses,
    step2Responses: record.step2Responses,
    comfortableActivity: record.comfortableActivity,
    uncomfortableActivity: record.uncomfortableActivity,
    adjustmentNote: record.adjustmentNote,
    interpretationLevel: record.interpretationLevel,
    createdAt: record.createdAt,
  );
}
