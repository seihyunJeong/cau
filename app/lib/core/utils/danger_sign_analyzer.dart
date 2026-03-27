import '../../data/models/danger_sign_record.dart';

/// 위험 신호 기록의 패턴을 분석하여 알림 메시지를 생성한다.
/// 개발기획서 6-4 기준.
class DangerSignAnalyzer {
  /// 최근 N일간 위험 신호 기록을 분석한다.
  /// 3일 연속 같은 항목이 체크되면 추적 알림 트리거
  static DangerSignAnalysis analyze(List<DangerSignRecord> records) {
    if (records.isEmpty) {
      return DangerSignAnalysis(
        hasConsecutiveSigns: false,
        message: '',
        consecutiveDays: 0,
      );
    }

    // 최근 7일 기록 필터
    final now = DateTime.now();
    final recentRecords = records
        .where((r) => now.difference(r.date).inDays <= 7)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    // 연속 체크 분석
    int maxConsecutive = 0;
    String? consecutiveSign;

    if (recentRecords.length >= 3) {
      // 각 위험 신호 항목별 연속 일수 계산
      final allSignKeys = recentRecords.first.signs.keys;
      for (final signKey in allSignKeys) {
        int consecutive = 0;
        for (final record in recentRecords) {
          if (record.signs[signKey] == true) {
            consecutive++;
          } else {
            break;
          }
        }
        if (consecutive > maxConsecutive) {
          maxConsecutive = consecutive;
          consecutiveSign = signKey;
        }
      }
    }

    if (maxConsecutive >= 3) {
      return DangerSignAnalysis(
        hasConsecutiveSigns: true,
        message:
            '$maxConsecutive일 연속 비슷한 패턴이 관찰되고 있어요.\n'
            '걱정이 되시면, 소아과 방문 시 이 기록을 보여주세요.',
        consecutiveDays: maxConsecutive,
        signKey: consecutiveSign,
      );
    }

    return DangerSignAnalysis(
      hasConsecutiveSigns: false,
      message: '',
      consecutiveDays: maxConsecutive,
    );
  }
}

/// 위험 신호 분석 결과.
class DangerSignAnalysis {
  final bool hasConsecutiveSigns;
  final String message;
  final int consecutiveDays;
  final String? signKey;

  DangerSignAnalysis({
    required this.hasConsecutiveSigns,
    required this.message,
    required this.consecutiveDays,
    this.signKey,
  });
}
