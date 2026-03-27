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
  WeekContent(
    weekIndex: 1,
    weekLabel: '2-3주',
    theme: '감각이 깨어나는 시간',
    overview: '아기가 점점 깨어 있는 시간이 늘어나고, '
        '주변 소리와 빛에 반응하기 시작해요. '
        '부모의 목소리에 귀를 기울여요.',
    keyPoints: [
      '조금씩 깨어 있는 시간이 늘어나요',
      '부모의 목소리를 좋아해요',
      '부드러운 빛과 소리에 반응해요',
      '고개를 살짝 돌리려는 시도를 해요',
    ],
  ),
];
