import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/inline_save_indicator.dart';
import '../../../data/models/growth_record.dart';

/// 성장 기록 확장 타일 (디자인컴포넌트 2-4-6).
/// 기본 접힘 상태. 탭 시 체중/키/머리둘레 입력 필드 노출.
class GrowthExpansionTile extends StatefulWidget {
  /// 오늘 성장 기록 (존재 시 접힌 상태에서 컴팩트 표시).
  final GrowthRecord? todayGrowth;

  /// 성장 데이터가 변경될 때 호출.
  final void Function({
    double? weightKg,
    double? heightCm,
    double? headCircumCm,
  }) onGrowthChanged;

  const GrowthExpansionTile({
    super.key,
    this.todayGrowth,
    required this.onGrowthChanged,
  });

  @override
  State<GrowthExpansionTile> createState() => _GrowthExpansionTileState();
}

class _GrowthExpansionTileState extends State<GrowthExpansionTile> {
  bool _isExpanded = false;

  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _headController;

  bool _weightSaved = false;
  bool _heightSaved = false;
  bool _headSaved = false;
  int _weightSavedCount = 0;
  int _heightSavedCount = 0;
  int _headSavedCount = 0;

  bool _hasAnyData = false;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.todayGrowth?.weightKg?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: widget.todayGrowth?.heightCm?.toString() ?? '',
    );
    _headController = TextEditingController(
      text: widget.todayGrowth?.headCircumCm?.toString() ?? '',
    );
    _hasAnyData = widget.todayGrowth != null &&
        (widget.todayGrowth!.weightKg != null ||
            widget.todayGrowth!.heightCm != null ||
            widget.todayGrowth!.headCircumCm != null);
  }

  @override
  void didUpdateWidget(covariant GrowthExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todayGrowth != oldWidget.todayGrowth) {
      _weightController.text =
          widget.todayGrowth?.weightKg?.toString() ?? '';
      _heightController.text =
          widget.todayGrowth?.heightCm?.toString() ?? '';
      _headController.text =
          widget.todayGrowth?.headCircumCm?.toString() ?? '';
      _hasAnyData = widget.todayGrowth != null &&
          (widget.todayGrowth!.weightKg != null ||
              widget.todayGrowth!.heightCm != null ||
              widget.todayGrowth!.headCircumCm != null);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _headController.dispose();
    super.dispose();
  }

  void _saveWeight() {
    final value = double.tryParse(_weightController.text);
    widget.onGrowthChanged(weightKg: value);
    _triggerSaved('weight');
  }

  void _saveHeight() {
    final value = double.tryParse(_heightController.text);
    widget.onGrowthChanged(heightCm: value);
    _triggerSaved('height');
  }

  void _saveHead() {
    final value = double.tryParse(_headController.text);
    widget.onGrowthChanged(headCircumCm: value);
    _triggerSaved('head');
  }

  void _triggerSaved(String field) {
    setState(() {
      _hasAnyData = true;
      switch (field) {
        case 'weight':
          _weightSavedCount++;
          _weightSaved = true;
          final count = _weightSavedCount;
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted && _weightSavedCount == count) {
              setState(() => _weightSaved = false);
            }
          });
        case 'height':
          _heightSavedCount++;
          _heightSaved = true;
          final count = _heightSavedCount;
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted && _heightSavedCount == count) {
              setState(() => _heightSaved = false);
            }
          });
        case 'head':
          _headSavedCount++;
          _headSaved = true;
          final count = _headSavedCount;
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted && _headSavedCount == count) {
              setState(() => _headSaved = false);
            }
          });
      }
    });
  }

  String _buildCompactSummary() {
    final parts = <String>[];
    if (widget.todayGrowth?.weightKg != null) {
      parts.add('${widget.todayGrowth!.weightKg}${AppStrings.weightUnit}');
    }
    if (widget.todayGrowth?.heightCm != null) {
      parts.add('${widget.todayGrowth!.heightCm}${AppStrings.heightUnit}');
    }
    return AppStrings.growthTodayCompact(
      widget.todayGrowth?.weightKg?.toString() ?? '-',
      widget.todayGrowth?.heightCm?.toString() ?? '-',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dark mode: use cardColor consistently. Light mode: use paleCream when collapsed.
    final collapsedBgColor = isDark ? theme.cardColor : AppColors.paleCream;
    final headerTextColor = isDark ? AppColors.darkTextPrimary : AppColors.darkBrown;

    return AnimatedContainer(
      key: const ValueKey('growth_expansion_tile'),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _isExpanded ? theme.cardColor : collapsedBgColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (always visible)
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _hasAnyData && !_isExpanded
                          ? _buildCompactSummary()
                          : AppStrings.growthAddLabel,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: headerTextColor,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: theme.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(theme),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.cardPadding,
        0,
        AppDimensions.cardPadding,
        AppDimensions.cardPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weight field
          _buildInputField(
            theme: theme,
            label: '${AppStrings.growthWeightLabel} (${AppStrings.weightUnit})',
            controller: _weightController,
            fieldKey: const ValueKey('growth_weight_field'),
            onSubmitted: (_) => _saveWeight(),
            onEditingComplete: _saveWeight,
            showSaved: _weightSaved,
          ),
          const SizedBox(height: AppDimensions.md),
          // Height field
          _buildInputField(
            theme: theme,
            label: '${AppStrings.growthHeightLabel} (${AppStrings.heightUnit})',
            controller: _heightController,
            fieldKey: const ValueKey('growth_height_field'),
            onSubmitted: (_) => _saveHeight(),
            onEditingComplete: _saveHeight,
            showSaved: _heightSaved,
          ),
          const SizedBox(height: AppDimensions.md),
          // Head circumference field
          _buildInputField(
            theme: theme,
            label:
                '${AppStrings.growthHeadLabel} (${AppStrings.headCircumUnit})',
            controller: _headController,
            fieldKey: const ValueKey('growth_head_field'),
            onSubmitted: (_) => _saveHead(),
            onEditingComplete: _saveHead,
            showSaved: _headSaved,
          ),
          // Reassurance message
          if (_hasAnyData) ...[
            const SizedBox(height: AppDimensions.md),
            Row(
              key: const ValueKey('growth_reassurance_msg'),
              children: [
                Icon(
                  Icons.check_circle,
                  size: AppDimensions.base,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  AppStrings.growthReassurance,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField({
    required ThemeData theme,
    required String label,
    required TextEditingController controller,
    required ValueKey<String> fieldKey,
    required ValueChanged<String> onSubmitted,
    required VoidCallback onEditingComplete,
    required bool showSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimensions.xs),
        TextField(
          key: fieldKey,
          controller: controller,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : AppColors.lightBeige,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : AppColors.lightBeige,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.warmOrange,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            isDense: true,
          ),
        ),
        const SizedBox(height: AppDimensions.xxs),
        Align(
          alignment: Alignment.centerRight,
          child: InlineSaveIndicator(
            show: showSaved,
          ),
        ),
      ],
    );
  }
}
