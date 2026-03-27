import '../models/checklist_item.dart';

/// 주차별 체크리스트 시드 데이터.
/// 개발기획서 8-3, 8-8 기준. 6개 영역 x 3문항 = 18문항.
/// 점수 기준은 공통: 4=자주 안정적, 3=종종 보임, 2=가끔 보임, 1=드물게 보임, 0=거의 안 보임

/// 주차 인덱스로 해당 주차의 체크리스트 문항 리스트를 반환한다.
/// 현재 0-1주차(weekIndex=0)만 구현. 이후 추가.
List<ChecklistItem> getChecklistItems(int weekIndex) {
  return checklistSeedData[weekIndex] ?? checklistSeedData[0]!;
}

/// 체크리스트 시드 데이터 (주차별).
const Map<int, List<ChecklistItem>> checklistSeedData = {
  // ── 0-1주차 ──
  0: [
    // 몸 움직임 (physical)
    ChecklistItem(
      id: 'physical_0',
      domain: 'physical',
      domainDisplayName: '몸 움직임',
      orderInDomain: 0,
      questionText: '팔다리를 몸 쪽으로 모은 자세를 해요',
    ),
    ChecklistItem(
      id: 'physical_1',
      domain: 'physical',
      domainDisplayName: '몸 움직임',
      orderInDomain: 1,
      questionText: '몸에 적당한 힘이 느껴져요',
    ),
    ChecklistItem(
      id: 'physical_2',
      domain: 'physical',
      domainDisplayName: '몸 움직임',
      orderInDomain: 2,
      questionText: '움직임이 부드러워요',
    ),
    // 감각 반응 (sensory)
    ChecklistItem(
      id: 'sensory_0',
      domain: 'sensory',
      domainDisplayName: '감각 반응',
      orderInDomain: 0,
      questionText: '소리가 나면 잠깐 멈추거나 반응해요',
    ),
    ChecklistItem(
      id: 'sensory_1',
      domain: 'sensory',
      domainDisplayName: '감각 반응',
      orderInDomain: 1,
      questionText: '밝은 빛에 눈을 감거나 고개를 돌려요',
    ),
    ChecklistItem(
      id: 'sensory_2',
      domain: 'sensory',
      domainDisplayName: '감각 반응',
      orderInDomain: 2,
      questionText: '피부에 닿는 것에 반응해요',
    ),
    // 집중과 관심 (cognitive)
    ChecklistItem(
      id: 'cognitive_0',
      domain: 'cognitive',
      domainDisplayName: '집중과 관심',
      orderInDomain: 0,
      questionText: '가까이 있는 얼굴을 잠깐 바라봐요',
    ),
    ChecklistItem(
      id: 'cognitive_1',
      domain: 'cognitive',
      domainDisplayName: '집중과 관심',
      orderInDomain: 1,
      questionText: '깨어 있을 때 주변을 둘러봐요',
    ),
    ChecklistItem(
      id: 'cognitive_2',
      domain: 'cognitive',
      domainDisplayName: '집중과 관심',
      orderInDomain: 2,
      questionText: '소리가 나는 쪽으로 관심을 보여요',
    ),
    // 소리와 표현 (language)
    ChecklistItem(
      id: 'language_0',
      domain: 'language',
      domainDisplayName: '소리와 표현',
      orderInDomain: 0,
      questionText: '배고프거나 불편할 때 울어요',
    ),
    ChecklistItem(
      id: 'language_1',
      domain: 'language',
      domainDisplayName: '소리와 표현',
      orderInDomain: 1,
      questionText: '편안할 때 작은 소리를 내요',
    ),
    ChecklistItem(
      id: 'language_2',
      domain: 'language',
      domainDisplayName: '소리와 표현',
      orderInDomain: 2,
      questionText: '울음 외에 다른 소리도 내요',
    ),
    // 마음과 관계 (emotional)
    ChecklistItem(
      id: 'emotional_0',
      domain: 'emotional',
      domainDisplayName: '마음과 관계',
      orderInDomain: 0,
      questionText: '안아주면 몸이 편안해져요',
    ),
    ChecklistItem(
      id: 'emotional_1',
      domain: 'emotional',
      domainDisplayName: '마음과 관계',
      orderInDomain: 1,
      questionText: '부모의 목소리에 반응해요',
    ),
    ChecklistItem(
      id: 'emotional_2',
      domain: 'emotional',
      domainDisplayName: '마음과 관계',
      orderInDomain: 2,
      questionText: '달래주면 울음이 줄어들어요',
    ),
    // 생활 리듬 (regulation)
    ChecklistItem(
      id: 'regulation_0',
      domain: 'regulation',
      domainDisplayName: '생활 리듬',
      orderInDomain: 0,
      questionText: '수유 후 잠이 들어요',
    ),
    ChecklistItem(
      id: 'regulation_1',
      domain: 'regulation',
      domainDisplayName: '생활 리듬',
      orderInDomain: 1,
      questionText: '깨어 있는 시간이 일정해지고 있어요',
    ),
    ChecklistItem(
      id: 'regulation_2',
      domain: 'regulation',
      domainDisplayName: '생활 리듬',
      orderInDomain: 2,
      questionText: '배고픔과 포만감 신호가 구별돼요',
    ),
  ],
};
