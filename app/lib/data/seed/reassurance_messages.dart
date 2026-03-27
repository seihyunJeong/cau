import 'dart:math';

/// 상황별 안심 메시지 모음.
/// 개발기획서 8-6 기준.
class ReassuranceMessages {
  static final _random = Random();

  /// 되돌아온 사용자 (며칠 기록 없이 돌아온 경우).
  static const List<String> returnMessages = [
    '다시 오셨네요. 오늘부터 편하게 시작해요.',
    '언제든 다시 시작할 수 있어요.',
    '오늘도 충분히 잘 하고 계세요.',
  ];

  /// 활동 완료 축하.
  static const List<String> activityCompleteMessages = [
    '잘 하셨어요! 오늘 한 가지를 해냈어요.',
    '하나만 해도 충분해요.',
    '오늘도 아기와 함께한 소중한 시간이에요.',
  ];

  /// 기록 완료.
  static const List<String> recordCompleteMessages = [
    '기록이 저장되었어요.',
    '소중한 기록이 쌓이고 있어요.',
  ];

  /// 스트릭 재시작 (끊김 표시 없이).
  static const List<String> streakRestartMessages = [
    '다시 시작했어요!',
    '오늘부터 새로운 시작이에요.',
  ];

  /// 활동 완료 메시지 중 랜덤 1개를 반환한다.
  static String getRandomActivityCompleteMessage() {
    return activityCompleteMessages[
        _random.nextInt(activityCompleteMessages.length)];
  }
}
