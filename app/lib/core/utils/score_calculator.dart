/// 발달 체크리스트 점수를 계산하고, 구간을 매핑하며,
/// 부모 친화적 안심 메시지를 생성한다.
/// 개발기획서 6-2 기준.
class ScoreCalculator {
  static const int totalQuestions = 18;
  static const int maxScorePerQuestion = 4;
  static const int maxTotalScore =
      totalQuestions * maxScorePerQuestion; // 72

  /// 6개 발달 영역 정의
  static const List<String> domains = [
    'physical', // 신체/성장 -> "몸 움직임"
    'sensory', // 감각/지각 -> "감각 반응"
    'cognitive', // 인지/주의 -> "집중과 관심"
    'language', // 언어/의사소통 -> "소리와 표현"
    'emotional', // 정서/사회 -> "마음과 관계"
    'regulation', // 조절/수면/생리 -> "생활 리듬"
  ];

  /// 영역 내부 ID -> 부모 친화적 표시 이름 매핑
  static const Map<String, String> domainDisplayNames = {
    'physical': '몸 움직임',
    'sensory': '감각 반응',
    'cognitive': '집중과 관심',
    'language': '소리와 표현',
    'emotional': '마음과 관계',
    'regulation': '생활 리듬',
  };

  /// 응답 데이터로부터 총점을 계산한다.
  /// [responses]: key="domain_index" (예: "physical_0"), value=0~4
  static int calculateTotalScore(Map<String, int> responses) {
    return responses.values.fold(0, (sum, score) => sum + score);
  }

  /// 총점으로부터 퍼센트를 계산한다.
  static double calculatePercentage(int totalScore) {
    return (totalScore / maxTotalScore) * 100;
  }

  /// 퍼센트로부터 5구간 티어를 반환한다.
  /// 1 = 85~100% (매우 안정)
  /// 2 = 70~84% (안정적)
  /// 3 = 55~69% (보통)
  /// 4 = 40~54% (관찰 필요)
  /// 5 = 0~39% (주의 관찰)
  static int calculateTier(double percentage) {
    if (percentage >= 85) return 1;
    if (percentage >= 70) return 2;
    if (percentage >= 55) return 3;
    if (percentage >= 40) return 4;
    return 5;
  }

  /// 영역별 점수를 계산한다.
  /// 각 영역 3문항 x 4점 = 12점 만점
  static Map<String, int> calculateDomainScores(Map<String, int> responses) {
    final Map<String, int> domainScores = {};

    for (final domain in domains) {
      int score = 0;
      for (int i = 0; i < 3; i++) {
        final key = '${domain}_$i';
        score += responses[key] ?? 0;
      }
      domainScores[domain] = score;
    }

    return domainScores;
  }

  /// 티어에 따른 부모 안심 메시지를 반환한다.
  /// 원칙: 숫자보다 말로 안심시킨다. 죄책감을 주지 않는다.
  static String getTierMessage(int tier) {
    switch (tier) {
      case 1:
        return '오늘 관찰한 결과, 전반적으로 매우 안정적인 흐름이에요.\n'
            '지금 하고 계신 방식이 아기에게 잘 맞고 있어요.';
      case 2:
        return '오늘 관찰한 결과, 대체로 안정적인 흐름이에요.\n'
            '아기가 편안해하는 모습이 보여요.';
      case 3:
        return '아기가 적응해 가는 중이에요.\n'
            '며칠의 흐름을 함께 살펴보면 좋겠어요.';
      case 4:
        return '오늘은 조금 예민한 날이었을 수 있어요.\n'
            '내일 한 번 더 살펴볼까요?';
      case 5:
        return '아기가 조금 힘든 하루였을 수 있어요.\n'
            '며칠 더 지켜보면서, 걱정이 계속되면 전문가와 이야기해 보세요.';
      default:
        return '';
    }
  }

  /// 티어에 따른 부모 솔루션 메시지 목록을 반환한다.
  static List<String> getSolutionMessages(int tier) {
    switch (tier) {
      case 1:
        return [
          '지금의 루틴을 유지해 주세요.',
          '아기가 좋아하는 활동을 반복해도 좋아요.',
          '이 흐름이 이어지면 다음 주차로 자연스럽게 넘어갈 수 있어요.',
        ];
      case 2:
        return [
          '전체적으로 좋은 흐름이에요.',
          '조금 약한 영역이 있다면, 해당 활동을 한 번 더 시도해 보세요.',
          '무리하지 않아도 돼요. 하루 한 가지면 충분해요.',
        ];
      case 3:
        return [
          '한 번의 관찰로 판단하기 어려워요. 며칠의 흐름을 보세요.',
          '아기의 컨디션은 날마다 다를 수 있어요.',
          '편안한 활동 위주로 짧게 시도해 보세요.',
        ];
      case 4:
        return [
          '오늘 아기가 예민했을 수 있어요.',
          '활동 시간을 줄이거나, 쉬는 시간을 더 가져보세요.',
          '며칠 이어서 관찰해 보시고, 걱정되면 전문가 상담을 고려해 보세요.',
        ];
      case 5:
        return [
          '아기가 힘들어하는 신호일 수 있어요.',
          '활동을 잠시 쉬고, 편안한 환경을 만들어 주세요.',
          '2~3일 이상 비슷한 패턴이 계속되면, 소아과 방문 시 이 기록을 보여주세요.',
        ];
      default:
        return [];
    }
  }

  /// 영역별 점수에 따른 부모 친화적 메시지를 반환한다.
  /// 12점 만점 기준
  static String getDomainMessage(String domain, int score) {
    final name = domainDisplayNames[domain] ?? domain;
    final percentage = (score / 12) * 100;

    if (percentage >= 85) return '$name이 편안해 보여요';
    if (percentage >= 70) return '$name이 잘 반응하고 있어요';
    if (percentage >= 55) return '$name이 자리 잡아가고 있어요';
    if (percentage >= 40) return '$name을 조금 더 살펴볼까요?';
    return '$name에서 아기가 힘들어할 수 있어요';
  }

  /// 이전 주차 대비 변화 메시지를 반환한다.
  static String getTrendMessage(double currentPct, double previousPct) {
    final diff = currentPct - previousPct;
    if (diff > 10) return '좋아지고 있어요';
    if (diff > 0) return '조금씩 나아지고 있어요';
    if (diff > -5) return '비슷한 흐름이에요';
    return '며칠 더 지켜볼까요?';
  }
}
