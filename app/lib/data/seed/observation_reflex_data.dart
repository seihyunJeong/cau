/// 2단계 관찰 항목(자연 반응)의 전문 용어 매핑 데이터.
/// InfoTerm 위젯에서 참조한다.
class ObservationReflexData {
  ObservationReflexData._();

  /// 항목 ID -> 전문 용어명 매핑.
  static const _termNameMapping = <String, String>{
    'obs_s2_moro': '모로반사 (Moro Reflex)',
    'obs_s2_rooting': '탐색반사 (Rooting Reflex)',
    'obs_s2_palmar': '파악반사 (Palmar Grasp Reflex)',
    'obs_s2_plantar': '족저반사 (Plantar Reflex)',
    'obs_s2_stepping': '보행반사 (Stepping Reflex)',
    'obs_s2_suck': '빨기반사 (Sucking Reflex)',
    'obs_s2_tonic': '긴장목반사 (Tonic Neck Reflex)',
  };

  /// 항목 ID -> 설명 매핑.
  static const _descriptionMapping = <String, String>{
    'obs_s2_moro':
        '갑작스러운 소리나 움직임에 놀라 양팔을 벌렸다가 모으는 자연스러운 반응이에요. '
            '생후 3-4개월에 자연스럽게 사라져요.',
    'obs_s2_rooting':
        '입 주변을 건드리면 그 방향으로 고개를 돌리고 입을 벌리는 반응이에요. '
            '먹기 위한 본능적인 반사로, 생후 3-4개월에 줄어들어요.',
    'obs_s2_palmar':
        '손바닥에 무언가가 닿으면 반사적으로 꽉 쥐는 반응이에요. '
            '생후 5-6개월에 점차 줄어들어요.',
    'obs_s2_plantar':
        '발바닥을 건드리면 발가락을 오므리는 반응이에요. '
            '생후 9-12개월에 점차 줄어들어요.',
    'obs_s2_stepping':
        '아기를 세워서 발이 바닥에 닿으면 걷는 듯한 움직임을 보이는 반응이에요. '
            '생후 2개월 정도에 사라졌다가 나중에 걷기로 발전해요.',
    'obs_s2_suck':
        '입에 무언가가 닿으면 반사적으로 빠는 반응이에요. '
            '수유와 직결되는 중요한 반사로, 생후 3-4개월에 자발적 빨기로 전환돼요.',
    'obs_s2_tonic':
        '고개를 한쪽으로 돌리면 같은 쪽 팔다리를 펴고 반대쪽은 구부리는 반응이에요. '
            '생후 5-7개월에 자연스럽게 사라져요.',
  };

  /// 항목 ID로부터 전문 용어명을 반환한다.
  static String getTermName(String itemId) {
    return _termNameMapping[itemId] ?? itemId;
  }

  /// 항목 ID로부터 설명을 반환한다.
  static String getDescription(String itemId) {
    return _descriptionMapping[itemId] ??
        '이 반응은 아기의 자연스러운 발달 과정의 일부예요.';
  }
}
