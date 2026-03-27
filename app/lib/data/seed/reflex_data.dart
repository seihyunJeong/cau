import '../../core/constants/app_strings.dart';

/// 연결 반사 매핑 데이터.
/// 부모 언어(parentLabel) -> 전문 용어명(termName), 설명(description) 매핑.
/// activity_detail_screen의 InfoTerm에서 참조한다.
class ReflexData {
  const ReflexData._();

  /// 부모 언어 -> 전문 용어명 매핑.
  static const termNameMapping = <String, String>{
    '깜짝 놀라며 팔을 벌리는 반응': '모로반사 (Moro Reflex)',
    '손바닥을 건드리면 꽉 쥐는 반응': '파악반사 (Palmar Grasp Reflex)',
    '소리가 나는 쪽으로 고개를 돌리는 반응': '청각 정위 반응 (Auditory Orientation)',
    '밝은 빛을 향해 고개를 돌리는 반응': '광반사 (Light Reflex)',
    '엎드리면 고개를 돌리려는 반응': '보호 반사 (Protective Reflex)',
  };

  /// 부모 언어 -> 설명 매핑.
  static const descriptionMapping = <String, String>{
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
