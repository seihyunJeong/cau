/// 성장 기록 모델.
/// 개발기획서 4-2-2 기준. 체중, 키, 머리둘레를 저장한다.
class GrowthRecord {
  final int? id;
  final int babyId;
  final DateTime date;
  final double? weightKg;
  final double? heightCm;
  final double? headCircumCm;
  final DateTime createdAt;

  const GrowthRecord({
    this.id,
    required this.babyId,
    required this.date,
    this.weightKg,
    this.heightCm,
    this.headCircumCm,
    required this.createdAt,
  });

  /// sqflite INSERT용 Map 변환.
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'baby_id': babyId,
        'date': date.toIso8601String(),
        'weight_kg': weightKg,
        'height_cm': heightCm,
        'head_circum_cm': headCircumCm,
        'created_at': createdAt.toIso8601String(),
      };

  /// sqflite 조회 결과로부터 GrowthRecord 객체를 생성한다.
  factory GrowthRecord.fromMap(Map<String, dynamic> map) => GrowthRecord(
        id: map['id'] as int?,
        babyId: map['baby_id'] as int,
        date: DateTime.parse(map['date'] as String),
        weightKg: (map['weight_kg'] as num?)?.toDouble(),
        heightCm: (map['height_cm'] as num?)?.toDouble(),
        headCircumCm: (map['head_circum_cm'] as num?)?.toDouble(),
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  /// 불변 객체의 일부 필드를 변경한 복사본을 반환한다.
  GrowthRecord copyWith({
    int? id,
    int? babyId,
    DateTime? date,
    double? weightKg,
    double? heightCm,
    double? headCircumCm,
    DateTime? createdAt,
  }) =>
      GrowthRecord(
        id: id ?? this.id,
        babyId: babyId ?? this.babyId,
        date: date ?? this.date,
        weightKg: weightKg ?? this.weightKg,
        heightCm: heightCm ?? this.heightCm,
        headCircumCm: headCircumCm ?? this.headCircumCm,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  String toString() =>
      'GrowthRecord(id: $id, babyId: $babyId, weight: $weightKg, '
      'height: $heightCm)';
}
