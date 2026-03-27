import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

/// 인라인 "저장됨" 피드백 위젯 (디자인컴포넌트 2-6-3).
/// [show]를 true로 설정하면 "저장됨" 텍스트를 표시하고,
/// 2초 후 0.5초에 걸쳐 페이드아웃한다.
class InlineSaveIndicator extends StatefulWidget {
  /// true로 설정하면 "저장됨" 표시 후 2초 뒤 페이드아웃.
  final bool show;

  /// Marionette MCP 테스트용 키.
  final ValueKey<String>? indicatorKey;

  const InlineSaveIndicator({
    super.key,
    required this.show,
    this.indicatorKey,
  });

  @override
  State<InlineSaveIndicator> createState() => _InlineSaveIndicatorState();
}

class _InlineSaveIndicatorState extends State<InlineSaveIndicator> {
  double _opacity = 0.0;

  @override
  void didUpdateWidget(covariant InlineSaveIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _showAndFade();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.show) {
      _showAndFade();
    }
  }

  void _showAndFade() {
    if (!mounted) return;
    setState(() => _opacity = 1.0);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _opacity = 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      key: widget.indicatorKey,
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Text(
        AppStrings.savedInline,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
