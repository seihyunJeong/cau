import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/half_button_pair.dart';
import '../../../data/models/growth_record.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/core_providers.dart';
import '../../../providers/growth_providers.dart';
import '../../../providers/record_providers.dart';
import '../../../providers/selected_date_provider.dart';
import '../widgets/counter_card.dart';
import '../widgets/date_swipe_header.dart';
import '../widgets/growth_expansion_tile.dart';
import '../widgets/memo_input_card.dart';
import '../widgets/sleep_input_card.dart';

/// 기록 메인 화면 (탭 2).
/// 개발기획서 5-4 기준.
class RecordMainScreen extends ConsumerWidget {
  const RecordMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = ref.watch(selectedDateProvider);
    final now = nowKST();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;

    // Watch the date-specific record
    final recordAsync = ref.watch(dateRecordProvider(selectedDate));
    final todayGrowthAsync = ref.watch(todayGrowthRecordProvider);

    // Actions helper
    final actions = DateRecordActions(ref, selectedDate);

    return Scaffold(
      key: const ValueKey('record_main_screen'),
      appBar: AppBar(
        title: Text(
          AppStrings.recordTitle,
          style: theme.textTheme.headlineSmall,
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        key: const ValueKey('record_scroll_view'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
        ),
        child: Column(
          children: [
            // Date swipe header
            const DateSwipeHeader(),
            const SizedBox(height: AppDimensions.cardGap),

            // Content based on record state
            recordAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.xl),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, s) => Center(
                child: Text(
                  e.toString(),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              data: (record) {
                final feedingCount = record?.feedingCount ?? 0;
                final diaperCount = record?.diaperCount ?? 0;
                final sleepHours = record?.sleepHours;
                final memo = record?.memo;

                return Column(
                  children: [
                    // Feeding counter (warmOrange accent)
                    CounterCard(
                      label: AppStrings.feedingLabel,
                      emoji: String.fromCharCode(0x1F37C),
                      count: feedingCount,
                      onIncrement: () => actions.incrementFeeding(),
                      onDecrement: () => actions.decrementFeeding(),
                      cardKey: const ValueKey('feeding_counter_card'),
                      countKey: const ValueKey('feeding_count'),
                      plusKey: const ValueKey('feeding_plus_btn'),
                      minusKey: const ValueKey('feeding_minus_btn'),
                      accentColor: AppColors.warmOrange,
                    ),
                    const SizedBox(height: AppDimensions.cardGap),

                    // Diaper counter (softGreen accent for visual rhythm)
                    CounterCard(
                      label: AppStrings.diaperLabel,
                      emoji: String.fromCharCode(0x1F9F7),
                      count: diaperCount,
                      onIncrement: () => actions.incrementDiaper(),
                      onDecrement: () => actions.decrementDiaper(),
                      cardKey: const ValueKey('diaper_counter_card'),
                      countKey: const ValueKey('diaper_count'),
                      plusKey: const ValueKey('diaper_plus_btn'),
                      minusKey: const ValueKey('diaper_minus_btn'),
                      accentColor: AppColors.softGreen,
                    ),
                    const SizedBox(height: AppDimensions.cardGap),

                    // Sleep input
                    SleepInputCard(
                      sleepHours: sleepHours,
                      onSleepChanged: (hours) => actions.updateSleep(hours),
                    ),
                    const SizedBox(height: AppDimensions.cardGap),

                    // Growth expansion tile
                    todayGrowthAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (todayGrowth) => GrowthExpansionTile(
                        todayGrowth: isToday ? todayGrowth : null,
                        onGrowthChanged: ({
                          double? weightKg,
                          double? heightCm,
                          double? headCircumCm,
                        }) {
                          _saveGrowthRecord(
                            ref: ref,
                            date: selectedDate,
                            existingRecord: isToday ? todayGrowth : null,
                            weightKg: weightKg,
                            heightCm: heightCm,
                            headCircumCm: headCircumCm,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.cardGap),

                    // Memo input
                    MemoInputCard(
                      memo: memo,
                      onMemoChanged: (text) => actions.updateMemo(text),
                    ),
                    const SizedBox(height: AppDimensions.base),

                    // Half button pair
                    HalfButtonPair(
                      leftLabel: AppStrings.growthChartButton,
                      rightLabel: AppStrings.recordHistoryButton,
                      onLeftTap: () =>
                          context.push('/record/growth-chart'),
                      onRightTap: () =>
                          context.push('/record/history'),
                      leftKey: const ValueKey('growth_chart_btn'),
                      rightKey: const ValueKey('record_history_btn'),
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // Auto save notice
                    Text(
                      AppStrings.autoSaveNotice,
                      key: const ValueKey('auto_save_notice'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.warmGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveGrowthRecord({
    required WidgetRef ref,
    required DateTime date,
    GrowthRecord? existingRecord,
    double? weightKg,
    double? heightCm,
    double? headCircumCm,
  }) async {
    final babyAsync = ref.read(activeBabyProvider);
    final baby = babyAsync.value;
    if (baby == null) return;

    final dao = ref.read(growthRecordDaoProvider);
    final now = nowKST();

    if (existingRecord != null) {
      // Update existing record
      final updated = existingRecord.copyWith(
        weightKg: weightKg ?? existingRecord.weightKg,
        heightCm: heightCm ?? existingRecord.heightCm,
        headCircumCm: headCircumCm ?? existingRecord.headCircumCm,
      );
      await dao.update(updated);
    } else {
      // Check if a record exists for this date first
      final existing = await dao.getByDate(baby.id!, date);
      if (existing != null) {
        final updated = existing.copyWith(
          weightKg: weightKg ?? existing.weightKg,
          heightCm: heightCm ?? existing.heightCm,
          headCircumCm: headCircumCm ?? existing.headCircumCm,
        );
        await dao.update(updated);
      } else {
        // Insert new record
        final newRecord = GrowthRecord(
          babyId: baby.id!,
          date: DateTime(date.year, date.month, date.day),
          weightKg: weightKg,
          heightCm: heightCm,
          headCircumCm: headCircumCm,
          createdAt: now,
        );
        await dao.insert(newRecord);
      }
    }

    // Invalidate growth providers
    ref.invalidate(todayGrowthRecordProvider);
    ref.invalidate(allGrowthRecordsProvider);
    ref.invalidate(latestGrowthProvider);
  }
}
