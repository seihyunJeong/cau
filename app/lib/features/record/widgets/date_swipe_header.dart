import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../../providers/selected_date_provider.dart';

/// 날짜 스와이프 헤더 (디자인컴포넌트 2-7-4).
/// 좌/우 화살표 + 스와이프 제스처로 날짜 이동.
/// 미래 날짜는 우측 화살표 비활성.
class DateSwipeHeader extends ConsumerWidget {
  const DateSwipeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final theme = Theme.of(context);
    final now = nowKST();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;

    final dateFormat = DateFormat('yyyy년 M월 d일', 'ko_KR');
    final dateText = isToday
        ? '${dateFormat.format(selectedDate)} (${AppStrings.today})'
        : dateFormat.format(selectedDate);

    return GestureDetector(
      key: const ValueKey('date_swipe_header'),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! > 0) {
          // Swipe right -> previous day
          ref.read(selectedDateProvider.notifier).goToPreviousDay();
        } else if (details.primaryVelocity! < 0 && !isToday) {
          // Swipe left -> next day (only if not today)
          ref.read(selectedDateProvider.notifier).goToNextDay();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left arrow
            SizedBox(
              width: AppDimensions.minTouchTarget,
              height: AppDimensions.minTouchTarget,
              child: IconButton(
                key: const ValueKey('date_prev_btn'),
                onPressed: () =>
                    ref.read(selectedDateProvider.notifier).goToPreviousDay(),
                icon: const Icon(Icons.chevron_left),
                iconSize: AppDimensions.lg,
                color: theme.colorScheme.onSurface,
              ),
            ),
            // Date text
            Expanded(
              child: Text(
                dateText,
                key: const ValueKey('date_label'),
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            // Right arrow
            SizedBox(
              width: AppDimensions.minTouchTarget,
              height: AppDimensions.minTouchTarget,
              child: Opacity(
                opacity: isToday ? 0.3 : 1.0,
                child: IconButton(
                  key: const ValueKey('date_next_btn'),
                  onPressed: isToday
                      ? null
                      : () => ref
                            .read(selectedDateProvider.notifier)
                            .goToNextDay(),
                  icon: const Icon(Icons.chevron_right),
                  iconSize: AppDimensions.lg,
                  color: isToday
                      ? AppColors.mutedBeige
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
