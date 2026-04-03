import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/score_calculator.dart';

/// 레이더 차트 카드 위젯 (디자인컴포넌트 2-2-6, 2-5-1).
/// 6영역 데이터를 200x200dp 레이더 차트로 시각화한다.
/// 데이터 영역: radarFill(warmOrange 20% 불투명) 채움, warmOrange 2px 테두리.
///
/// Vitality 강화: 진입 시 0에서 실제 값으로 확장하는 애니메이션 (800ms, easeOutCubic).
class RadarChartCard extends StatefulWidget {
  /// 영역별 점수 Map. key: domain ID, value: 0~12
  final Map<String, int> domainScores;
  final ValueKey<String>? chartKey;

  const RadarChartCard({
    super.key,
    required this.domainScores,
    this.chartKey,
  });

  // Enlarged chart container to give labels more room.
  static const double _chartContainerSize = 260.0;

  @override
  State<RadarChartCard> createState() => _RadarChartCardState();
}

class _RadarChartCardState extends State<RadarChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    // Start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _animController.forward();
    });
  }

  @override
  void didUpdateWidget(covariant RadarChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-animate when data changes
    if (widget.domainScores != oldWidget.domainScores) {
      _animController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: widget.chartKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.adaptiveLow(isDark),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Center(
        child: SizedBox(
          width: RadarChartCard._chartContainerSize,
          height: RadarChartCard._chartContainerSize,
          child: AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: _RadarChartPainter(
                  domainScores: widget.domainScores,
                  isDark: isDark,
                  animationProgress: _expandAnimation.value,
                ),
                child: _buildLabels(theme),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabels(ThemeData theme) {
    const labels = AppStrings.radarLabels;
    final center = RadarChartCard._chartContainerSize / 2;
    // Label radius: sits outside the chart polygon area with ample room.
    final labelRadius = center - 10;

    return Stack(
      clipBehavior: Clip.none,
      children: List.generate(6, (i) {
        final angle = -math.pi / 2 + (2 * math.pi / 6) * i;
        final x = center + labelRadius * math.cos(angle);
        final y = center + labelRadius * math.sin(angle);

        return Positioned(
          left: x - 40,
          top: y - 10,
          child: SizedBox(
            width: 80,
            child: Text(
              labels[i],
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ),
        );
      }),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final Map<String, int> domainScores;
  final bool isDark;
  final double animationProgress;

  _RadarChartPainter({
    required this.domainScores,
    required this.isDark,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 50; // Leave ample room for labels

    // Draw grid circles
    final gridPaint = Paint()
      ..color = (isDark ? AppColors.darkBorder : AppColors.trackGray)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 1; i <= 4; i++) {
      final gridRadius = radius * (i / 4);
      _drawPolygon(canvas, center, gridRadius, 6, gridPaint);
    }

    // Draw axes
    for (int i = 0; i < 6; i++) {
      final angle = -math.pi / 2 + (2 * math.pi / 6) * i;
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, end, gridPaint);
    }

    // Draw data area with animation progress
    final domains = ScoreCalculator.domains;
    final dataPath = Path();
    for (int i = 0; i < 6; i++) {
      final score = domainScores[domains[i]] ?? 0;
      final fraction = (score / 12.0) * animationProgress;
      final angle = -math.pi / 2 + (2 * math.pi / 6) * i;
      final point = Offset(
        center.dx + radius * fraction * math.cos(angle),
        center.dy + radius * fraction * math.sin(angle),
      );
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();

    // Fill with radarFill
    final fillPaint = Paint()
      ..color = AppColors.radarFill
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Border with warmOrange
    final borderPaint = Paint()
      ..color = AppColors.warmOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(dataPath, borderPaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = AppColors.warmOrange
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 6; i++) {
      final score = domainScores[domains[i]] ?? 0;
      final fraction = (score / 12.0) * animationProgress;
      final angle = -math.pi / 2 + (2 * math.pi / 6) * i;
      final point = Offset(
        center.dx + radius * fraction * math.cos(angle),
        center.dy + radius * fraction * math.sin(angle),
      );
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  void _drawPolygon(
      Canvas canvas, Offset center, double radius, int sides, Paint paint) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = -math.pi / 2 + (2 * math.pi / sides) * i;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return domainScores != oldDelegate.domainScores ||
        isDark != oldDelegate.isDark ||
        animationProgress != oldDelegate.animationProgress;
  }
}
