/// 교구/준비물 모델.
/// 개발기획서 8-2 기준.
class Equipment {
  final bool isRequired;
  final String? itemName;
  final String? description;
  final String? diyAlternative;
  final String? purchaseNote;

  const Equipment({
    required this.isRequired,
    this.itemName,
    this.description,
    this.diyAlternative,
    this.purchaseNote,
  });

  @override
  String toString() =>
      'Equipment(isRequired: $isRequired, itemName: $itemName)';
}
