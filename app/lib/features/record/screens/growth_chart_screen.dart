import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/reassurance_card.dart';
import '../../../providers/baby_providers.dart';
import '../../../providers/growth_providers.dart';
import '../widgets/growth_chart_widget.dart';
import '../widgets/recent_growth_list.dart';

/// 성장 곡선 그래프 화면 (개발기획서 5-4 화면 2-1).
/// AppBar(변형 B) + 안심 카드 + TabBar(체중/키/머리둘레) + 그래프 + 최근 기록.
class GrowthChartScreen extends ConsumerStatefulWidget {
  const GrowthChartScreen({super.key});

  @override
  ConsumerState<GrowthChartScreen> createState() => _GrowthChartScreenState();
}

class _GrowthChartScreenState extends ConsumerState<GrowthChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recordsAsync = ref.watch(allGrowthRecordsProvider);
    final babyAsync = ref.watch(activeBabyProvider);
    final baby = babyAsync.value;

    final hasData = recordsAsync.value?.isNotEmpty ?? false;

    return Scaffold(
      key: const ValueKey('growth_chart_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.growthChartTitle,
          style: theme.textTheme.headlineSmall,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: AppColors.warmGray,
          indicatorColor: theme.colorScheme.primary,
          labelStyle: theme.textTheme.labelMedium,
          unselectedLabelStyle: theme.textTheme.labelMedium,
          tabs: [
            Tab(
              key: const ValueKey('growth_chart_tab_weight'),
              text: AppStrings.growthTabWeight,
            ),
            Tab(
              key: const ValueKey('growth_chart_tab_height'),
              text: AppStrings.growthTabHeight,
            ),
            Tab(
              key: const ValueKey('growth_chart_tab_head'),
              text: AppStrings.growthTabHead,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
        child: Column(
          children: [
            // Reassurance card
            ReassuranceCard(
              cardKey: const ValueKey('growth_reassurance_card'),
              message: hasData
                  ? AppStrings.growthReassuranceChart
                  : AppStrings.growthEmptyChart,
            ),
            const SizedBox(height: AppDimensions.base),

            // Chart area
            recordsAsync.when(
              loading: () => const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, s) => SizedBox(
                height: 240,
                child: Center(
                  child: Text(e.toString()),
                ),
              ),
              data: (records) {
                return Column(
                  children: [
                    // Growth chart
                    GrowthChartWidget(
                      records: records,
                      tabIndex: _tabController.index,
                      babyBirthDate: baby?.birthDate,
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // Recent growth list
                    RecentGrowthList(
                      records: records,
                      tabIndex: _tabController.index,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
