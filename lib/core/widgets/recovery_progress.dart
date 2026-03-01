import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class RecoveryProgress extends StatelessWidget {
  final double progress;
  final String progressText;
  final String statusText;

  const RecoveryProgress({
    super.key,
    required this.progress,
    required this.progressText,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Sistem temasına göre dark ve ya light
    final colors = theme.brightness == Brightness.dark
        ? AppColors.gradientSuccessDark
        : AppColors.gradientSuccessLight;

    return LunoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSpacing.iconPadding,
                decoration: BoxDecoration(
                  color: colors.first.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.monitor_heart_rounded,
                  size: 20,
                  color: colors.last,
                ),
              ),
              const SizedBox(width: AppSpacing.p12),
              Text("Toparlanma İlerlemesi", style: textTheme.titleMedium),
            ],
          ),
          AppSpacing.sectionGap,
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.3),
                  borderRadius: AppRadius.progressBar,
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors),
                    borderRadius: AppRadius.progressBar,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(progressText, style: textTheme.bodySmall),
              Row(
                children: [
                  Text(statusText, style: textTheme.bodySmall),
                  const SizedBox(width: 4),
                  const Text("🌱", style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
