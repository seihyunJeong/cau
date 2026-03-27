import 'package:flutter/material.dart';

/// 앱 전체 컬러 팔레트.
/// 디자인컴포넌트 1-1 기준. 하드코딩 금지 -- 반드시 이 상수를 참조한다.
abstract class AppColors {
  // ── 기본 컬러 ──
  static const cream = Color(0xFFFFF8F0);
  static const warmOrange = Color(0xFFF5A623);
  static const softGreen = Color(0xFF7BC67E);
  static const softYellow = Color(0xFFFFD93D);
  static const softRed = Color(0xFFFF6B6B);
  static const darkBrown = Color(0xFF3D3027);
  static const warmGray = Color(0xFF8C7B6B);

  // ── 확장 컬러 ──
  static const white = Color(0xFFFFFFFF);
  static const lightBeige = Color(0xFFF0E6D8);
  static const paleCream = Color(0xFFFFF3E8);
  static const mutedBeige = Color(0xFFC4B5A5);
  static const mintTint = Color(0xFFF0F9F0);
  static const trackGray = Color(0xFFE8DDD0);
  static const overlayBlack = Color(0x40000000);
  static const radarFill = Color(0x33F5A623);
  static const growthBand = Color(0x337BC67E);

  // 별칭 (확장 컬러와 동일 값)
  static const navWhite = white;
  static const tooltipCream = cream;

  // ── 다크 모드 ──
  static const darkBg = Color(0xFF1A1512);
  static const darkCard = Color(0xFF2A231D);
  static const darkBorder = Color(0xFF3D3027);
  static const darkTextPrimary = Color(0xFFF5EDE3);
  static const darkTextSecondary = Color(0xFFA89888);
}
