import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

/// 텍스트 링크 버튼 (2-3-6).
/// 디자인컴포넌트 2-3-6 기준. warmOrange 텍스트, 14sp.
/// 최소 터치 영역 48dp 확보.
class TextLinkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ValueKey<String>? buttonKey;

  const TextLinkButton({
    super.key,
    required this.label,
    this.onPressed,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: buttonKey,
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppDimensions.minTouchTarget,
        ),
        alignment: Alignment.centerRight,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
