import '../models/observation_item.dart';

/// 0-1주차 1단계 관찰 항목 시드 데이터 (활동 직후 모습).
/// 개발기획서 8-8 기준.
/// 핵심 4항목(인덱스 0~3)은 기본 노출, 나머지 3항목(4~6)은 접힌 상태.
const _step1ItemsWeek0 = <ObservationItem>[
  ObservationItem(
    id: 'obs_s1_0',
    step: 1,
    text: '활동 후 편안해 보였어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'obs_s1_1',
    step: 1,
    text: '표정이 부드러워졌어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'obs_s1_2',
    step: 1,
    text: '몸이 이완되었어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'obs_s1_3',
    step: 1,
    text: '호흡이 안정적이었어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'obs_s1_4',
    step: 1,
    text: '울음이 줄었어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'obs_s1_5',
    step: 1,
    text: '활동에 반응을 보였어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'obs_s1_6',
    step: 1,
    text: '수면으로 잘 전환되었어요',
    options: ['예', '보통', '아니오'],
  ),
];

/// 0-1주차 2단계 관찰 항목 시드 데이터 (자연 반응 관찰).
/// 개발기획서 8-8 기준.
/// 각 항목에 InfoTerm 툴팁이 적용된다 (전문 용어 설명).
const _step2ItemsWeek0 = <ObservationItem>[
  ObservationItem(
    id: 'obs_s2_moro',
    step: 2,
    text: '깜짝 놀라며 팔을 벌리는 반응',
    options: ['뚜렷함', '약하게', '잘 안 보임'],
  ),
  ObservationItem(
    id: 'obs_s2_rooting',
    step: 2,
    text: '입 주변을 건드리면 고개를 돌리는 반응',
    options: ['뚜렷함', '약하게', '잘 안 보임'],
  ),
  ObservationItem(
    id: 'obs_s2_palmar',
    step: 2,
    text: '손바닥을 건드리면 꽉 쥐는 반응',
    options: ['뚜렷함', '약하게', '잘 안 보임'],
  ),
  ObservationItem(
    id: 'obs_s2_plantar',
    step: 2,
    text: '발바닥을 건드리면 발가락을 오므리는 반응',
    options: ['뚜렷함', '약하게', '잘 안 보임'],
  ),
  ObservationItem(
    id: 'obs_s2_stepping',
    step: 2,
    text: '세워주면 걷는 듯한 움직임',
    options: ['뚜렷함', '약하게', '잘 안 보임'],
  ),
  ObservationItem(
    id: 'obs_s2_suck',
    step: 2,
    text: '빨기 반응',
    options: ['뚜렷함', '약하게', '잘 안 보임'],
  ),
  ObservationItem(
    id: 'obs_s2_tonic',
    step: 2,
    text: '고개를 돌리면 같은 쪽 팔다리를 펴는 반응',
    options: ['뚜렷함', '약하게', '잘 안 보임'],
  ),
];

/// 2-3주차 1단계 관찰 항목 시드 데이터 (활동 직후 전체 상태 관찰).
/// PDF p.60~64 "부록 2. 2-3주 활동 후 자연 반응 관찰표" 기반.
/// 0-1주차(7항목)에서 확장된 8항목.
const _step1ItemsWeek1 = <ObservationItem>[
  ObservationItem(
    id: 'w1_obs_s1_0',
    step: 1,
    text: '활동 후 몸이 조금 더 편안해 보였어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'w1_obs_s1_1',
    step: 1,
    text: '얼굴 표정이 조금 더 부드러워졌어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'w1_obs_s1_2',
    step: 1,
    text: '울음이나 찡그림이 줄어들었어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'w1_obs_s1_3',
    step: 1,
    text: '팔-다리-어깨의 긴장이 조금 풀린 것 같아요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'w1_obs_s1_4',
    step: 1,
    text: '얼굴을 돌리거나 피하려는 신호가 보였어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'w1_obs_s1_5',
    step: 1,
    text: '활동 후 너무 피곤해 보였어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'w1_obs_s1_6',
    step: 1,
    text: '활동 직후 잠깐이라도 깨어 있는 반응이 유지되었어요',
    options: ['예', '보통', '아니오'],
  ),
  ObservationItem(
    id: 'w1_obs_s1_7',
    step: 1,
    text: '안았을 때 또는 손을 얹었을 때 차분해지는 모습이 있었어요',
    options: ['예', '보통', '아니오'],
  ),
];

