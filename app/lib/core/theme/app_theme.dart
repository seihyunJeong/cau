import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_text_styles.dart';

/// 라이트 모드용 TextTheme.
/// 주요 텍스트는 darkBrown, 보조 텍스트(caption/small)는 warmGray.
/// 버튼 텍스트(labelLarge)는 white, 텍스트 링크(labelMedium)는 warmOrange.
TextTheme _lightTextTheme() {
  return TextTheme(
    displayLarge: AppTextStyles.display.copyWith(color: AppColors.darkBrown),
    displayMedium: AppTextStyles.data.copyWith(color: AppColors.darkBrown),
    displaySmall: AppTextStyles.timerDisplay.copyWith(color: AppColors.darkBrown),
    headlineLarge: AppTextStyles.h1.copyWith(color: AppColors.darkBrown),
    headlineMedium: AppTextStyles.h2.copyWith(color: AppColors.darkBrown),
    headlineSmall: AppTextStyles.h3.copyWith(color: AppColors.darkBrown),
    bodyLarge: AppTextStyles.body1.copyWith(color: AppColors.darkBrown),
    bodyMedium: AppTextStyles.body2.copyWith(color: AppColors.darkBrown),
    bodySmall: AppTextStyles.caption.copyWith(color: AppColors.warmGray),
    labelLarge: AppTextStyles.button.copyWith(color: AppColors.white),
    labelMedium: AppTextStyles.buttonSmall.copyWith(color: AppColors.warmOrange),
    labelSmall: AppTextStyles.small.copyWith(color: AppColors.warmGray),
  );
}

/// 다크 모드용 TextTheme.
/// 주요 텍스트는 darkTextPrimary, 보조 텍스트는 darkTextSecondary.
/// 버튼/링크 텍스트 색상은 라이트 모드와 동일(warmOrange 유지).
TextTheme _darkTextTheme() {
  return TextTheme(
    displayLarge: AppTextStyles.display.copyWith(color: AppColors.darkTextPrimary),
    displayMedium: AppTextStyles.data.copyWith(color: AppColors.darkTextPrimary),
    displaySmall: AppTextStyles.timerDisplay.copyWith(color: AppColors.darkTextPrimary),
    headlineLarge: AppTextStyles.h1.copyWith(color: AppColors.darkTextPrimary),
    headlineMedium: AppTextStyles.h2.copyWith(color: AppColors.darkTextPrimary),
    headlineSmall: AppTextStyles.h3.copyWith(color: AppColors.darkTextPrimary),
    bodyLarge: AppTextStyles.body1.copyWith(color: AppColors.darkTextPrimary),
    bodyMedium: AppTextStyles.body2.copyWith(color: AppColors.darkTextPrimary),
    bodySmall: AppTextStyles.caption.copyWith(color: AppColors.darkTextSecondary),
    labelLarge: AppTextStyles.button.copyWith(color: AppColors.white),
    labelMedium: AppTextStyles.buttonSmall.copyWith(color: AppColors.warmOrange),
    labelSmall: AppTextStyles.small.copyWith(color: AppColors.darkTextSecondary),
  );
}

/// 라이트 테마 생성.
/// 디자인컴포넌트 4-1 기준. flex_color_scheme 미사용, 순수 ThemeData 구성.
ThemeData lightTheme() {
  final textTheme = _lightTextTheme();

  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.warmOrange,
    scaffoldBackgroundColor: AppColors.cream,
    canvasColor: AppColors.cream,
    cardColor: AppColors.white,
    dividerColor: AppColors.lightBeige,
    colorScheme: const ColorScheme.light(
      primary: AppColors.warmOrange,
      secondary: AppColors.softGreen,
      error: AppColors.softRed,
      surface: AppColors.white,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.darkBrown,
      onError: AppColors.white,
    ),
    fontFamily: 'Pretendard',
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.darkBrown, size: 24),
      titleTextStyle: textTheme.headlineSmall,
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(
          color: AppColors.lightBeige,
          width: 1,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.warmOrange,
      unselectedItemColor: AppColors.warmGray,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.white,
      indicatorColor: AppColors.warmOrange.withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyles.small.copyWith(color: AppColors.warmOrange);
        }
        return AppTextStyles.small.copyWith(color: AppColors.warmGray);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.warmOrange,
            size: 24,
          );
        }
        return const IconThemeData(
          color: AppColors.warmGray,
          size: 24,
        );
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.warmOrange,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        textStyle: AppTextStyles.button,
        minimumSize: const Size(double.infinity, 52),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.lightBeige),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.lightBeige),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.warmOrange),
      ),
      hintStyle: AppTextStyles.body2.copyWith(color: AppColors.mutedBeige),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.warmOrange;
        }
        return AppColors.warmGray;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.warmOrange,
      linearTrackColor: AppColors.trackGray,
    ),
    useMaterial3: true,
  );
}

/// 다크 테마 생성.
/// 디자인컴포넌트 4-1 기준. 야간 수유 시 눈부심 방지.
ThemeData darkTheme() {
  final textTheme = _darkTextTheme();

  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.warmOrange,
    scaffoldBackgroundColor: AppColors.darkBg,
    canvasColor: AppColors.darkBg,
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkBorder,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.warmOrange,
      secondary: AppColors.softGreen,
      error: AppColors.softRed,
      surface: AppColors.darkCard,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.darkTextPrimary,
      onError: AppColors.white,
    ),
    fontFamily: 'Pretendard',
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary, size: 24),
      titleTextStyle: textTheme.headlineSmall,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      selectedItemColor: AppColors.warmOrange,
      unselectedItemColor: AppColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      indicatorColor: AppColors.warmOrange.withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyles.small.copyWith(color: AppColors.warmOrange);
        }
        return AppTextStyles.small.copyWith(
          color: AppColors.darkTextSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.warmOrange,
            size: 24,
          );
        }
        return const IconThemeData(
          color: AppColors.darkTextSecondary,
          size: 24,
        );
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.warmOrange,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        textStyle: AppTextStyles.button,
        minimumSize: const Size(double.infinity, 52),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.warmOrange),
      ),
      hintStyle: AppTextStyles.body2.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.warmOrange;
        }
        return AppColors.darkTextSecondary;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.warmOrange,
      linearTrackColor: AppColors.darkBorder,
    ),
    useMaterial3: true,
  );
}
