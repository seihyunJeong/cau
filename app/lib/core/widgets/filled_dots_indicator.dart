import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// 채워진 도트 인디케이터 위젯 (디자인컴포넌트 2-5-4).
/// 점수를 채워진 도트(softGreen, 8dp 원형)로 시각화한다.
/// 빈 도트는 표시하지 않는다 (채워진 도트만 표시).
class FilledDotsIndicator extends StatelessWidget {
  /// 채울 도트 수 (0~maxDots).
  final int filledCount;

  /// 최대 도트 수 (기본 4).
  final int maxDots;

  const FilledDotsIndicator({
    super.key,
    required this.filledCount,
    this.maxDots = 4,
  });

  @override
  Widget build(BuildContext context) {
    // 점수를 도트 개수로 매핑 (12점 만점 기준: 0~3=1, 4~6=2, 7~9=3, 10~12=4)
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(filledCount.clamp(0, maxDots), (index) {
        return Padding(
          padding: EdgeInsets.only(
            right: index < filledCount - 1 ? AppDimensions.xs : 0,
          ),
          child: Container(
            width: AppDimensions.sm,
            height: AppDimensions.sm,
            decoration: const BoxDecoration(
              color: AppColors.softGreen,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  /// 12점 만점 영역 점수를 도트 수(0~4)로 변환한다.
  static int scoreToDots(int domainScore) {
    if (domainScore >= 10) return 4;
    if (domainScore >= 7) return 3;
    if (domainScore >= 4) return 2;
    if (domainScore >= 1) return 1;
    return 0;
  }
}
