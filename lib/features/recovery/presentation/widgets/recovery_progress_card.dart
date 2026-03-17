import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_progress_bar.dart';

class RecoveryProgressCard extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final int completedMilestones;
  final int totalMilestones;

  const RecoveryProgressCard({
    super.key,
    required this.progress,
    required this.completedMilestones,
    required this.totalMilestones,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progressPercent = (progress * 100).toInt();
    final successGradients = isDark
        ? AppColors.gradientSuccessDark
        : AppColors.gradientSuccessLight;

    return LunoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Genel İlerleme", style: AppTextStyles.cardHeader),
              Text(
                "%$progressPercent",
                style: AppTextStyles.cardHeader.copyWith(
                  color: isDark
                      ? AppColors.darkChartSuccess
                      : AppColors.lightChartSuccess,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p12),

          // Mevcut LunoProgressBar'ı kullanıyoruz
          LunoProgressBar(
            value: progress,
            height: 12,
            gradientColors: successGradients,
            backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.3),
          ),

          const SizedBox(height: AppSpacing.p12),
          Text(
            "$completedMilestones/$totalMilestones kilometre taşı geçildi. Daha çok yol var ama her adım sayılır.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
