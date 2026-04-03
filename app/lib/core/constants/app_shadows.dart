import 'package:flutter/material.dart';

/// 앱 전체 그림자/엘리베이션 토큰.
/// 디자인컴포넌트 1-5 기준. 그림자를 최소화하여 부드럽고 안정적인 느낌 유지.
/// 다크 모드에서는 밝은 색상 기반 subtle glow로 카드 간 깊이감을 표현한다.
abstract class AppShadows {
  // ── 라이트 모드 ──

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

  // ── 다크 모드 ──
  // 밝은 색상 기반 subtle glow로 카드 깊이감을 표현.
  // 검은색 그림자 대신 warmOrange/cream 계열의 미세한 발광 효과.

  /// 다크 모드 subtle: 미세한 warm glow.
  static const darkSubtle = [
    BoxShadow(
      color: Color(0x0AFFF8F0), // cream 4% alpha
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// 다크 모드 low: 카드 기본 glow.
  static const darkLow = [
    BoxShadow(
      color: Color(0x0DFFF8F0), // cream 5% alpha
      blurRadius: 6,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x1A000000), // 보강용 ambient shadow
      blurRadius: 8,
      offset: Offset(0, 3),
    ),
  ];

  /// 다크 모드 medium: 히어로 카드 glow.
  static const darkMedium = [
    BoxShadow(
      color: Color(0x12F5A623), // warmOrange 7% alpha glow
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x20000000), // ambient shadow
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  /// 다크 모드 high: 하단 고정 영역 glow.
  static const darkHigh = [
    BoxShadow(
      color: Color(0x18F5A623), // warmOrange 9% alpha glow
      blurRadius: 20,
      offset: Offset(0, -2),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 16,
      offset: Offset(0, -4),
    ),
  ];

  /// 모드에 따라 적절한 그림자를 반환하는 헬퍼.
  static List<BoxShadow> adaptiveSubtle(bool isDark) =>
      isDark ? darkSubtle : subtle;

  static List<BoxShadow> adaptiveLow(bool isDark) =>
      isDark ? darkLow : low;

  static List<BoxShadow> adaptiveMedium(bool isDark) =>
      isDark ? darkMedium : medium;

  static List<BoxShadow> adaptiveHigh(bool isDark) =>
      isDark ? darkHigh : high;
}
