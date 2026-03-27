import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';

/// 마이 화면 섹션 구분 헤더 위젯.
/// "알림 설정", "화면 설정", "데이터", "정보" 등 각 섹션의 제목을 표시한다.
class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final ValueKey<String>? headerKey;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    this.headerKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      key: headerKey,
      padding: const EdgeInsets.only(
        left: AppDimensions.screenPaddingH,
        right: AppDimensions.screenPaddingH,
        top: AppDimensions.lg,
        bottom: AppDimensions.sm,
      ),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall,
      ),
    );
  }
}
