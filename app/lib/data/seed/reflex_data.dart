import '../../core/constants/app_strings.dart';

/// 연결 반사 매핑 데이터.
/// 부모 언어(parentLabel) -> 전문 용어명(termName), 설명(description) 매핑.
/// activity_detail_screen의 InfoTerm에서 참조한다.
class ReflexData {
  const ReflexData._();

  /// 부모 언어 -> 전문 용어명 매핑.
  static const termNameMapping = <String, String>{
    // 0-1주차 활동 linkedReflex
    '깜짝 놀라며 팔을 벌리는 반응': '모로반사 (Moro Reflex)',
    '손바닥을 건드리면 꽉 쥐는 반응': '파악반사 (Palmar Grasp Reflex)',
    '소리가 나는 쪽으로 고개를 돌리는 반응': '청각 정위 반응 (Auditory Orientation)',
    '밝은 빛을 향해 고개를 돌리는 반응': '광반사 (Light Reflex)',
    '엎드리면 고개를 돌리려는 반응': '보호 반사 (Protective Reflex)',
    // 2-3주차 활동 linkedReflex 추가
    '입 주변을 건드리면 고개를 돌리는 반응': '탐색반사 (Rooting Reflex)',
    '밝은 빛이나 얼굴 쪽으로 시선이 잠깐 머무는 반응':
        '시각적 주의 반응 (Visual Attention)',
    '발바닥을 건드리면 발가락을 오므리는 반응': '족저반사 (Plantar Reflex)',
  };

  /// 부모 언어 -> 설명 매핑.
  static const descriptionMapping = <String, String>{
    // 0-1주차 활동 linkedReflex
    '깜짝 놀라며 팔을 벌리는 반응':
        '갑작스러운 소리나 움직임에 놀라 양팔을 벌렸다가 모으는 자연스러운 반응이에요. '
            '생후 3-4개월에 자연스럽게 사라져요.',
    '손바닥을 건드리면 꽉 쥐는 반응':
        '손바닥에 무언가가 닿으면 반사적으로 꽉 쥐는 반응이에요. '
            '생후 5-6개월에 점차 줄어들어요.',
    '소리가 나는 쪽으로 고개를 돌리는 반응':
        '소리 자극에 반응하여 소리 나는 방향으로 고개를 돌리는 반응이에요. '
            '청각 발달의 중요한 지표예요.',
    '밝은 빛을 향해 고개를 돌리는 반응':
        '밝은 빛에 반응하여 동공이 수축하는 반사 반응이에요. '
            '시각 신경 발달의 기초가 돼요.',
    '엎드리면 고개를 돌리려는 반응':
        '엎드린 상태에서 기도를 확보하기 위해 고개를 돌리려는 보호 반사예요. '
            '목 근육 발달의 시작이에요.',
    // 2-3주차 활동 linkedReflex 추가
    '입 주변을 건드리면 고개를 돌리는 반응':
        '입 주변을 건드리면 그 방향으로 고개를 돌리고 입을 벌리는 반응이에요. '
            '먹기 위한 본능적인 반사로, 생후 3-4개월에 줄어들어요.',
    '밝은 빛이나 얼굴 쪽으로 시선이 잠깐 머무는 반응':
        '가까운 거리(20~30cm)에서 얼굴이나 밝은 대비 자극에 시선이 잠깐 머무는 반응이에요. '
            '아직 추적은 어렵지만, 주의의 시작이에요.',
    '발바닥을 건드리면 발가락을 오므리는 반응':
        '발바닥을 건드리면 발가락을 오므리는 반응이에요. '
            '생후 9-12개월에 점차 줄어들어요.',
  };

  /// 부모 언어로부터 전문 용어명을 반환한다.
  static String getTermName(String parentLabel) {
    return termNameMapping[parentLabel] ?? parentLabel;
  }

  /// 부모 언어로부터 설명을 반환한다.
  static String getDescription(String parentLabel) {
    return descriptionMapping[parentLabel] ??
        AppStrings.reflexDefaultDescription;
  }
}
