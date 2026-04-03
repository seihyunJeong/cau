import '../models/checklist_item.dart';
import '../models/danger_sign_item.dart';

/// 주차별 콘텐츠 시드 데이터 모델 + 0-1주차 데이터.
/// 개발기획서 8-1, 8-8 기준.
/// Sprint 07에서 checklistItems, dangerSigns 필드가 추가되었다.
class WeekContent {
  final int weekIndex;
  final String weekLabel;
  final String theme;
  final String overview;
  final List<String> keyPoints;

  /// 체크리스트 문항 (Sprint 07 추가). null이면 시드 데이터에서 조회.
  final List<ChecklistItem>? checklistItems;

  /// 위험 신호 항목 (Sprint 07 추가). null이면 시드 데이터에서 조회.
  final List<DangerSignItem>? dangerSigns;

  const WeekContent({
    required this.weekIndex,
    required this.weekLabel,
    required this.theme,
    required this.overview,
    required this.keyPoints,
    this.checklistItems,
    this.dangerSigns,
  });
}

/// 주차 인덱스로 WeekContent를 조회한다.
/// 해당 인덱스의 콘텐츠가 없으면 0주차(기본) 데이터를 반환한다.
WeekContent getWeekContent(int weekIndex) {
  return weekContentSeed.firstWhere(
    (w) => w.weekIndex == weekIndex,
    orElse: () => weekContentSeed.first,
  );
}

/// 시드 데이터: 0-1주차, 2-3주차.
/// 이후 스프린트에서 추가 주차 데이터가 확장된다.
const List<WeekContent> weekContentSeed = [
  // ── 0-1주차 ──
  WeekContent(
    weekIndex: 0,
    weekLabel: '0-1주',
    theme: '신경이 안정되는 시간',
    overview: '이 시기 아기는 하루 대부분을 잠으로 보내며, '
        '조용한 환경에서 안정을 배워가고 있어요. '
        '부모의 품이 가장 편안한 장소예요.',
    keyPoints: [
      '대부분의 시간을 잠으로 보내요',
      '깜짝 놀라는 반응은 자연스러운 거예요',
      '부모의 품이 가장 편안한 장소예요',
      '밝은 빛이나 큰 소리는 자극이 될 수 있어요',
    ],
  ),
  // ── 2-3주차 ──
  // PDF 원고 제2장 (p.41~42) "연결이 늘어나는 시간" 기반
  WeekContent(
    weekIndex: 1,
    weekLabel: '2-3주',
    theme: '연결이 늘어나는 시간',
    overview: '2-3주는 아기가 세상에 적응을 계속하면서도, '
        '조금씩 깨어 있는 시간이 늘고, 먹고 자는 리듬이 정리되기 시작하는 시기예요. '
        '짧고 부드럽게, 반복적으로 아기 신호를 읽으면서 활동해요.',
    keyPoints: [
      '수유-수면 리듬이 조금 더 안정되고 있어요',
      '깨어 있는 동안 안정(진정) 회복이 빨라지고 있어요',
      '부모와의 연결(목소리-얼굴-접촉)에 반응이 늘어나요',
      '과한 자극 없이 편안함을 반복 경험하는 것이 핵심이에요',
      '짧은 활동을 조금 더 자주 해볼 수 있는 시기예요',
    ],
  ),
];
