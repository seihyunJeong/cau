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

  // ── 활동 영역 컬러 ──
  // 6개 발달 영역별 시맨틱 컬러. 기존 warmOrange 톤과 조화로운 파스텔/소프트 톤.
  static const domainHolding = Color(0xFFE8A0BF);   // 안기 -- 따뜻한 로즈핑크
  static const domainSensory = Color(0xFF7BC67E);    // 감각 -- 소프트 그린
  static const domainSound = Color(0xFF7EB8DA);      // 소리 -- 소프트 스카이블루
  static const domainVision = Color(0xFFB49ADB);     // 시각 -- 소프트 라벤더
  static const domainTouch = Color(0xFFF5A623);      // 촉각 -- warmOrange 유지
  static const domainBalance = Color(0xFFE8C86A);    // 자세/균형 -- 소프트 골드

  // 각 영역의 연한 배경 (칩/카드용)
  static const domainHoldingBg = Color(0xFFFCF0F5);
  static const domainSensoryBg = Color(0xFFF0F9F0);
  static const domainSoundBg = Color(0xFFF0F5FA);
  static const domainVisionBg = Color(0xFFF5F0FA);
  static const domainTouchBg = Color(0xFFFFF3E8);
  static const domainBalanceBg = Color(0xFFFFF8E8);

  // ── 상태 컬러 (시맨틱) ──
  static const info = Color(0xFF7EB8DA);          // 정보 -- 소프트 블루
  static const infoBg = Color(0xFFF0F5FA);        // 정보 배경

  // 별칭 (확장 컬러와 동일 값)
  static const navWhite = white;
  static const tooltipCream = cream;

  // ── 다크 모드 ──
  // darkBg와 darkCard의 명도 차이를 ~20%로 확대하여 카드-배경 구분을 명확히 한다.
  // 기존 darkBg(#1A1512) → 더 어두운 #121010, darkCard(#2A231D) → 더 밝은 #342B23
  static const darkBg = Color(0xFF121010);
  static const darkCard = Color(0xFF342B23);
  static const darkCardElevated = Color(0xFF3D3328);
  static const darkBorder = Color(0xFF4A3D32);
  static const darkTextPrimary = Color(0xFFF5EDE3);
  static const darkTextSecondary = Color(0xFFA89888);
}
