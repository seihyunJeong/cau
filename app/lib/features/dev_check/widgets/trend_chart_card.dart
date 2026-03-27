import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';

/// 추이 라인 차트 카드 위젯 (디자인컴포넌트 2-5-3).
/// Y축: "낮음/보통/높음" 질적 레이블 (숫자 제거).
/// 데이터 포인트를 연결하는 라인 차트.
class TrendChartCard extends StatelessWidget {
  /// 데이터 포인트 리스트. x=인덱스(주차 순서), y=퍼센트(0~100).
  final List<FlSpot> spots;

  /// X축 레이블 리스트 (주차 레이블).
  final List<String> xLabels;

  final String? title;
  final ValueKey<String>? chartKey;

  const TrendChartCard({
    super.key,
    required this.spots,
    required this.xLabels,
    this.title,
    this.chartKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: chartKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.md),
          ],
          SizedBox(
            height: AppDimensions.trendChartHeight,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 33.3,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.trackGray,
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        String label;
                        if (value <= 0) {
                          label = AppStrings.trendYLabelLow;
                        } else if (value <= 50) {
                          label = AppStrings.trendYLabelMid;
                        } else {
                          label = AppStrings.trendYLabelHigh;
                        }
                        return Text(
                          label,
                          style: theme.textTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < xLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: AppDimensions.xs,
                            ),
                            child: Text(
                              xLabels[idx],
                              style: theme.textTheme.labelSmall,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.warmOrange,
                    barWidth: 2,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, pct, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.warmOrange,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.radarFill,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
