import 'package:flutter/material.dart';

/// 조부모 모드 테마.
/// 디자인컴포넌트 4-2 기준. 모든 텍스트 크기에 +4sp 적용.
/// 원본 base 테마의 나머지 속성(색상 등)은 유지된다.
///
/// textTheme과 appBarTheme.titleTextStyle 모두에 +4sp를 적용하여
/// Theme.of(context).textTheme을 사용하는 화면에서 조부모 모드가 실효한다.
ThemeData grandparentTheme(ThemeData base) {
  final enlargedTextTheme = base.textTheme.apply(fontSizeDelta: 4);

  return base.copyWith(
    textTheme: enlargedTextTheme,
    appBarTheme: base.appBarTheme.copyWith(
      titleTextStyle: base.appBarTheme.titleTextStyle?.copyWith(
        fontSize: (base.appBarTheme.titleTextStyle?.fontSize ?? 16) + 4,
      ),
    ),
  );
}
