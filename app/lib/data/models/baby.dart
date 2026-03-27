import '../../core/utils/week_calculator.dart';

/// 아기 프로필 모델.
/// 개발기획서 4-2-2 기준. 순수 Dart 클래스, 코드 생성 불필요.
class Baby {
  final int? id;
  final String name;
  final DateTime birthDate;
  final String? profileImagePath;
  final DateTime createdAt;
  final bool isActive;

  const Baby({
    this.id,
    required this.name,
    required this.birthDate,
    this.profileImagePath,
    required this.createdAt,
    this.isActive = true,
  });

  /// sqflite INSERT용 Map 변환.
  /// id는 자동 생성이므로 제외한다.
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'birth_date': birthDate.toIso8601String(),
        'profile_image_path': profileImagePath,
        'created_at': createdAt.toIso8601String(),
        'is_active': isActive ? 1 : 0,
      };

  /// sqflite 조회 결과로부터 Baby 객체를 생성한다.
  factory Baby.fromMap(Map<String, dynamic> map) => Baby(
        id: map['id'] as int?,
        name: map['name'] as String,
        birthDate: DateTime.parse(map['birth_date'] as String),
        profileImagePath: map['profile_image_path'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        isActive: (map['is_active'] as int) == 1,
      );

  /// 불변 객체의 일부 필드를 변경한 복사본을 반환한다.
  Baby copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    String? profileImagePath,
    DateTime? createdAt,
    bool? isActive,
  }) =>
      Baby(
        id: id ?? this.id,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        profileImagePath: profileImagePath ?? this.profileImagePath,
        createdAt: createdAt ?? this.createdAt,
        isActive: isActive ?? this.isActive,
      );

  @override
  String toString() =>
      'Baby(id: $id, name: $name, birthDate: $birthDate, isActive: $isActive)';
}

/// Baby 모델의 확장 프로퍼티.
/// 개발기획서 4-2-2 기준. WeekCalculator를 사용하여 주차 관련 값을 계산한다.
extension BabyExt on Baby {
  /// 현재 주차 인덱스 (콘텐츠 매핑용).
  int get currentWeek => WeekCalculator.calculateWeekIndex(birthDate);

  /// 태어난 지 며칠인지.
  int get daysSinceBirth => WeekCalculator.daysSinceBirth(birthDate);

  /// 현재 주차 레이블 (예: "0-1주").
  String get weekLabel => WeekCalculator.calculateWeekLabel(birthDate);
}