/// 2-3주차 2단계 관찰 항목 시드 데이터 (자연 반응 관찰).
/// PDF p.60~64 기반.
/// 0-1주차(7항목)에서 시각적 주의/청각-사회적/자세 후 안정/하지 반응 추가,
/// 보행반사 제외하여 8항목.
const _step2ItemsWeek1 = <ObservationItem>[
  ObservationItem(
    id: 'w1_obs_s2_moro',
    step: 2,
    text: '깜짝 놀라며 팔이 벌어지는 모습이 있었어요',
    options: ['뚜렷함', '약하게 보임', '잘 안보임'],
  ),
  ObservationItem(
    id: 'w1_obs_s2_rooting',
    step: 2,
    text: '입 주변 자극에 얼굴이나 입이 반응했어요',
    options: ['뚜렷함', '약하게 보임', '잘 안보임'],
  ),
  ObservationItem(
    id: 'w1_obs_s2_palmar',
    step: 2,
    text: '손바닥 자극에 손을 쥐는 모습이 있었어요',
    options: ['뚜렷함', '약하게 보임', '잘 안보임'],
  ),
  ObservationItem(
    id: 'w1_obs_s2_visual',
    step: 2,
    text: '얼굴이나 밝은 물체 쪽으로 시선이 잠깐 머물렀어요',
    options: ['뚜렷함', '약하게 보임', '잘 안보임'],
  ),
  ObservationItem(
    id: 'w1_obs_s2_auditory',
    step: 2,
    text: '목소리 뒤에 표정, 입, 몸 움직임이 잠깐 달라졌어요',
    options: ['뚜렷함', '약하게 보임', '잘 안보임'],
  ),
  ObservationItem(
    id: 'w1_obs_s2_posture',
    step: 2,
    text: '안기거나 자세를 바꾼 뒤 몸이 조금 더 안정되는 모습이 있었어요',
    options: ['뚜렷함', '약하게 보임', '잘 안보임'],
  ),
  ObservationItem(
    id: 'w1_obs_s2_plantar',
    step: 2,
    text: '발이나 다리 자극 뒤 다리 움직임이 있었어요',
    options: ['뚜렷함', '약하게 보임', '잘 안보임'],
  ),
  ObservationItem(
    id: 'w1_obs_s2_tonic',
    step: 2,
    text: '고개를 돌리면 같은 쪽 팔다리를 펴는 반응',
    options: ['뚜렷함', '약하게 보임', '잘 안보임'],
  ),
];

/// 주차별 1단계 관찰 항목 Map.
const _step1ItemsByWeek = <int, List<ObservationItem>>{
  0: _step1ItemsWeek0,
  1: _step1ItemsWeek1,
};

/// 주차별 2단계 관찰 항목 Map.
const _step2ItemsByWeek = <int, List<ObservationItem>>{
  0: _step2ItemsWeek0,
  1: _step2ItemsWeek1,
};

/// 1단계 전체 관찰 항목을 반환한다.
/// [weekIndex] 파라미터로 주차별 분기. 기본값 0 (하위 호환).
List<ObservationItem> getObservationStep1Items({int weekIndex = 0}) =>
    List.unmodifiable(
      _step1ItemsByWeek[weekIndex] ?? _step1ItemsWeek0,
    );

/// 1단계 핵심 4항목(인덱스 0~3)을 반환한다.
/// 기본 노출되는 항목들.
List<ObservationItem> getObservationStep1CoreItems({int weekIndex = 0}) {
  final items = _step1ItemsByWeek[weekIndex] ?? _step1ItemsWeek0;
  return List.unmodifiable(items.sublist(0, 4));
}

/// 1단계 나머지 항목(인덱스 4~)을 반환한다.
/// "나머지 항목 더 보기" ExpansionTile에서 노출된다.
List<ObservationItem> getObservationStep1ExtraItems({int weekIndex = 0}) {
  final items = _step1ItemsByWeek[weekIndex] ?? _step1ItemsWeek0;
  return List.unmodifiable(items.sublist(4));
}

/// 2단계 전체 관찰 항목을 반환한다.
/// [weekIndex] 파라미터로 주차별 분기. 기본값 0 (하위 호환).
List<ObservationItem> getObservationStep2Items({int weekIndex = 0}) =>
    List.unmodifiable(
      _step2ItemsByWeek[weekIndex] ?? _step2ItemsWeek0,
    );
