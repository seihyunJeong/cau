import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/saved_toast.dart';
import '../../../providers/record_providers.dart';

/// 빠른 기록 영역 (2-3-4).
/// 수유 +1, 배변 +1 원탭 카운터.
/// 각 버튼 탭 시 DB에 즉시 저장 + "저장됨" 토스트 + 햅틱 피드백 + scale-up 애니메이션.
class QuickRecordRow extends ConsumerWidget {
  const QuickRecordRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recordAsync = ref.watch(todayRecordProvider);

    final feedingCount = recordAsync.value?.feedingCount ?? 0;
    final diaperCount = recordAsync.value?.diaperCount ?? 0;

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: const ValueKey('quick_record_row'),
      padding: const EdgeInsets.all(AppDimensions.cardPaddingCompact),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickRecordButton(
              buttonKey: const ValueKey('quick_feeding_btn'),
              countKey: const ValueKey('feeding_count_text'),
              icon: Icons.local_drink_outlined,
              label: AppStrings.feeding,
              count: feedingCount,
              onTap: () async {
                HapticFeedback.lightImpact();
                await ref
                    .read(todayRecordProvider.notifier)
                    .incrementFeeding();
                if (context.mounted) {
                  showSavedToast(context);
                }
              },
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: _QuickRecordButton(
              buttonKey: const ValueKey('quick_diaper_btn'),
              countKey: const ValueKey('diaper_count_text'),
              icon: Icons.baby_changing_station,
              label: AppStrings.diaper,
              count: diaperCount,
              onTap: () async {
                HapticFeedback.lightImpact();
                await ref
                    .read(todayRecordProvider.notifier)
                    .incrementDiaper();
                if (context.mounted) {
                  showSavedToast(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 빠른 기록 개별 버튼.
/// 아이콘 + 레이블 + "+1" + "오늘 N" 표시.
/// 탭 시 scale-up 애니메이션.
class _QuickRecordButton extends StatefulWidget {
  final ValueKey<String> buttonKey;
  final ValueKey<String> countKey;
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _QuickRecordButton({
    required this.buttonKey,
    required this.countKey,
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  State<_QuickRecordButton> createState() => _QuickRecordButtonState();
}

class _QuickRecordButtonState extends State<_QuickRecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _QuickRecordButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count && widget.count > oldWidget.count) {
      _animController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: widget.buttonKey,
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppDimensions.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppDimensions.xs),
              Text(
                widget.label,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(width: AppDimensions.xs),
              Text(
                AppStrings.plusOne,
                style: theme.textTheme.labelMedium,
              ),
              const Spacer(),
              ScaleTransition(
                scale: _scaleAnim,
                child: Text(
                  '${AppStrings.todayCount} ${widget.count}',
                  key: widget.countKey,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
