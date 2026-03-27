/// 발달 체크리스트 기록 모델.
/// 개발기획서 4-2 기준. checklist_records 테이블에 저장된다.
/// responses, memos, domain_scores는 JSON 문자열로 직렬화하여 저장.
class ChecklistRecord {
  final int? id;
  final int babyId;
  final int weekNumber;
  final DateTime date;

  /// JSON: {"physical_0": 3, "physical_1": 2, ...}
  final String responses;

  /// JSON: {"physical_0": "메모 텍스트", ...}
  final String? memos;

  /// 총점 (0~72)
  final int totalScore;

  /// 퍼센트 (0~100)
  final double percentage;

  /// 구간 (1~5)
  final int tier;

  /// JSON: {"physical": 10, "sensory": 8, ...}
  final String domainScores;

  /// 18문항 모두 완료 여부
  final bool isComplete;

  final DateTime createdAt;

  const ChecklistRecord({
    this.id,
    required this.babyId,
    required this.weekNumber,
    required this.date,
    required this.responses,
    this.memos,
    required this.totalScore,
    required this.percentage,
    required this.tier,
    required this.domainScores,
    this.isComplete = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'baby_id': babyId,
        'week_number': weekNumber,
        'date': date.toIso8601String(),
        'responses': responses,
        'memos': memos,
        'total_score': totalScore,
        'percentage': percentage,
        'tier': tier,
        'domain_scores': domainScores,
        'is_complete': isComplete ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory ChecklistRecord.fromMap(Map<String, dynamic> map) => ChecklistRecord(
        id: map['id'] as int?,
        babyId: map['baby_id'] as int,
        weekNumber: map['week_number'] as int,
        date: DateTime.parse(map['date'] as String),
        responses: map['responses'] as String,
        memos: map['memos'] as String?,
        totalScore: map['total_score'] as int,
        percentage: (map['percentage'] as num).toDouble(),
        tier: map['tier'] as int,
        domainScores: map['domain_scores'] as String,
        isComplete: (map['is_complete'] as int) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  @override
  String toString() =>
      'ChecklistRecord(id: $id, babyId: $babyId, weekNumber: $weekNumber, '
      'tier: $tier, totalScore: $totalScore)';
}
