import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/growth_record.dart';
import '../../../data/seed/who_growth_data.dart';

/// 성장 기록에서 값을 추출하는 함수 타입.
typedef GrowthValueExtractor = double? Function(GrowthRecord record);

/// 성장 곡선 차트 위젯 (디자인컴포넌트 2-5-2).
/// fl_chart의 LineChart를 사용하여 WHO 표준 밴드 + 아기 데이터를 표시.
class GrowthChartWidget extends StatelessWidget {
  /// 아기의 성장 기록 리스트 (ASC 정렬).
  final List<GrowthRecord> records;

  /// 탭 종류: 0=체중, 1=키, 2=머리둘레.
  final int tabIndex;

  /// 아기 생년월일 (주차 계산용).
  final DateTime? babyBirthDate;

  const GrowthChartWidget({
    super.key,
    required this.records,
    required this.tabIndex,
    this.babyBirthDate,
  });

  List<List<double>> _getPercentiles() {
    switch (tabIndex) {
      case 0:
        return WhoGrowthData.weightPercentiles;
      case 1:
        return WhoGrowthData.heightPercentiles;
      case 2:
        return WhoGrowthData.headCircumPercentiles;
      default:
        return WhoGrowthData.weightPercentiles;
    }
  }

  double? _extractValue(GrowthRecord record) {
    switch (tabIndex) {
      case 0:
        return record.weightKg;
      case 1:
        return record.heightCm;
      case 2:
        return record.headCircumCm;
      default:
        return null;
    }
  }

  String _getUnit() {
    switch (tabIndex) {
      case 0:
        return AppStrings.weightUnit;
      case 1:
        return AppStrings.heightUnit;
      case 2:
        return AppStrings.headCircumUnit;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentiles = _getPercentiles();
    final hasData = records.any((r) => _extractValue(r) != null);

    if (!hasData && records.isEmpty) {
      return Container(
        key: const ValueKey('growth_chart_graph'),
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Center(
          child: Text(
            AppStrings.growthEmptyChart,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.warmGray,
            ),
          ),
        ),
      );
    }

    // Determine Y-axis range from WHO data
    final allP15 = percentiles.map((e) => e[1]).toList();
    final allP85 = percentiles.map((e) => e[3]).toList();
    var minY = allP15.reduce((a, b) => a < b ? a : b) - 1;
    var maxY = allP85.reduce((a, b) => a > b ? a : b) + 1;

    // Build baby data spots
    final babySpots = <FlSpot>[];
    for (final record in records) {
      final value = _extractValue(record);
      if (value == null) continue;
      double weekX;
      if (babyBirthDate != null) {
        weekX = record.date.difference(babyBirthDate!).inDays / 7.0;
      } else {
        weekX = records.indexOf(record).toDouble();
      }
      babySpots.add(FlSpot(weekX, value));
      if (value < minY) minY = value - 1;
      if (value > maxY) maxY = value + 1;
    }

    // Build WHO band lines
    final p15Spots = percentiles
        .map((e) => FlSpot(e[0], e[1]))
        .toList();
    final p85Spots = percentiles
        .map((e) => FlSpot(e[0], e[3]))
        .toList();
    final p50Spots = percentiles
        .map((e) => FlSpot(e[0], e[2]))
        .toList();

    return Column(
      key: const ValueKey('growth_chart_graph'),
      children: [
        SizedBox(
          width: double.infinity,
          height: 240,
          child: Padding(
            padding: const EdgeInsets.only(
              right: AppDimensions.base,
              top: AppDimensions.sm,
            ),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 12,
                minY: minY.floorToDouble(),
                maxY: maxY.ceilToDouble(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval:
                      ((maxY - minY) / 4).ceilToDouble().clamp(1, 10),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.lightBeige,
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      _getUnit(),
                      style: theme.textTheme.labelSmall,
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: theme.textTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        if (value % 2 == 0) {
                          return Text(
                            '${value.toInt()}w',
                            style: theme.textTheme.labelSmall,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      getTitlesWidget: (value, meta) {
                        // Show qualitative labels near the band
                        final midP85 = percentiles.last[3];
                        final midP15 = percentiles.last[1];
                        final midP50 = (midP85 + midP15) / 2;

                        if ((value - midP85).abs() < 0.5) {
                          return Text(
                            AppStrings.growthLabelHigh,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.warmGray,
                            ),
                          );
                        }
                        if ((value - midP50).abs() < 0.5) {
                          return Text(
                            AppStrings.growthLabelNormal,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.warmGray,
                            ),
                          );
                        }
                        if ((value - midP15).abs() < 0.5) {
                          return Text(
                            AppStrings.growthLabelLow,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.warmGray,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // 15th percentile (lower band edge)
                  LineChartBarData(
                    spots: p15Spots,
                    isCurved: true,
                    color: Colors.transparent,
                    barWidth: 0,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // 85th percentile (upper band edge, fill between)
                  LineChartBarData(
                    spots: p85Spots,
                    isCurved: true,
                    color: Colors.transparent,
                    barWidth: 0,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.growthBand,
                    ),
                  ),
                  // Clear the area below 15th by overlaying with background
                  LineChartBarData(
                    spots: p15Spots,
                    isCurved: true,
                    color: Colors.transparent,
                    barWidth: 0,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),
                  // 50th percentile (dashed center line)
                  LineChartBarData(
                    spots: p50Spots,
                    isCurved: true,
                    color: AppColors.softGreen.withValues(alpha: 0.5),
                    barWidth: 1,
                    dotData: const FlDotData(show: false),
                    dashArray: [4, 4],
                  ),
                  // Baby data line
                  if (babySpots.isNotEmpty)
                    LineChartBarData(
                      spots: babySpots,
                      isCurved: true,
                      color: AppColors.warmOrange,
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, p, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.warmOrange,
                          strokeWidth: 0,
                        ),
                      ),
                    ),
                ],
                lineTouchData: LineTouchData(enabled: false),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(
              theme,
              AppColors.warmOrange,
              AppStrings.growthLegendBaby,
              false,
            ),
            const SizedBox(width: AppDimensions.base),
            _legendItem(
              theme,
              AppColors.growthBand,
              AppStrings.growthLegendStandard,
              true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(
    ThemeData theme,
    Color color,
    String label,
    bool isArea,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isArea ? color : null,
            border: isArea ? null : Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
        const SizedBox(width: AppDimensions.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
