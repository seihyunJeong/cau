import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/inline_save_indicator.dart';

/// 수면 시간 입력 카드 (디자인컴포넌트 2-4-4).
/// 탭하면 시간 피커 표시. 선택 후 자동 저장.
class SleepInputCard extends StatefulWidget {
  /// 현재 수면 시간 (시간 단위, null이면 미입력).
  final double? sleepHours;

  /// 수면 시간이 변경될 때 호출.
  final ValueChanged<double> onSleepChanged;

  const SleepInputCard({
    super.key,
    this.sleepHours,
    required this.onSleepChanged,
  });

  @override
  State<SleepInputCard> createState() => _SleepInputCardState();
}

class _SleepInputCardState extends State<SleepInputCard> {
  bool _showSaved = false;
  int _savedCount = 0;

  String _formatSleepValue(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return AppStrings.sleepValue(h, m);
  }

  Future<void> _showTimePicker() async {
    final currentHours = widget.sleepHours ?? 0;
    final initialH = currentHours.floor();
    final initialM = ((currentHours - initialH) * 60).round();

    Duration? selectedDuration;

    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.base,
                  vertical: AppDimensions.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        AppStrings.datePickerConfirm,
                        style: Theme.of(ctx).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: Duration(
                    hours: initialH,
                    minutes: initialM,
                  ),
                  onTimerDurationChanged: (duration) {
                    selectedDuration = duration;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedDuration != null && mounted) {
      final totalHours =
          selectedDuration!.inMinutes / 60.0;
      widget.onSleepChanged(totalHours);
      _triggerSaved();
    }
  }

  void _triggerSaved() {
    _savedCount++;
    final currentCount = _savedCount;
    setState(() => _showSaved = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _savedCount == currentCount) {
        setState(() => _showSaved = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasSleep = widget.sleepHours != null && widget.sleepHours! > 0;

    return Container(
      key: const ValueKey('sleep_input_card'),
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
            '${String.fromCharCode(0x1F4A4)} ${AppStrings.sleepLabel}',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.md),
          // Sleep value tap area - improved with clock icon and better hint
          GestureDetector(
            onTap: _showTimePicker,
            child: Container(
              width: double.infinity,
              height: AppDimensions.minTouchTarget,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.cardPadding,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBeige,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 20,
                    color: hasSleep
                        ? AppColors.warmOrange
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.mutedBeige),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Text(
                      hasSleep
                          ? _formatSleepValue(widget.sleepHours!)
                          : AppStrings.sleepPlaceholderDetailed,
                      key: const ValueKey('sleep_value'),
                      style: hasSleep
                          ? theme.textTheme.bodyLarge
                          : theme.textTheme.bodyLarge?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.mutedBeige,
                            ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.mutedBeige,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          // Save indicator
          Align(
            alignment: Alignment.centerRight,
            child: InlineSaveIndicator(
              show: _showSaved,
              indicatorKey: const ValueKey('sleep_save_indicator'),
            ),
          ),
        ],
      ),
    );
  }
}
