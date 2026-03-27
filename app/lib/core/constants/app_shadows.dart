import 'package:flutter/material.dart';

/// 앱 전체 그림자/엘리베이션 토큰.
/// 디자인컴포넌트 1-5 기준. 그림자를 최소화하여 부드럽고 안정적인 느낌 유지.
abstract class AppShadows {
  static const low = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 1),
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
