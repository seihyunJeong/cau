import 'activity_step.dart';
import 'equipment.dart';

/// 활동 모델.
/// 개발기획서 8-2 기준. 시드 데이터로 관리되며 DB에 저장하지 않는다.
class Activity {
  final String id;
  final int weekIndex;
  final int order;
  final String name;
  final String type;
  final String description;
  final String linkedReflex;
  final int recommendedSeconds;
  final List<ActivityStep> steps;
  final List<String> observationPoints;
  final String rationale;
  final List<String> expectedEffects;
  final List<String> cautions;
  final List<String> tips;
  final Equipment equipment;

  const Activity({
    required this.id,
    required this.weekIndex,
    required this.order,
    required this.name,
    required this.type,
    required this.description,
    required this.linkedReflex,
    required this.recommendedSeconds,
    required this.steps,
    required this.observationPoints,
    required this.rationale,
    required this.expectedEffects,
    required this.cautions,
    required this.tips,
    required this.equipment,
  });

  @override
  String toString() =>
      'Activity(id: $id, name: $name, type: $type, week: $weekIndex)';
}
