import 'package:flutter/material.dart';

/// 앱 전체 그림자/엘리베이션 토큰.
/// 디자인컴포넌트 1-5 기준. 그림자를 최소화하여 부드럽고 안정적인 느낌 유지.
abstract class AppShadows {
  /// 가장 약한 그림자. 인라인 카드, 보조 요소용.
  static const subtle = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// 기본 카드 그림자. 카드 존재감 확보를 위해 강도 증가.
  static const low = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const high = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 16,
      offset: Offset(0, -2),
    ),
  ];
}
