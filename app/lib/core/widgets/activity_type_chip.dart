import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

/// 활동 유형 칩 (2-3-9).
/// 디자인컴포넌트 2-3-9 기준.
/// 활동 영역별 색상을 자동 매핑한다 (안기=로즈핑크, 감각=그린 등).
class ActivityTypeChip extends StatelessWidget {
  final String type;

  const ActivityTypeChip({
    super.key,
    required this.type,
  });

  /// 활동 유형 문자열에서 영역별 전경색(텍스트/아이콘)을 반환한다.
  static Color domainColor(String type) {
    switch (type) {
      case '안기':
        return AppColors.domainHolding;
      case '감각':
        return AppColors.domainSensory;
      case '소리':
        return AppColors.domainSound;
      case '시각':
        return AppColors.domainVision;
      case '촉각':
        return AppColors.domainTouch;
      case '자세':
        return AppColors.domainBalance;
      default:
        return AppColors.warmOrange;
    }
  }

  /// 활동 유형 문자열에서 영역별 배경색을 반환한다.
  static Color domainBgColor(String type) {
    switch (type) {
      case '안기':
        return AppColors.domainHoldingBg;
      case '감각':
        return AppColors.domainSensoryBg;
      case '소리':
        return AppColors.domainSoundBg;
      case '시각':
        return AppColors.domainVisionBg;
      case '촉각':
        return AppColors.domainTouchBg;
      case '자세':
        return AppColors.domainBalanceBg;
      default:
        return AppColors.paleCream;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fgColor = domainColor(type);
    final bgColor = domainBgColor(type);

    return Container(
      key: const ValueKey('activity_type_chip'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
