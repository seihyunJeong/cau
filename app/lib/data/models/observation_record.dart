/// 활동 후 관찰 기록 모델.
/// 개발기획서 4-2 기준. observation_records 테이블에 저장된다.
/// step1Responses, step2Responses는 JSON 문자열로 직렬화하여 저장.
class ObservationRecord {
  final int? id;
  final int babyId;
  final int activityRecordId;
  final DateTime date;
  final String step1Responses;
  final String step2Responses;
  final String? comfortableActivity;
  final String? uncomfortableActivity;
  final String? adjustmentNote;
  final int interpretationLevel;
  final DateTime createdAt;

  const ObservationRecord({
    this.id,
    required this.babyId,
    required this.activityRecordId,
    required this.date,
    required this.step1Responses,
    required this.step2Responses,
    this.comfortableActivity,
    this.uncomfortableActivity,
    this.adjustmentNote,
    required this.interpretationLevel,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'baby_id': babyId,
        'activity_record_id': activityRecordId,
        'date': date.toIso8601String(),
        'step1_responses': step1Responses,
        'step2_responses': step2Responses,
        'comfortable_activity': comfortableActivity,
        'uncomfortable_activity': uncomfortableActivity,
        'adjustment_note': adjustmentNote,
        'interpretation_level': interpretationLevel,
        'created_at': createdAt.toIso8601String(),
      };

  factory ObservationRecord.fromMap(Map<String, dynamic> map) =>
      ObservationRecord(
        id: map['id'] as int?,
        babyId: map['baby_id'] as int,
        activityRecordId: map['activity_record_id'] as int,
        date: DateTime.parse(map['date'] as String),
        step1Responses: map['step1_responses'] as String,
        step2Responses: map['step2_responses'] as String,
        comfortableActivity: map['comfortable_activity'] as String?,
        uncomfortableActivity: map['uncomfortable_activity'] as String?,
        adjustmentNote: map['adjustment_note'] as String?,
        interpretationLevel: map['interpretation_level'] as int,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  @override
  String toString() =>
      'ObservationRecord(id: $id, activityRecordId: $activityRecordId, '
      'interpretationLevel: $interpretationLevel)';
}
