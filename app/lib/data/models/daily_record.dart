import '../../core/utils/date_utils.dart';

/// 일일 기록 모델.
/// 개발기획서 4-2-2 기준. 수유/배변 카운트, 수면 시간, 메모를 저장한다.
class DailyRecord {
  final int? id;
  final int babyId;
  final DateTime date;
  final int feedingCount;
  final int diaperCount;
  final double? sleepHours;
  final String? memo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const DailyRecord({
    this.id,
    required this.babyId,
    required this.date,
    this.feedingCount = 0,
    this.diaperCount = 0,
    this.sleepHours,
    this.memo,
    required this.createdAt,
    this.updatedAt,
  });

  /// 오늘 날짜의 새 레코드를 생성한다.
  factory DailyRecord.today(int babyId) {
    final now = nowKST();
    final today = DateTime(now.year, now.month, now.day);
    return DailyRecord(
      babyId: babyId,
      date: today,
      createdAt: now,
    );
  }

  /// sqflite INSERT용 Map 변환.
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'baby_id': babyId,
        'date': _dateToString(date),
        'feeding_count': feedingCount,
        'diaper_count': diaperCount,
        'sleep_hours': sleepHours,
        'memo': memo,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  /// sqflite 조회 결과로부터 DailyRecord 객체를 생성한다.
  factory DailyRecord.fromMap(Map<String, dynamic> map) => DailyRecord(
        id: map['id'] as int?,
        babyId: map['baby_id'] as int,
        date: DateTime.parse(map['date'] as String),
        feedingCount: map['feeding_count'] as int? ?? 0,
        diaperCount: map['diaper_count'] as int? ?? 0,
        sleepHours: (map['sleep_hours'] as num?)?.toDouble(),
        memo: map['memo'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: map['updated_at'] != null
            ? DateTime.parse(map['updated_at'] as String)
            : null,
      );

  /// 불변 객체의 일부 필드를 변경한 복사본을 반환한다.
  DailyRecord copyWith({
    int? id,
    int? babyId,
    DateTime? date,
    int? feedingCount,
    int? diaperCount,
    double? sleepHours,
    String? memo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      DailyRecord(
        id: id ?? this.id,
        babyId: babyId ?? this.babyId,
        date: date ?? this.date,
        feedingCount: feedingCount ?? this.feedingCount,
        diaperCount: diaperCount ?? this.diaperCount,
        sleepHours: sleepHours ?? this.sleepHours,
        memo: memo ?? this.memo,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// 날짜를 YYYY-MM-DD 문자열로 변환한다.
  static String _dateToString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  @override
  String toString() =>
      'DailyRecord(id: $id, babyId: $babyId, date: $date, '
      'feeding: $feedingCount, diaper: $diaperCount)';
}
