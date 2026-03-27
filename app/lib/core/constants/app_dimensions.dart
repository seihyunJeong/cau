/// 앱 전체 간격 시스템.
/// 디자인컴포넌트 1-3 기준. 4px 그리드 기반.
abstract class AppDimensions {
  // ── 간격 ──
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // ── 레이아웃 ──
  static const double screenPaddingH = 16;
  static const double cardPadding = 16;
  static const double cardPaddingCompact = 12;
  static const double sectionGap = 24;
  static const double cardGap = 12;

  // ── 터치 영역 ──
  static const double minTouchTarget = 48;

  // ── 고정 높이 ──
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;
  static const double stickyButtonAreaHeight = 72;

  // ── 차트/아이콘 크기 ──
  static const double radarChartSize = 200;
  static const double trendChartHeight = 180;
  static const double scoreSelectorHeight = 40;
  static const double iconSizeMd = 20;
}
