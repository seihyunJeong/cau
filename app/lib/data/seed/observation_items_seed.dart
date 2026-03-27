import '../models/observation_item.dart';

/// 1단계 관찰 항목 시드 데이터 (활동 직후 모습).
/// 개발기획서 8-8 기준.
/// 핵심 4항목(인덱스 0~3)은 기본 노출, 나머지 3항목(4~6)은 접힌 상태.
const _step1Items = <ObservationItem>[
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

/// 2단계 관찰 항목 시드 데이터 (자연 반응 관찰).
/// 개발기획서 8-8 기준.
/// 각 항목에 InfoTerm 툴팁이 적용된다 (전문 용어 설명).
const _step2Items = <ObservationItem>[
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

/// 1단계 전체 관찰 항목(7개)을 반환한다.
List<ObservationItem> getObservationStep1Items() =>
    List.unmodifiable(_step1Items);

/// 1단계 핵심 4항목(인덱스 0~3)을 반환한다.
/// 기본 노출되는 항목들.
List<ObservationItem> getObservationStep1CoreItems() =>
    List.unmodifiable(_step1Items.sublist(0, 4));

/// 1단계 나머지 3항목(인덱스 4~6)을 반환한다.
/// "나머지 항목 더 보기" ExpansionTile에서 노출된다.
List<ObservationItem> getObservationStep1ExtraItems() =>
    List.unmodifiable(_step1Items.sublist(4));

/// 2단계 전체 관찰 항목(7개)을 반환한다.
List<ObservationItem> getObservationStep2Items() =>
    List.unmodifiable(_step2Items);
