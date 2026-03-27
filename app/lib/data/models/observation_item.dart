/// 관찰 항목 모델. 시드 데이터에서 사용.
/// 개발기획서 8-5 기준.
class ObservationItem {
  /// 항목 고유 ID. 예: "obs_s1_0" 또는 "obs_s2_moro"
  final String id;

  /// 단계 번호. 1(활동 직후 모습) 또는 2(자연 반응 관찰).
  final int step;

  /// 관찰 항목 텍스트 (부모 언어).
  final String text;

  /// 선택지 목록.
  /// 1단계: ["예", "보통", "아니오"]
  /// 2단계: ["뚜렷함", "약하게", "잘 안 보임"]
  final List<String> options;

  const ObservationItem({
    required this.id,
    required this.step,
    required this.text,
    required this.options,
  });
}
