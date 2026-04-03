import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/observation_interpreter.dart';
import '../../../core/widgets/text_link_button.dart';
import '../../../providers/observation_providers.dart';

/// 이번 주 관찰 결과 카드 (2-2-6).
/// 데이터 있을 때: 안심 메시지 + 해석 결과
/// 데이터 없을 때: 빈 상태 카드 (긍정적 톤)
class ObservationSummaryCard extends ConsumerWidget {
  /// 6개 영역의 점수 (0.0 ~ 1.0). null이면 Provider 데이터를 사용.
  final List<double>? scores;

  const ObservationSummaryCard({
    super.key,
    this.scores,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final latestObs = ref.watch(latestObservationProvider);

    // scores가 명시적으로 전달되면 우선 사용
    if (scores != null && scores!.isNotEmpty) {
      return _buildWithRadarData(context, theme);
    }

    // Provider에서 최근 관찰 기록 확인
    return latestObs.when(
      data: (record) {
        if (record == null) {
          return _buildEmptyState(context, theme);
        }
        return _buildWithObservationData(context, theme, record.interpretationLevel);
      },
      loading: () => _buildEmptyState(context, theme),
      error: (_, __) => _buildEmptyState(context, theme),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: const ValueKey('observation_summary_card'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.xl,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        key: const ValueKey('empty_observation_card'),
        mainAxisSize: MainAxisSize.min,
        children: [
          // Larger icon in tinted circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.warmOrange.withValues(alpha: isDark ? 0.12 : 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco,
              size: 48,
              color: AppColors.warmOrange.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppDimensions.base),
          Text(
            AppStrings.emptyObservation,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 관찰 데이터가 있을 때 안심 메시지 + 해석 결과를 표시한다.
  Widget _buildWithObservationData(
      BuildContext context, ThemeData theme, int level) {
    final isDark = theme.brightness == Brightness.dark;
    final message = ObservationInterpreter.getTitle(level);
    final icon = ObservationInterpreter.getIcon(level);
    final iconColor = ObservationInterpreter.getIconColor(level);

    return Container(
      key: const ValueKey('observation_summary_card'),
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
          // 안심 메시지
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  AppStrings.observationReassurance,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          // 해석 결과 메시지
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBg : AppColors.mintTint,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          // 더보기 링크
          TextLinkButton(
            label: AppStrings.moreLink,
            buttonKey: const ValueKey('observation_more_link'),
            onPressed: () {
              // TODO: 발달 체크 상세 화면 네비게이션
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWithRadarData(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      key: const ValueKey('observation_summary_card'),
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
          // 안심 메시지
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 20,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  AppStrings.observationReassurance,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.base),

          // 레이더 차트 미니 (200x200) - enlarged to prevent label clipping
          Center(
            child: SizedBox(
              key: const ValueKey('radar_chart_mini'),
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: _RadarChartPainter(
                  scores: scores!,
                  fillColor: AppColors.radarFill,
                  strokeColor: AppColors.warmOrange,
                  gridColor: theme.dividerColor,
                  labelColor:
                      theme.textTheme.bodySmall?.color ?? AppColors.warmGray,
                  labelFontSize: 9,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // 더보기 링크
          TextLinkButton(
            label: AppStrings.moreLink,
            buttonKey: const ValueKey('observation_more_link'),
            onPressed: () {
              // TODO: 발달 체크 상세 화면 네비게이션
            },
          ),
        ],
      ),
    );
  }
}

/// 6영역 레이더 차트 CustomPainter.
/// 6 꼭짓점: 몸 움직임, 감각 반응, 집중과 관심, 소리와 표현, 마음과 관계, 생활 리듬.
class _RadarChartPainter extends CustomPainter {
  final List<double> scores;
  final Color fillColor;
  final Color strokeColor;
  final Color gridColor;
  final Color labelColor;
  final double labelFontSize;

  _RadarChartPainter({
    required this.scores,
    required this.fillColor,
    required this.strokeColor,
    required this.gridColor,
    required this.labelColor,
    required this.labelFontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 36; // More room for labels
    final sides = 6;
    final angle = 2 * math.pi / sides;

    // 그리드 그리기
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (var level = 1; level <= 3; level++) {
      final r = radius * level / 3;
      final path = Path();
      for (var i = 0; i < sides; i++) {
        final x = center.dx + r * math.cos(angle * i - math.pi / 2);
        final y = center.dy + r * math.sin(angle * i - math.pi / 2);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // 축 선 그리기
    for (var i = 0; i < sides; i++) {
      final x = center.dx + radius * math.cos(angle * i - math.pi / 2);
      final y = center.dy + radius * math.sin(angle * i - math.pi / 2);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }

    // 데이터 채움 영역 그리기
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final dataPath = Path();
    for (var i = 0; i < sides; i++) {
      final value = i < scores.length ? scores[i].clamp(0.0, 1.0) : 0.0;
      final r = radius * value;
      final x = center.dx + r * math.cos(angle * i - math.pi / 2);
      final y = center.dy + r * math.sin(angle * i - math.pi / 2);
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, strokePaint);

    // 레이블 그리기 - use constrained layout to prevent clipping
    for (var i = 0; i < sides; i++) {
      final labelRadius = radius + 18;
      final x = center.dx + labelRadius * math.cos(angle * i - math.pi / 2);
      final y = center.dy + labelRadius * math.sin(angle * i - math.pi / 2);

      final textPainter = TextPainter(
        text: TextSpan(
          text: AppStrings.radarLabels[i],
          style: TextStyle(
            fontSize: labelFontSize.clamp(0, 9),
            color: labelColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 80);

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return scores != oldDelegate.scores ||
        labelFontSize != oldDelegate.labelFontSize;
  }
}
