import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_progress_bar.dart';

class DamageCard extends StatelessWidget {
  final String title;
  final String description;
  final String quote;
  final double damagePercentage;
  final IconData icon;
  final List<Color> gradientColors;
  const DamageCard({
    super.key,
    required this.title,
    required this.description,
    required this.quote,
    required this.damagePercentage,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return LunoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Sütun: İkon
          Container(
            padding: AppSpacing.iconPadding,
            decoration: BoxDecoration(
              color: gradientColors.first.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: gradientColors.first, size: 24),
          ),
          const SizedBox(width: AppSpacing.p12),

          // 2. Sütun: Geri kalan içerik
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık ve Yüzde
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "%${(damagePercentage * 100).toInt()}",
                      style: textTheme.titleSmall?.copyWith(
                        color: gradientColors.first.withValues(alpha: 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // Alt açıklama
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: theme.hintColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),

                // Progress Bar
                LunoProgressBar(
                  value: damagePercentage,
                  height: 8,
                  gradientColors: gradientColors,
                  backgroundColor: gradientColors.first.withValues(alpha: 0.05),
                ),
                const SizedBox(height: 6),

                // Quote
                Text(
                  '"$quote"',
                  style: textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: theme.hintColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
