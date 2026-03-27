import '../models/activity.dart';
import '../models/activity_step.dart';
import '../models/equipment.dart';

/// 0-1주차 활동 시드 데이터.
/// 개발기획서 8-2, 8-8 기준. 전체 필드 포함.
const List<Activity> activitySeed = [
  // ── 0-1주차 (weekIndex: 0) ──

  // 활동 1: 품-숨-멈춤 루틴
  Activity(
    id: 'w0_act1',
    weekIndex: 0,
    order: 1,
    name: '품-숨-멈춤 루틴',
    type: '안기',
    description: '아기를 품에 안고 천천히 숨을 쉬며 '
        '잠시 멈추는 루틴이에요. '
        '부모의 심장 소리가 아기를 안정시켜요.',
    linkedReflex: '깜짝 놀라며 팔을 벌리는 반응',
    recommendedSeconds: 30,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '아기를 편안하게 안아주세요',
        timerGuideText: '아기를 가슴에 대고 양손으로 감싸주세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '5초간 조용히 숨을 내쉬세요',
        timerGuideText: '코로 천천히 숨을 내쉬어 주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '3초간 멈춰주세요',
        timerGuideText: '조용히 멈춰주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '다시 반복해주세요',
      ),
      ActivityStep(
        stepNumber: 5,
        instruction: '아기 반응을 살펴보세요',
        timerGuideText: '아기의 표정과 몸을 관찰해 주세요',
      ),
    ],
    observationPoints: [
      '팔을 벌리는 반응이 보이나요?',
      '안았을 때 몸이 이완되나요?',
      '숨소리가 편안해졌나요?',
    ],
    rationale: '아기의 뇌와 몸이 안정을 배우는 과정을 도와줘요. '
        '부모의 심장 소리와 체온이 아기에게 가장 편안한 안정제가 돼요.',
    expectedEffects: [
      '아기의 안정감 향상',
      '부모-아기 유대 강화',
      '수면 패턴 안정화',
    ],
    cautions: [
      '수유 직후에는 피해주세요',
      '아기가 싫어하면 즉시 멈춰주세요',
    ],
    tips: [
      '매일 같은 시간에 하면 아기가 익숙해져요',
    ],
    equipment: Equipment(
      isRequired: false,
      diyAlternative: '별도 교구 없이 가능. 얇은 담요 1장이면 충분해요.',
    ),
  ),

  // 활동 2: 손바닥 감싸기
  Activity(
    id: 'w0_act2',
    weekIndex: 0,
    order: 2,
    name: '손바닥 감싸기',
    type: '감각',
    description: '아기의 작은 손을 부드럽게 감싸주세요. '
        '따뜻한 체온이 전해지면 아기가 편안해져요.',
    linkedReflex: '손바닥을 건드리면 꽉 쥐는 반응',
    recommendedSeconds: 20,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '아기의 손바닥을 부드럽게 펴주세요',
        timerGuideText: '아기의 손을 살며시 열어주세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '손가락으로 아기 손바닥을 천천히 쓸어주세요',
        timerGuideText: '부드럽게 쓸어주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '아기 손을 양손으로 감싸주세요',
        timerGuideText: '따뜻하게 감싸주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '잠시 멈추고 아기의 반응을 살펴보세요',
        timerGuideText: '아기의 손에 집중해 주세요',
      ),
      ActivityStep(
        stepNumber: 5,
        instruction: '반대쪽 손도 같은 방법으로 해주세요',
      ),
    ],
    observationPoints: [
      '손가락을 쥐는 반응이 보이나요?',
      '손을 감쌌을 때 편안해 보이나요?',
      '양쪽 손의 반응이 비슷한가요?',
    ],
    rationale: '촉각 자극은 아기의 신경 발달에 중요한 역할을 해요. '
        '손바닥 감싸기는 파악 반사를 자연스럽게 관찰할 수 있는 활동이에요.',
    expectedEffects: [
      '촉각 자극을 통한 신경 발달',
      '파악 반사 관찰',
      '부모-아기 스킨십 강화',
    ],
    cautions: [
      '너무 세게 잡지 마세요',
      '손톱이 길면 미리 정리해주세요',
    ],
    tips: [
      '목욕 후나 수유 전 편안한 시간에 해보세요',
      '양쪽 손을 번갈아 해보세요',
    ],
    equipment: Equipment(
      isRequired: false,
      diyAlternative: '별도 교구 없이 가능해요.',
    ),
  ),

  // 활동 3: 부드러운 목소리 들려주기
  Activity(
    id: 'w0_act3',
    weekIndex: 0,
    order: 3,
    name: '부드러운 목소리 들려주기',
    type: '소리',
    description: '아기에게 부드러운 목소리로 이야기해주세요. '
        '익숙한 부모의 목소리는 최고의 자장가예요.',
    linkedReflex: '소리가 나는 쪽으로 고개를 돌리는 반응',
    recommendedSeconds: 30,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '아기와 20-30cm 거리에서 마주 보세요',
        timerGuideText: '아기 가까이 얼굴을 가져가세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '부드러운 목소리로 아기 이름을 불러주세요',
        timerGuideText: '이름을 천천히 불러주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '짧은 노래를 불러주거나 이야기해주세요',
        timerGuideText: '편안한 목소리로 이야기해 주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '잠시 멈추고 아기의 반응을 기다려주세요',
        timerGuideText: '아기의 반응을 살펴주세요',
      ),
      ActivityStep(
        stepNumber: 5,
        instruction: '반응이 있으면 다시 한번 이야기해주세요',
      ),
    ],
    observationPoints: [
      '소리 나는 쪽으로 고개를 돌리나요?',
      '목소리를 들을 때 움직임이 멈추나요?',
      '표정이 변하나요?',
    ],
    rationale: '태내에서부터 익숙한 부모의 목소리는 아기에게 안정감을 줘요. '
        '청각 자극은 뇌 발달과 언어 발달의 기초가 돼요.',
    expectedEffects: [
      '청각 자극을 통한 뇌 발달',
      '언어 발달의 기초',
      '정서적 안정감',
    ],
    cautions: [
      '너무 큰 소리는 피해주세요',
      '자고 있을 때는 하지 않아도 돼요',
    ],
    tips: [
      '매일 같은 노래를 반복하면 아기가 익숙해져요',
      '높은 톤의 목소리에 더 잘 반응해요',
    ],
    equipment: Equipment(
      isRequired: false,
      diyAlternative: '별도 교구 없이 가능해요.',
    ),
  ),

  // 활동 4: 눈 맞추기
  Activity(
    id: 'w0_act4',
    weekIndex: 0,
    order: 4,
    name: '눈 맞추기',
    type: '시각',
    description: '아기와 20-30cm 거리에서 눈을 맞춰보세요. '
        '아직 초점이 잘 안 맞지만, 부모의 얼굴을 느끼고 있어요.',
    linkedReflex: '밝은 빛을 향해 고개를 돌리는 반응',
    recommendedSeconds: 15,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '아기를 편안한 자세로 눕혀주세요',
        timerGuideText: '아기를 편안하게 해주세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '20-30cm 거리에서 아기의 눈을 바라봐주세요',
        timerGuideText: '아기와 눈을 맞춰주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '천천히 고개를 좌우로 움직여보세요',
        timerGuideText: '천천히 움직여주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '아기가 시선을 따라가는지 살펴보세요',
      ),
      ActivityStep(
        stepNumber: 5,
        instruction: '미소를 지으며 부드럽게 이야기해주세요',
        timerGuideText: '미소를 지어주세요',
      ),
    ],
    observationPoints: [
      '부모의 얼굴을 잠깐이라도 바라보나요?',
      '움직임을 따라 시선이 움직이나요?',
      '밝은 빛에 반응하나요?',
    ],
    rationale: '신생아의 시력은 20-30cm 거리에서 가장 잘 보여요. '
        '부모의 얼굴은 아기가 가장 좋아하는 시각 자극이에요.',
    expectedEffects: [
      '시각 발달 촉진',
      '사회적 상호작용의 시작',
      '부모 얼굴 인식 발달',
    ],
    cautions: [
      '너무 밝은 곳은 피해주세요',
      '아기가 고개를 돌리면 쉬어주세요',
    ],
    tips: [
      '자연광이 들어오는 부드러운 조명에서 해보세요',
      '흑백 대비가 강한 옷을 입으면 더 잘 볼 수 있어요',
    ],
    equipment: Equipment(
      isRequired: false,
      diyAlternative: '별도 교구 없이 가능해요.',
    ),
  ),

  // 활동 5: 배 위에 얹기
  Activity(
    id: 'w0_act5',
    weekIndex: 0,
    order: 5,
    name: '배 위에 얹기',
    type: '안기',
    description: '부모의 배 위에 아기를 조심스럽게 얹어보세요. '
        '따뜻한 체온과 호흡이 아기를 안정시켜요.',
    linkedReflex: '엎드리면 고개를 돌리려는 반응',
    recommendedSeconds: 20,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '부모가 편안하게 누워주세요',
        timerGuideText: '편안한 자세를 잡아주세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '아기를 배 위에 조심스럽게 얹어주세요',
        timerGuideText: '아기를 살며시 올려주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '양손으로 아기를 안전하게 잡아주세요',
        timerGuideText: '아기를 안전하게 잡아주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '천천히 숨을 쉬며 아기와 함께 호흡해주세요',
        timerGuideText: '함께 호흡해 주세요',
      ),
      ActivityStep(
        stepNumber: 5,
        instruction: '아기의 반응을 관찰해주세요',
      ),
    ],
    observationPoints: [
      '배 위에서 고개를 들려고 하나요?',
      '체온을 느끼며 편안해 보이나요?',
      '호흡이 안정적인가요?',
    ],
    rationale: '부모의 체온과 호흡은 아기에게 자궁 속 환경을 떠올리게 해요. '
        '피부 접촉은 옥시토신 분비를 촉진해 유대감을 높여줘요.',
    expectedEffects: [
      '피부 접촉을 통한 안정감',
      '목 근육 발달 시작',
      '부모-아기 유대 강화',
    ],
    cautions: [
      '수유 직후에는 피해주세요',
      '절대 잠들지 않도록 주의해주세요',
      '항상 아기의 얼굴이 옆으로 향하도록 해주세요',
    ],
    tips: [
      '아빠의 넓은 배 위에서 더 안정적이에요',
      '낮은 목소리로 이야기하면서 하면 더 좋아요',
    ],
    equipment: Equipment(
      isRequired: false,
      diyAlternative: '별도 교구 없이 가능. 얇은 담요를 깔아주면 더 편해요.',
    ),
  ),
];

/// 주차 인덱스에 해당하는 활동 목록을 반환한다.
List<Activity> getActivitiesForWeek(int weekIndex) {
  return activitySeed.where((a) => a.weekIndex == weekIndex).toList();
}
