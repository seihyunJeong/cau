import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/date_utils.dart';
import '../core/utils/score_calculator.dart';
import '../data/models/baby.dart';
import '../data/models/checklist_item.dart';
import '../data/models/checklist_record.dart';
import '../data/seed/checklist_seed.dart';
import 'baby_providers.dart';
import 'core_providers.dart';

// ── 중간 저장 키 ──
const _prefsKeyResponses = 'checklist_in_progress_responses';
const _prefsKeyMemos = 'checklist_in_progress_memos';

/// 현재 주차 체크리스트 문항 리스트 Provider.
final currentChecklistItemsProvider = Provider<List<ChecklistItem>>((ref) {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null) return getChecklistItems(0);
  return getChecklistItems(baby.currentWeek);
});

/// 체크리스트 응답 상태 (중간 저장 지원).
class ChecklistInProgressNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() {
    _loadFromPrefs();
    return {};
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKeyResponses);
    if (json != null) {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      state = decoded.map((k, v) => MapEntry(k, v as int));
    }
  }

  void setResponse(String questionId, int score) {
    final updated = Map<String, int>.from(state);
    updated[questionId] = score;
    state = updated;
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyResponses, jsonEncode(state));
  }

  Future<void> clearSaved() async {
    state = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyResponses);
  }
}

/// 체크리스트 메모 상태.
class ChecklistMemosNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() {
    _loadFromPrefs();
    return {};
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKeyMemos);
    if (json != null) {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      state = decoded.map((k, v) => MapEntry(k, v as String));
    }
  }

  void setMemo(String questionId, String memo) {
    final updated = Map<String, String>.from(state);
    if (memo.isEmpty) {
      updated.remove(questionId);
    } else {
      updated[questionId] = memo;
    }
    state = updated;
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyMemos, jsonEncode(state));
  }

  Future<void> clearSaved() async {
    state = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyMemos);
  }
}

final checklistInProgressProvider =
    NotifierProvider<ChecklistInProgressNotifier, Map<String, int>>(
  ChecklistInProgressNotifier.new,
);

final checklistMemosInProgressProvider =
    NotifierProvider<ChecklistMemosNotifier, Map<String, String>>(
  ChecklistMemosNotifier.new,
);

/// 이번 주차 최근 체크리스트 결과 Provider.
final latestChecklistResultProvider =
    FutureProvider<ChecklistRecord?>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null || baby.id == null) return null;

  final dao = ref.watch(checklistRecordDaoProvider);
  return dao.getLatestByWeek(baby.id!, baby.currentWeek);
});

/// 해당 아기의 전체 체크리스트 기록 Provider (추이용).
final checklistHistoryProvider =
    FutureProvider<List<ChecklistRecord>>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null || baby.id == null) return [];

  final dao = ref.watch(checklistRecordDaoProvider);
  return dao.getAllByBabyId(baby.id!);
});

/// 체크리스트 결과를 저장한다.
Future<ChecklistRecord> saveChecklistRecord(
  WidgetRef ref, {
  required int babyId,
  required int weekNumber,
}) async {
  final responses = ref.read(checklistInProgressProvider);
  final memos = ref.read(checklistMemosInProgressProvider);
  final dao = ref.read(checklistRecordDaoProvider);

  final totalScore = ScoreCalculator.calculateTotalScore(responses);
  final percentage = ScoreCalculator.calculatePercentage(totalScore);
  final tier = ScoreCalculator.calculateTier(percentage);
  final domainScores = ScoreCalculator.calculateDomainScores(responses);
  final isComplete = responses.length >= ScoreCalculator.totalQuestions;

  final now = nowKST();

  final record = ChecklistRecord(
    babyId: babyId,
    weekNumber: weekNumber,
    date: now,
    responses: jsonEncode(responses),
    memos: memos.isNotEmpty ? jsonEncode(memos) : null,
    totalScore: totalScore,
    percentage: percentage,
    tier: tier,
    domainScores: jsonEncode(domainScores),
    isComplete: isComplete,
    createdAt: now,
  );

  final id = await dao.insert(record);

  // 중간 저장 데이터 삭제
  await ref.read(checklistInProgressProvider.notifier).clearSaved();
  await ref.read(checklistMemosInProgressProvider.notifier).clearSaved();

  // Provider 갱신
  ref.invalidate(latestChecklistResultProvider);
  ref.invalidate(checklistHistoryProvider);

  return ChecklistRecord(
    id: id,
    babyId: record.babyId,
    weekNumber: record.weekNumber,
    date: record.date,
    responses: record.responses,
    memos: record.memos,
    totalScore: record.totalScore,
    percentage: record.percentage,
    tier: record.tier,
    domainScores: record.domainScores,
    isComplete: record.isComplete,
    createdAt: record.createdAt,
  );
}
