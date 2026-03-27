/// 위험 신호 항목 모델.
/// 개발기획서 8-4 기준. 시드 데이터 모델로 DB에 저장하지 않는다.
/// 각 주차별 6개 항목.
class DangerSignItem {
  /// 항목 고유 ID. 예: "danger_0"
  final String id;

  /// 해당 주차 인덱스
  final int weekIndex;

  /// 위험 신호 설명 (부모 언어)
  final String text;

  const DangerSignItem({
    required this.id,
    required this.weekIndex,
    required this.text,
  });
}
