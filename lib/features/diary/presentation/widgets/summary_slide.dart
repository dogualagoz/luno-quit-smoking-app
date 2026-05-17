import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

/// One page in the TodaySummaryCard swipeable PageView.
class SummarySlide extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Widget badge;
  final Widget? extra;
  final bool hasSmoked;
  final Color primaryColor;
  final Map<String, dynamic>? comparisonData;

  const SummarySlide({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.badge,
    this.extra,
    required this.hasSmoked,
    required this.primaryColor,
    this.comparisonData,
  });

  @override
  Widget build(BuildContext context) {
    final String? comparisonText = comparisonData?['text'];
    final double? percent = (comparisonData?['percent'] as num?)?.toDouble();
    final Color? comparisonColor = comparisonData?['color'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.cardHeader),
            badge,
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.largeNumber.copyWith(
                        fontSize: 56,
                        color: hasSmoked
                            ? primaryColor
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (percent != null && percent > 0)
                      Positioned(
                        top: -10,
                        right: -36,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: comparisonColor?.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "%${percent.toStringAsFixed(0)}",
                            style: AppTextStyles.micro.copyWith(
                              color: comparisonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: (percent != null && percent > 0) ? 36 : 8),
                Text(
                  unit,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (comparisonText != null) ...[
              const SizedBox(height: 4),
              Text(
                comparisonText,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        if (extra != null) ...[const SizedBox(height: AppSpacing.p12), extra!],
        const Spacer(),
      ],
    );
  }
}

/// Small colored status badge shown in the top-right of each slide.
Widget buildSlideBadge(
  String text,
  Color color,
  bool isDark, {
  IconData? icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: isDark ? 0.2 : 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

/// Inline info tag shown below the slide value.
Widget buildSlideMiniBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

/// Computes yesterday-vs-today comparison text + percent + color.
Map<String, dynamic>? getSlideComparisonData(
  BuildContext context, {
  required double current,
  required double previous,
  required String unit,
  bool isImprovementBetter = true,
  bool isCurrency = false,
}) {
  if (previous == 0 && current == 0) return null;

  final diff = current - previous;
  final isImprovement = isImprovementBetter ? diff > 0 : diff < 0;

  if (diff == 0) {
    return {'text': 'Dünle aynı', 'percent': 0.0, 'color': Colors.grey};
  }

  final absDiff = diff.abs();
  final percent = previous > 0 ? (absDiff / previous * 100) : 0.0;
  final Color color =
      isImprovement ? context.chartSuccess : context.destructive;

  String text;
  if (isCurrency) {
    text = isImprovement
        ? "düne göre ${absDiff.toStringAsFixed(0)} TL kardasın"
        : "düne göre ${absDiff.toStringAsFixed(0)} TL fazla harcadın";
  } else if (unit == "dakika") {
    text = isImprovement
        ? "düne göre $absDiff dakika kazandın"
        : "düne göre $absDiff dakika kaybettin";
  } else {
    final diffText = absDiff.toInt().toString();
    text = isImprovement
        ? "düne göre $diffText $unit az içtin"
        : "düne göre $diffText $unit fazla içtin";
  }

  return {'text': text, 'percent': percent, 'color': color};
}
