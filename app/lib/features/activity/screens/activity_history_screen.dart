import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/activity_type_chip.dart';
import '../../../core/widgets/empty_state_card.dart';
import '../../../data/models/activity_record.dart';
import '../../../data/seed/activity_seed.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/core_providers.dart';

/// 활동 히스토리 Provider.
final activityHistoryProvider =
    FutureProvider<List<ActivityRecord>>((ref) async {
  final babyAsync = ref.watch(activeBabyProvider);
  final baby = babyAsync.value;
  if (baby == null || baby.id == null) return [];

  final dao = ref.watch(activityRecordDaoProvider);
  return dao.getAllByBabyId(baby.id!);
});

/// 활동 히스토리 화면.
/// 완료한 활동 기록을 날짜별로 그룹화하여 표시한다.
class ActivityHistoryScreen extends ConsumerWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final historyAsync = ref.watch(activityHistoryProvider);

    return Scaffold(
      key: const ValueKey('activity_history_screen'),
      appBar: AppBar(
        title: Text(
          AppStrings.activityHistoryTitle,
          style: theme.textTheme.headlineSmall,
        ),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (records) {
          if (records.isEmpty) {
            return const Center(
              child: EmptyStateCard(
                icon: Icons.history,
                message: AppStrings.activityHistoryEmpty,
                cardKey: ValueKey('activity_history_empty'),
              ),
            );
          }

          // 날짜별 그룹화
          final grouped = <String, List<ActivityRecord>>{};
          final dateFormat = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR');
          for (final record in records) {
            final key = dateFormat.format(record.completedAt);
            grouped.putIfAbsent(key, () => []).add(record);
          }

          final dateKeys = grouped.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
              vertical: AppDimensions.sm,
            ),
            itemCount: dateKeys.length,
            itemBuilder: (context, index) {
              final dateLabel = dateKeys[index];
              final dayRecords = grouped[dateLabel]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0)
                    const SizedBox(height: AppDimensions.sectionGap),
                  // 날짜 헤더
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.sm,
                    ),
                    child: Text(
                      dateLabel,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  // 해당 날짜의 기록들
                  ...dayRecords.map(
                    (record) => _HistoryRecordTile(
                      record: record,
                      isDark: isDark,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _HistoryRecordTile extends StatelessWidget {
  final ActivityRecord record;
  final bool isDark;

  const _HistoryRecordTile({
    required this.record,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm');

    // 시드 데이터에서 활동 정보 찾기
    final activity = activitySeed.where((a) => a.id == record.activityId).firstOrNull;
    final activityName = activity?.name ?? record.activityId;
    final activityType = activity?.type;
    final accentColor = _getAccentColor(activityType);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.cardGap),
      child: GestureDetector(
        onTap: activity != null
            ? () => context.push('/activity/${activity.id}')
            : null,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: isDark
                ? Border.all(color: AppColors.darkBorder, width: 1)
                : null,
            boxShadow: AppShadows.adaptiveSubtle(isDark),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // 좌측 악센트바
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.md),
                      bottomLeft: Radius.circular(AppRadius.md),
                    ),
                  ),
                ),
                // 내용
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      AppDimensions.cardPaddingCompact,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (activityType != null) ...[
                                ActivityTypeChip(type: activityType),
                                const SizedBox(height: AppDimensions.xs),
                              ],
                              Text(
                                activityName,
                                style: theme.textTheme.titleSmall,
                              ),
                              const SizedBox(height: AppDimensions.xxs),
                              Text(
                                record.timerUsed
                                    ? '${AppStrings.activityHistoryTimerUsed} · ${record.timerDurationSec ?? 0}${AppStrings.seconds}'
                                    : AppStrings.activityHistoryNoTimer,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        // 완료 시간
                        Text(
                          timeFormat.format(record.completedAt),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAccentColor(String? type) {
    switch (type) {
      case '잡기':
        return AppColors.domainHolding;
      case '감각':
        return AppColors.domainSensory;
      case '소리':
        return AppColors.domainSound;
      case '시각':
        return AppColors.domainVision;
      case '촉각':
        return AppColors.domainTouch;
      case '균형':
        return AppColors.domainBalance;
      default:
        return AppColors.warmOrange;
    }
  }
}
