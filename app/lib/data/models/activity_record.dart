/// 활동 완료 기록 모델.
/// 개발기획서 4-2 기준. activity_records 테이블에 저장된다.
class ActivityRecord {
  final int? id;
  final int babyId;
  final String activityId;
  final int weekNumber;
  final DateTime completedAt;
  final int? timerDurationSec;
  final bool timerUsed;

  const ActivityRecord({
    this.id,
    required this.babyId,
    required this.activityId,
    required this.weekNumber,
    required this.completedAt,
    this.timerDurationSec,
    required this.timerUsed,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'baby_id': babyId,
        'activity_id': activityId,
        'week_number': weekNumber,
        'completed_at': completedAt.toIso8601String(),
        'timer_duration_sec': timerDurationSec,
        'timer_used': timerUsed ? 1 : 0,
      };

  factory ActivityRecord.fromMap(Map<String, dynamic> map) => ActivityRecord(
        id: map['id'] as int?,
        babyId: map['baby_id'] as int,
        activityId: map['activity_id'] as String,
        weekNumber: map['week_number'] as int,
        completedAt: DateTime.parse(map['completed_at'] as String),
        timerDurationSec: map['timer_duration_sec'] as int?,
        timerUsed: (map['timer_used'] as int) == 1,
      );

  @override
  String toString() =>
      'ActivityRecord(id: $id, activityId: $activityId, completedAt: $completedAt)';
}
