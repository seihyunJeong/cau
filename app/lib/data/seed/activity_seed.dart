import '../models/activity.dart';
import '../models/activity_step.dart';
import '../models/equipment.dart';

/// 0-1주차 + 2-3주차 활동 시드 데이터.
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

  // ── 2-3주차 (weekIndex: 1) ──
  // PDF 원고 제2장 (p.45~59) 기반

  // PDF p.45 활동 1: 깨어남 신호 릴레이
  Activity(
    id: 'w1_act1',
    weekIndex: 1,
    order: 1,
    name: '깨어남 신호 릴레이',
    type: '감각',
    description: '얼굴-목소리-손 접촉을 순서대로 보여주며 '
        '아기가 지금 어떤 감각에 반응하는지 살펴보는 활동이에요.',
    linkedReflex: '입 주변을 건드리면 고개를 돌리는 반응',
    recommendedSeconds: 20,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '먼저 보호자 얼굴을 가까이 보여주세요 (2~3초)',
        timerGuideText: '아기에게 얼굴을 가까이 보여주세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '아주 짧게 같은 문장을 말해주세요 (1문장)',
        timerGuideText: '짧고 부드러운 한 문장을 말해 주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '가슴이나 배 위에 손을 올려 접촉을 주세요 (2~3초)',
        timerGuideText: '손을 살며시 올려주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '반응을 보고 마무리하거나 한 번 더 반복하세요',
        timerGuideText: '아기의 반응을 살펴주세요',
      ),
    ],
    observationPoints: [
      '얼굴, 목소리, 손 접촉 중 무엇에 가장 잘 반응하는지',
      '어느 단계에서 몸이 더 편안해지는지',
      '세 단계 모두 하기 전에 이미 피로 신호가 나오는지',
      '깨어 있음이 유지되는지, 갑자기 짜증이 올라오는지',
    ],
    rationale: '0-1주보다 깨어 있는 시간이 아주 조금 길어질 수 있는 시기다. '
        '하지만 여전히 긴 활동은 어렵고, 짧은 감각 경험을 차례대로 연결해 주는 것이 적절하다. '
        '이 활동은 아기가 지금 깨어 있는지, 어떤 감각에 더 잘 반응하는지, '
        '어느 지점에서 피곤해지는지를 자연스럽게 살피기 위한 활동이다.',
    expectedEffects: [
      '보호자와의 짧은 상호작용 순서를 경험하는 데 도움이 된다',
      '아기의 선호 자극을 파악하는 데 유용하다',
      '수유 후, 기저귀 갈기 후, 낮잠 전 짧은 루틴으로 활용 가능하다',
      '아기의 깨어 있는 질을 관찰하기 좋다',
    ],
    cautions: [
      '단계 수를 늘리지 않는다',
      '한 번에 여러 문장을 계속 말하지 않는다',
      '손 접촉을 누르듯 하지 않는다',
      '반응이 약하다고 반복 횟수를 늘리지 않는다',
    ],
    tips: [
      '매번 같은 순서를 유지하면 더 익숙한 루틴이 된다',
      '얼굴 반응이 좋은 아기는 얼굴 시간을 조금 더, '
          '손 접촉이 좋은 아기는 마지막 접촉을 조금 더 길게 해도 좋다',
      '피곤한 날엔 한 세트만 하고 끝낸다',
    ],
    equipment: Equipment(
      isRequired: false,
      diyAlternative: '별도 교구 없이 가능해요. '
          '손 접촉 대신 가제수건을 배 위에 살짝 덮는 방식으로 변형 가능해요.',
    ),
  ),

  // PDF p.49 활동 2: 미니 시선 산책
  Activity(
    id: 'w1_act2',
    weekIndex: 1,
    order: 2,
    name: '미니 시선 산책',
    type: '시각',
    description: '보호자 얼굴이나 밝은 천을 천천히 움직여 '
        '아기의 짧은 시선 이동을 경험하게 해주는 활동이에요.',
    linkedReflex: '밝은 빛이나 얼굴 쪽으로 시선이 잠깐 머무는 반응',
    recommendedSeconds: 15,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '보호자 얼굴을 한쪽에서 보여주세요',
        timerGuideText: '아기 가까이에서 얼굴을 보여주세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '얼굴을 아주 천천히 반대쪽으로 조금 이동하세요',
        timerGuideText: '천천히 옮겨주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '또는 얼굴 -> 밝은 천 -> 다시 얼굴 순서로 보여주세요',
        timerGuideText: '순서대로 보여주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '한 번의 이동만 해도 충분하며, '
            '반응이 좋으면 한 번 더 해주세요',
        timerGuideText: '아기의 반응을 살펴주세요',
      ),
    ],
    observationPoints: [
      '시선이 시작 지점에 잠깐 머무는지',
      '중간쯤이라도 따라오려는 움직임이 있는지',
      '끝까지 따라오지 않아도 방향 전환 시도가 있는지',
      '너무 빨리 피로해지는지',
      '좌우 중 더 잘 보는 쪽이 있는지',
    ],
    rationale: '2-3주의 아기는 아직 시각 추적을 길게 하긴 어렵지만, '
        '가까운 거리에서 한 지점에서 다른 지점으로 시선이 잠깐 옮겨가는 경험은 가능할 수 있다. '
        '이 활동은 추적 훈련처럼 끝까지 보게 만드는 것이 아니라, '
        '짧고 무리 없는 범위에서 시선 이동의 시작을 경험하게 하기 위한 것이다.',
    expectedEffects: [
      '짧은 시선 이동 경험을 자연스럽게 만들 수 있다',
      '얼굴과 대비 자극 사이의 반응 차이를 살피기 좋다',
      '아기의 시각 피로도와 반응 시간을 관찰할 수 있다',
      '무리 없는 초기 주의 놀이로 활용할 수 있다',
    ],
    cautions: [
      '빠르게 흔들지 않는다',
      '장난감 여러 개를 번갈아 쓰지 않는다',
      '끝까지 따라오게 하려는 목표를 두지 않는다',
      '눈을 크게 뜬다고 무조건 좋은 상태는 아니므로 표정과 몸 상태를 함께 본다',
    ],
    tips: [
      '아침이나 낮, 조도가 안정적인 시간대에 더 잘 보일 수 있다',
      '배경이 복잡하지 않은 곳에서 진행한다',
      '왼쪽/오른쪽 반응 차이가 있으면 기록해두면 좋다',
    ],
    equipment: Equipment(
      isRequired: false,
      itemName: '밝은 천 또는 작은 흰 손수건',
      diyAlternative: '별도 시각 카드 없이 가능해요. '
          '흰 양말, 흰 거즈 손수건, 흰 종이도 사용 가능해요.',
    ),
  ),

  // PDF p.52 활동 3: 어깨-등-골반 파도안기
  Activity(
    id: 'w1_act3',
    weekIndex: 1,
    order: 3,
    name: '어깨-등-골반 파도안기',
    type: '안기',
    description: '아기를 안은 상태에서 어깨, 등, 골반을 순서대로 지지하며 '
        '어느 부위에서 더 안정되는지 살펴보는 활동이에요.',
    linkedReflex: '깜짝 놀라며 팔을 벌리는 반응',
    recommendedSeconds: 25,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '아기를 안은 상태에서 먼저 어깨와 목 쪽을 안정적으로 받쳐 주세요',
        timerGuideText: '어깨와 목을 안정적으로 받쳐주세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '그다음 등을 더 밀착되게 지지해주세요',
        timerGuideText: '등을 밀착되게 지지해주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '마지막으로 골반과 엉덩이 쪽을 더 안정감 있게 받쳐주세요',
        timerGuideText: '골반과 엉덩이를 안정적으로 받쳐주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '실제로 흔들기보다, 지지되는 중심이 바뀌는 느낌만 아주 작게 주세요',
        timerGuideText: '지지 중심을 작게 바꿔주세요',
      ),
      ActivityStep(
        stepNumber: 5,
        instruction: '반응을 보고 종료하세요',
        timerGuideText: '아기의 반응을 살펴주세요',
      ),
    ],
    observationPoints: [
      '어깨 지지 때 긴장이 줄어드는지',
      '등이 밀착될 때 숨 쉬는 모습이나 표정이 달라지는지',
      '골반 지지 후 다리 힘이 조금 풀리는지',
      '특정 지지에서 더 편안해하는지',
      '한 지지점에서는 불편해하는지',
    ],
    rationale: '아기는 안길 때 몸 전체가 한 번에 편안해지기도 하지만, '
        '실제로는 어깨, 등, 골반 중 어느 부위가 더 잘 지지될 때 안정되는지 차이가 있을 수 있다. '
        '이 활동은 흔들기보다 지지점을 순서대로 느끼게 하는 안기 활동으로, '
        '몸의 어느 부분에서 안정 반응이 더 잘 나타나는지 살피는 데 의미가 있다.',
    expectedEffects: [
      '보호자가 아기의 안정 포인트를 더 잘 알게 된다',
      '무작정 흔들지 않고도 편안한 안기 방식을 찾는 데 도움이 된다',
      '수유 후 진정, 잠 전 짧은 안정 루틴으로 활용 가능하다',
      '몸 전체의 긴장 분포를 관찰하기 좋다',
    ],
    cautions: [
      '흔들기 활동으로 변하지 않게 한다',
      '목 지지가 불안정하면 안 된다',
      '세게 쓸어내리거나 누르지 않는다',
      '불편해하는 자세를 억지로 유지하지 않는다',
    ],
    tips: [
      '낮에는 안기 루틴으로, 밤에는 잠 전 진정 루틴으로 활용 가능하다',
      '보호자마다 안는 방식이 다르면 아기 반응도 달라질 수 있어 비교 관찰이 가능하다',
      '수유 후 바로보다 트림 후 차분해졌을 때 더 적합하다',
    ],
    equipment: Equipment(
      isRequired: false,
      diyAlternative: '별도 교구 없이 가능해요. '
          '필요 시 수유쿠션 또는 팔 받침 쿠션을 활용하세요.',
    ),
  ),

  // PDF p.55 활동 4: 가슴언덕 탐험
  Activity(
    id: 'w1_act4',
    weekIndex: 1,
    order: 4,
    name: '가슴언덕 탐험',
    type: '자세',
    description: '보호자 가슴 위에 아기를 짧게 엎드린 자세로 올려 '
        '안정된 경사 환경에서 자세 경험을 해보는 활동이에요.',
    linkedReflex: '엎드리면 고개를 돌리려는 반응',
    recommendedSeconds: 15,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '보호자가 반쯤 기대어 앉으세요',
        timerGuideText: '편안하게 기대어 앉으세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '아기를 보호자 가슴 위에 엎드린 자세로 짧게 올려주세요',
        timerGuideText: '아기를 가슴 위에 올려주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '얼굴을 가까이 두고 짧게 말을 하거나 조용히 바라보세요',
        timerGuideText: '가까이에서 조용히 바라봐 주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '아기가 불편해하기 전에 바로 마무리하세요',
        timerGuideText: '아기의 반응을 살펴주세요',
      ),
    ],
    observationPoints: [
      '얼굴을 잠깐이라도 들어 보려는지',
      '팔, 어깨, 다리에 짧게 힘이 들어가는지',
      '보호자 얼굴/목소리에 반응하는지',
      '답답해하기 전 유지 가능한 시간이 어느 정도인지',
      '끝난 뒤 더 안정되는지, 피곤해하는지',
    ],
    rationale: '2-3주 무렵에는 아주 짧게라도 상체를 들어 보려는 작은 시도가 보일 수 있다. '
        '하지만 바닥에서의 엎드림을 길게 하기보다는, '
        '보호자 가슴 위처럼 체온, 냄새, 목소리, 얼굴이 함께 있는 안정된 경사 환경에서 '
        '더 편안하게 시도할 수 있다. '
        '이 활동은 고개 들기 성공이 목표가 아니라, '
        '보호자 몸 위에서 짧은 자세 경험과 관계 중심 탐색을 해보는 데 의미가 있다.',
    expectedEffects: [
      '바닥보다 정서적으로 안정된 자세 경험이 가능하다',
      '아주 짧은 상체 힘 사용을 관찰할 수 있다',
      '보호자와의 눈맞춤, 냄새, 체온을 함께 경험할 수 있다',
      'tummy time의 부담을 줄인 대안으로 활용하기 좋다',
    ],
    cautions: [
      '수유 직후 바로 하지 않는다',
      '성공적으로 고개를 들게 하려는 목표를 두지 않는다',
      '힘들어하기 시작하면 즉시 종료한다',
      '미끄러지지 않도록 보호자 손으로 몸통을 안정적으로 받친다',
    ],
    tips: [
      '낮잠 전보다 낮잠 후, 잠깐 깨어 있을 때가 더 적합하다',
      '보호자 목소리를 너무 많이 넣기보다 얼굴과 체온을 함께 느끼게 하는 것이 좋다',
      '10초만 해도 충분하며, 잘했다고 더 오래 하지 않는다',
    ],
    equipment: Equipment(
      isRequired: false,
      itemName: '등을 기대고 앉을 수 있는 소파, 침대 헤드, 등받이 의자',
      diyAlternative: '보호자 다리 위 경사 자세로도 변형 가능해요. '
          '가슴 위에 얇은 면천을 깔아 땀이나 미끄러움을 줄일 수 있어요.',
    ),
  ),

  // PDF p.57 활동 5: 발바닥 문답놀이
  Activity(
    id: 'w1_act5',
    weekIndex: 1,
    order: 5,
    name: '발바닥 문답놀이',
    type: '촉각',
    description: '발바닥을 짧게 톡 건드리고 반응을 기다리는 리듬 놀이예요. '
        '건드리고 기다리는 활동이에요.',
    linkedReflex: '발바닥을 건드리면 발가락을 오므리는 반응',
    recommendedSeconds: 20,
    steps: [
      ActivityStep(
        stepNumber: 1,
        instruction: '한쪽 발바닥을 손가락으로 아주 짧게 톡 건드려주세요',
        timerGuideText: '발바닥을 살짝 톡 건드려주세요',
      ),
      ActivityStep(
        stepNumber: 2,
        instruction: '바로 멈추고 반응을 보세요',
        timerGuideText: '잠시 멈추고 반응을 살펴주세요',
      ),
      ActivityStep(
        stepNumber: 3,
        instruction: '"여기 있네", "발이 있네"처럼 짧게 말해주세요',
        timerGuideText: '짧고 부드러운 말을 건네주세요',
      ),
      ActivityStep(
        stepNumber: 4,
        instruction: '반대쪽 발도 같은 방식으로 진행하세요',
        timerGuideText: '반대쪽 발도 같은 방식으로 해주세요',
      ),
      ActivityStep(
        stepNumber: 5,
        instruction: '괜찮으면 한 번 더 반복하세요',
        timerGuideText: '아기의 반응을 살펴주세요',
      ),
    ],
    observationPoints: [
      '발가락이 오므라드는지, 펴지는지',
      '다리가 살짝 움직이는지',
      '한쪽과 다른 쪽 반응 차이가 있는지',
      '촉각 뒤 표정이나 몸 긴장이 달라지는지',
      '너무 예민해하는지, 괜찮아하는지',
    ],
    rationale: '발바닥은 신생아가 비교적 잘 반응하는 부위 중 하나다. '
        '이 활동은 발바닥을 단순히 만지거나 마사지하는 것이 아니라, '
        '짧은 접촉-멈춤-말 걸기-다시 접촉의 구조를 만들어 '
        '아기가 촉각 뒤에 어떤 반응을 보이는지 관찰하기 위한 활동이다. '
        '즉, 자극을 많이 주는 활동이 아니라 질문하듯 건드리고 기다리는 활동이다.',
    expectedEffects: [
      '짧은 촉각 입력에 대한 하지 반응을 관찰할 수 있다',
      '좌우 차이를 가볍게 살피기 좋다',
      '몸 전체보다 국소 부위부터 반응을 보는 데 적합하다',
      '보호자와의 짧은 리듬 놀이로 활용 가능하다',
    ],
    cautions: [
      '세게 누르지 않는다',
      '계속 반복해 간지럽히지 않는다',
      '발이 차갑거나 아기가 몸 전체로 예민하면 피한다',
      '발을 억지로 펴거나 잡아당기지 않는다',
    ],
    tips: [
      '기저귀 갈기 전후, 목욕 후, 옷 갈아입기 전 짧게 하기 좋다',
      '한쪽씩 비교해보는 기록 활동으로도 좋다',
      '목소리를 크게 넣기보다 짧고 동일한 말이 더 적합하다',
    ],
    equipment: Equipment(
      isRequired: false,
      diyAlternative: '별도 교구 없이 가능해요. '
          '보호자의 따뜻한 손이면 충분해요.',
    ),
  ),
];

/// 주차 인덱스에 해당하는 활동 목록을 반환한다.
List<Activity> getActivitiesForWeek(int weekIndex) {
  return activitySeed.where((a) => a.weekIndex == weekIndex).toList();
}
