import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/inline_save_indicator.dart';

/// 부모 메모 입력 카드 (디자인컴포넌트 2-4-5).
/// 다중 줄 TextField. debounce 1초 후 자동 저장.
class MemoInputCard extends StatefulWidget {
  /// 현재 메모 텍스트.
  final String? memo;

  /// 메모가 변경될 때 호출 (debounce 후).
  final ValueChanged<String> onMemoChanged;

  const MemoInputCard({
    super.key,
    this.memo,
    required this.onMemoChanged,
  });

  @override
  State<MemoInputCard> createState() => _MemoInputCardState();
}

class _MemoInputCardState extends State<MemoInputCard> {
  late final TextEditingController _controller;
  Timer? _debounce;
  bool _showSaved = false;
  int _savedCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.memo ?? '');
  }

  @override
  void didUpdateWidget(covariant MemoInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.memo != oldWidget.memo && widget.memo != _controller.text) {
      _controller.text = widget.memo ?? '';
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      widget.onMemoChanged(value);
      _triggerSaved();
    });
  }

  void _triggerSaved() {
    _savedCount++;
    final count = _savedCount;
    setState(() => _showSaved = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _savedCount == count) {
        setState(() => _showSaved = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: const ValueKey('memo_input_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            '${String.fromCharCode(0x1F4DD)} ${AppStrings.memoLabel}',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.md),
          // Memo TextField
          TextField(
            key: const ValueKey('memo_text_field'),
            controller: _controller,
            maxLines: 5,
            minLines: 3,
            onChanged: _onChanged,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: AppStrings.memoPlaceholder,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.mutedBeige,
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(
                  color: AppColors.warmOrange,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(AppDimensions.md),
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          // Save indicator
          Align(
            alignment: Alignment.centerRight,
            child: InlineSaveIndicator(
              show: _showSaved,
              indicatorKey: const ValueKey('memo_save_indicator'),
            ),
          ),
        ],
      ),
    );
  }
}
