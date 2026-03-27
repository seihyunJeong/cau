import 'dart:convert';

/// 위험 신호 기록 모델.
/// 개발기획서 4-2 기준. danger_sign_records 테이블에 저장된다.
/// signs는 JSON 문자열로 직렬화하여 저장.
class DangerSignRecord {
  final int? id;
  final int babyId;
  final int weekNumber;
  final DateTime date;

  /// JSON: {"danger_0": true, "danger_1": false, ...}
  final String signsJson;

  /// 편의 접근자: JSON을 파싱하여 Map으로 반환
  Map<String, bool> get signs {
    final decoded = jsonDecode(signsJson) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v as bool));
  }

  final String? memo;

  /// 1개 이상 체크 여부
  final bool hasAnySign;

  final DateTime createdAt;

  const DangerSignRecord({
    this.id,
    required this.babyId,
    required this.weekNumber,
    required this.date,
    required this.signsJson,
    this.memo,
    this.hasAnySign = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'baby_id': babyId,
        'week_number': weekNumber,
        'date': date.toIso8601String(),
        'signs': signsJson,
        'memo': memo,
        'has_any_sign': hasAnySign ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory DangerSignRecord.fromMap(Map<String, dynamic> map) =>
      DangerSignRecord(
        id: map['id'] as int?,
        babyId: map['baby_id'] as int,
        weekNumber: map['week_number'] as int,
        date: DateTime.parse(map['date'] as String),
        signsJson: map['signs'] as String,
        memo: map['memo'] as String?,
        hasAnySign: (map['has_any_sign'] as int) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  @override
  String toString() =>
      'DangerSignRecord(id: $id, babyId: $babyId, weekNumber: $weekNumber, '
      'hasAnySign: $hasAnySign)';
}
