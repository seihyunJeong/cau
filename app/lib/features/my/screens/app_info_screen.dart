import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

/// 앱 정보 화면.
/// 앱 바 변형 B: 뒤로가기 + "앱 정보".
/// 면책/출처/저작권 정보를 표시한다.
class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: const ValueKey('app_info_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          constraints: const BoxConstraints(
            minWidth: AppDimensions.minTouchTarget,
            minHeight: AppDimensions.minTouchTarget,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.appInfoTitle,
          style: theme.textTheme.headlineSmall,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        key: const ValueKey('app_info_scroll'),
        padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimensions.xl),
            // ── 앱 이름 ──
            Text(
              AppStrings.appName,
              key: const ValueKey('app_info_name'),
              style: theme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.sm),
            // ── 버전 ──
            Text(
              AppStrings.appVersion,
              key: const ValueKey('app_info_version'),
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.lg),
            const Divider(),
            const SizedBox(height: AppDimensions.lg),
            // ── 면책 문구 섹션 ──
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.disclaimerSectionTitle,
                key: const ValueKey('app_info_disclaimer_title'),
                style: theme.textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.disclaimerMain,
                key: const ValueKey('app_info_disclaimer_body'),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            // ── 콘텐츠 출처 섹션 ──
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.sourceSectionTitle,
                key: const ValueKey('app_info_source_title'),
                style: theme.textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.disclaimerSource,
                key: const ValueKey('app_info_source_body'),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            // ── 저작권 정보 ──
            Text(
              AppStrings.copyright,
              key: const ValueKey('app_info_copyright'),
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}
