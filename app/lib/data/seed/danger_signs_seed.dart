import '../models/danger_sign_item.dart';

/// 주차별 위험 신호 시드 데이터.
/// 개발기획서 8-4, 8-8 기준. 각 주차 6개 항목.

/// 주차 인덱스로 해당 주차의 위험 신호 항목 리스트를 반환한다.
List<DangerSignItem> getDangerSignItems(int weekIndex) {
  return dangerSignSeedData[weekIndex] ?? dangerSignSeedData[0]!;
}

/// 위험 신호 시드 데이터 (주차별).
const Map<int, List<DangerSignItem>> dangerSignSeedData = {
  // ── 0-1주차 ──
  0: [
    DangerSignItem(
      id: 'danger_0',
      weekIndex: 0,
      text: '수유 시 잘 빨지 못하거나 자주 사래들려요',
    ),
    DangerSignItem(
      id: 'danger_1',
      weekIndex: 0,
      text: '하루 종일 거의 깨어나지 않거나 반대로 거의 잠을 자지 못해요',
    ),
    DangerSignItem(
      id: 'danger_2',
      weekIndex: 0,
      text: '몸이 너무 축 늘어져 있거나 너무 뻣뻣해요',
    ),
    DangerSignItem(
      id: 'danger_3',
      weekIndex: 0,
      text: '달래줘도 30분 이상 울음이 그치지 않아요',
    ),
    DangerSignItem(
      id: 'danger_4',
      weekIndex: 0,
      text: '소리에 전혀 반응하지 않아요',
    ),
    DangerSignItem(
      id: 'danger_5',
      weekIndex: 0,
      text: '피부색이 푸르거나 노란빛이 심해요',
    ),
  ],

  // ── 2-3주차 ──
  // PDF p.71 기반. 0-1주차와 동일한 6개 공통 위험 신호.
  1: [
    DangerSignItem(
      id: 'w1_danger_0',
      weekIndex: 1,
      text: '전반 반응 저하: 시선-소리-촉감-움직임 반응이 갑자기 줄어들어요',
    ),
    DangerSignItem(
      id: 'w1_danger_1',
      weekIndex: 1,
      text: '한쪽 치우침 지속: 몸이나 머리가 한쪽으로만 계속 기울거나 치우쳐요',
    ),
    DangerSignItem(
      id: 'w1_danger_2',
      weekIndex: 1,
      text: '먹기/잠/울음 회복 어려움: 진정이 거의 되지 않아요',
    ),
    DangerSignItem(
      id: 'w1_danger_3',
      weekIndex: 1,
      text: '호흡이 평소보다 힘들어 보이거나 불규칙함이 반복돼요',
    ),
    DangerSignItem(
      id: 'w1_danger_4',
      weekIndex: 1,
      text: '입술/피부색이 평소와 다르게 창백하거나 푸렇게 보여요',
    ),
    DangerSignItem(
      id: 'w1_danger_5',
      weekIndex: 1,
      text: '보호자 직감: "뭔가 이상하다" 느낌이 강해요',
    ),
  ],
};
