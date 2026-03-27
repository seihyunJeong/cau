/// 현재 주차 정보 모델.
/// 개발기획서 9-2 currentWeekProvider 참조.
class WeekInfo {
  final int weekIndex;
  final String weekLabel;
  final int daysSinceBirth;

  const WeekInfo({
    required this.weekIndex,
    required this.weekLabel,
    required this.daysSinceBirth,
  });

  /// 빈 상태 (아기 정보 없을 때 기본값).
  factory WeekInfo.empty() => const WeekInfo(
        weekIndex: 0,
        weekLabel: '0-1주',
        daysSinceBirth: 0,
      );

  @override
  String toString() =>
      'WeekInfo(weekIndex: $weekIndex, weekLabel: $weekLabel, '
      'days: $daysSinceBirth)';
}
