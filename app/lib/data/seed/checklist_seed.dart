import '../models/checklist_item.dart';

/// 주차별 체크리스트 시드 데이터.
/// 개발기획서 8-3, 8-8 기준. 6개 영역 x 3문항 = 18문항.
/// 점수 기준은 공통: 4=자주 안정적, 3=종종 보임, 2=가끔 보임, 1=드물게 보임, 0=거의 안 보임

/// 주차 인덱스로 해당 주차의 체크리스트 문항 리스트를 반환한다.
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

  // ── 2-3주차 ──
  // PDF p.67~69 "2-4. 부모 관찰 기록용 체크리스트" 기반
  1: [
    // 신체-성장 (physical)
    ChecklistItem(
      id: 'w1_physical_0',
      domain: 'physical',
      domainDisplayName: '몸 움직임',
      orderInDomain: 0,
      questionText:
          '수유 후 너무 지치지 않고, 먹고 난 뒤 전반적으로 조금 더 안정되는 흐름이 있다',
    ),
    ChecklistItem(
      id: 'w1_physical_1',
      domain: 'physical',
      domainDisplayName: '몸 움직임',
      orderInDomain: 1,
      questionText:
          '깨어 있는 짧은 시간에 팔다리를 스스로 움직이는 모습이 자연스럽게 보인다',
    ),
    ChecklistItem(
      id: 'w1_physical_2',
      domain: 'physical',
      domainDisplayName: '몸 움직임',
      orderInDomain: 2,
      questionText:
          '몸이 지나치게 축 늘어지지 않고, 한쪽으로만 심하게 치우치는 모습이 반복되지는 않는다',
    ),
    // 감각-지각 (sensory)
    ChecklistItem(
      id: 'w1_sensory_0',
      domain: 'sensory',
      domainDisplayName: '감각 반응',
      orderInDomain: 0,
      questionText:
          '20~30cm 거리에서 보호자 얼굴을 잠깐이라도 바라보는 순간이 있다',
    ),
    ChecklistItem(
      id: 'w1_sensory_1',
      domain: 'sensory',
      domainDisplayName: '감각 반응',
      orderInDomain: 1,
      questionText:
          '갑작스러운 소리나 자세 변화에 놀라도, 안아주거나 기다리면 비교적 다시 가라앉는 편이다',
    ),
    ChecklistItem(
      id: 'w1_sensory_2',
      domain: 'sensory',
      domainDisplayName: '감각 반응',
      orderInDomain: 2,
      questionText:
          '부드러운 접촉이나 쓰다듬기 뒤 몸이 이완되거나 편안해지는 반응이 있다',
    ),
    // 인지-주의 (cognitive)
    ChecklistItem(
      id: 'w1_cognitive_0',
      domain: 'cognitive',
      domainDisplayName: '집중과 관심',
      orderInDomain: 0,
      questionText:
          '깨어 있을 때 얼굴이나 빛 쪽에 1~2초라도 주의가 머무는 순간이 있다',
    ),
    ChecklistItem(
      id: 'w1_cognitive_1',
      domain: 'cognitive',
      domainDisplayName: '집중과 관심',
      orderInDomain: 1,
      questionText:
          '비슷한 자극이 반복될 때, 처음보다 덜 놀라거나 점차 안정되는 모습이 있다',
    ),
    ChecklistItem(
      id: 'w1_cognitive_2',
      domain: 'cognitive',
      domainDisplayName: '집중과 관심',
      orderInDomain: 2,
      questionText:
          '짧은 활동 뒤 고개 돌림, 하품, 찡그림 같은 쉬고 싶다는 신호가 잠시 보이더라도, '
          '비교적 다시 안정되는 편이다',
    ),
    // 언어-의사소통 (language)
    ChecklistItem(
      id: 'w1_language_0',
      domain: 'language',
      domainDisplayName: '소리와 표현',
      orderInDomain: 0,
      questionText:
          '배고픔, 졸림, 불편함에 따라 울음이나 몸짓이 조금 다르게 느껴지는 순간이 있다',
    ),
    ChecklistItem(
      id: 'w1_language_1',
      domain: 'language',
      domainDisplayName: '소리와 표현',
      orderInDomain: 1,
      questionText:
          '보호자 목소리가 들리면 울음을 잠깐 멈추거나 표정-몸 움직임이 달라진다',
    ),
    ChecklistItem(
      id: 'w1_language_2',
      domain: 'language',
      domainDisplayName: '소리와 표현',
      orderInDomain: 2,
      questionText:
          '가까이에서 말을 걸면 시선, 표정, 몸 움직임에 잠깐 변화가 나타난다',
    ),
    // 정서-사회 (emotional)
    ChecklistItem(
      id: 'w1_emotional_0',
      domain: 'emotional',
      domainDisplayName: '마음과 관계',
      orderInDomain: 0,
      questionText:
          '안아주거나 피부 접촉을 하면 몸이 이완되거나 진정되는 모습이 있다',
    ),
    ChecklistItem(
      id: 'w1_emotional_1',
      domain: 'emotional',
      domainDisplayName: '마음과 관계',
      orderInDomain: 1,
      questionText:
          '예민해지는 시간이 있어도, 익숙한 안기-목소리-터치 같은 안정 루틴 뒤 진정되는 시간이 생긴다',
    ),
    ChecklistItem(
      id: 'w1_emotional_2',
      domain: 'emotional',
      domainDisplayName: '마음과 관계',
      orderInDomain: 2,
      questionText:
          '눈을 마주칠 때 표정이 부드러워지는 순간이 있다',
    ),
    // 조절-수면-생리 (regulation)
    ChecklistItem(
      id: 'w1_regulation_0',
      domain: 'regulation',
      domainDisplayName: '생활 리듬',
      orderInDomain: 0,
      questionText:
          '하품, 멍한 표정, 보채기 같은 졸림 신호가 보일 때 '
          '과하게 각성되지 않고 비교적 잠으로 전환되는 편이다',
    ),
    ChecklistItem(
      id: 'w1_regulation_1',
      domain: 'regulation',
      domainDisplayName: '생활 리듬',
      orderInDomain: 1,
      questionText:
          '수유 후 비교적 빠르게 진정되거나 잠드는 편이다',
    ),
    ChecklistItem(
      id: 'w1_regulation_2',
      domain: 'regulation',
      domainDisplayName: '생활 리듬',
      orderInDomain: 2,
      questionText:
          '울음 뒤 안아주거나 돌봐주면 다시 가라앉는 순간이 있다',
    ),
  ],
};
