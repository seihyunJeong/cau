/// 활동 단계별 가이드 모델.
/// 개발기획서 8-2 기준.
class ActivityStep {
  final int stepNumber;
  final String instruction;
  final String? timerGuideText;
  final String? illustrationAsset;

  const ActivityStep({
    required this.stepNumber,
    required this.instruction,
    this.timerGuideText,
    this.illustrationAsset,
  });

  @override
  String toString() =>
      'ActivityStep(step: $stepNumber, instruction: $instruction)';
}
