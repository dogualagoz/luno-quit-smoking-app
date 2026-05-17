import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

/// Weekly smoking reduction goal slider + progress bar inside the settings
/// "Sigara Bilgilerin" card.
class WeeklyGoalSection extends StatelessWidget {
  static const int maxWeeklySmoking = 140; // 20 × 7 days
  static const int _goalNotSet = 0;

  final int weeklyGoal;
  final int weeklyActual;
  final ValueChanged<double> onChanged;

  const WeeklyGoalSection({
    super.key,
    required this.weeklyGoal,
    required this.weeklyActual,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final bool goalSet = weeklyGoal > _goalNotSet;
    final double progress =
        goalSet ? (weeklyActual / weeklyGoal).clamp(0.0, 1.0) : 0.0;

    Color progressColor;
    if (!goalSet || weeklyActual == 0) {
      progressColor = AppColors.lightChartSuccess;
    } else if (progress < 0.8) {
      progressColor = AppColors.lightChartSuccess;
    } else if (progress < 1.0) {
      progressColor = AppColors.lightChartWarning;
    } else {
      progressColor = AppColors.lightDestructive;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.flag_outlined, size: 18, color: primary),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haftalık Azaltma Hedefi',
                  style: AppTextStyles.label.copyWith(color: theme.hintColor),
                ),
                Text(
                  goalSet ? '$weeklyGoal adet/hafta' : 'Hedef belirlenmedi',
                  style: AppTextStyles.bodySemibold.copyWith(
                    color: goalSet
                        ? theme.colorScheme.onSurface
                        : theme.hintColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.p12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: primary,
            inactiveTrackColor: primary.withValues(alpha: 0.15),
            thumbColor: primary,
            overlayColor: primary.withValues(alpha: 0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: (weeklyGoal / maxWeeklySmoking).clamp(0.0, 1.0),
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0',
                  style: AppTextStyles.micro.copyWith(color: theme.hintColor)),
              Text('${maxWeeklySmoking ~/ 2}',
                  style: AppTextStyles.micro.copyWith(color: theme.hintColor)),
              Text('$maxWeeklySmoking',
                  style: AppTextStyles.micro.copyWith(color: theme.hintColor)),
            ],
          ),
        ),
        if (goalSet) ...[
          const SizedBox(height: AppSpacing.p16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bu hafta: $weeklyActual içildi',
                style: AppTextStyles.caption.copyWith(color: theme.hintColor),
              ),
              Text(
                weeklyActual >= weeklyGoal
                    ? 'Hedef aşıldı 🚨'
                    : 'Hedef: $weeklyGoal',
                style: AppTextStyles.caption.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: progressColor.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ],
    );
  }
}
