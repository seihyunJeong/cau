/// 발달 체크리스트 문항 모델.
/// 개발기획서 8-3 기준. 시드 데이터 모델로 DB에 저장하지 않는다.
/// 6개 영역 x 3문항 = 18문항.
class ChecklistItem {
  /// 문항 고유 ID. 예: "physical_0"
  final String id;

  /// 영역 ID. 예: physical, sensory, cognitive, language, emotional, regulation
  final String domain;

  /// 영역 표시 이름 (부모 언어). 예: "몸 움직임"
  final String domainDisplayName;

  /// 영역 내 순서 (0, 1, 2)
  final int orderInDomain;

  /// 문항 텍스트 (부모 언어)
  final String questionText;

  const ChecklistItem({
    required this.id,
    required this.domain,
    required this.domainDisplayName,
    required this.orderInDomain,
    required this.questionText,
  });
}
