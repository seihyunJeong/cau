import 'date_utils.dart';

/// 생년월일로부터 현재 주차를 계산한다.
/// 개발기획서 6-1 기준.
///
/// 주차 정의:
///   0-1주: 생후 0~13일 (0~1주)
///   2-3주: 생후 14~27일 (2~3주)
///   4-5주: 생후 28~41일 (4~5주)
///   ...이후 2주 단위로 증가
///   4개월 이후: 월 단위로 전환
class WeekCalculator {
  /// 생년월일로부터 현재 주차 구간을 반환한다.
  /// 반환값: 주차 구간 문자열 (예: "0-1주", "2-3주")
  /// KST 기준 nowKST()를 사용한다.
  static String calculateWeekLabel(DateTime birthDate) {
    final now = nowKST();
    final days = now.difference(birthDate).inDays;

    if (days < 0) return '0-1주';

    if (days <= 13) return '0-1주';
    if (days <= 27) return '2-3주';

    // 4주 이후: 2주 단위로 계산
    final weeks = days ~/ 7;
    if (weeks < 8) {
      final startWeek = ((weeks ~/ 2) * 2);
      return '$startWeek-${startWeek + 1}주';
    }

    // 2개월 이후: 월 단위 (4주 = 1개월 기준)
    // 8주(56일) = 2개월, 12주(84일) = 3개월 ...
    final months = (weeks / 4).round();
    if (months < 1) return '1개월'; // 안전 장치 (8주 미만이 여기 올 일 없음)
    if (months <= 60) {
      return '$months개월';
    }

    return '60개월+';
  }

  /// 생년월일로부터 현재 주차 번호를 반환한다 (콘텐츠 매핑용).
  /// 0 = 0-1주, 1 = 2-3주, 2 = 4-5주, ...
  /// KST 기준 nowKST()를 사용한다.
  static int calculateWeekIndex(DateTime birthDate) {
    final now = nowKST();
    final days = now.difference(birthDate).inDays;

    if (days < 0) return 0;
    if (days <= 13) return 0; // 0-1주
    if (days <= 27) return 1; // 2-3주

    final weeks = days ~/ 7;
    return weeks ~/ 2;
  }

  /// 태어난 지 며칠인지 반환한다.
  /// KST 기준 nowKST()를 사용한다.
  static int daysSinceBirth(DateTime birthDate) {
    return nowKST().difference(birthDate).inDays;
  }
}
