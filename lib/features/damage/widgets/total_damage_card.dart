import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class TotalDamageCard extends StatelessWidget {
  final double damageScore; // 0.0 - 1.0 (örn: 0.56)
  final String subtext; // "847 günde birikmiş toplam hasar"

  const TotalDamageCard({
    super.key,
    required this.damageScore,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return LunoCard(
      // Arka plana çok hafif bir kırmızımsı ton vererek öne çıkaralım
      color: AppColors.lightDestructive.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sol Taraf: Metinler
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Genel Hasar Skoru",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtext,
                  style: textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),

          // Sağ Taraf: Dairesel Progress Bar
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: damageScore.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: theme.colorScheme.secondary.withValues(
                    alpha: 0.1,
                  ),
                  color: AppColors.lightDestructive.withValues(alpha: 1),
                  strokeCap: StrokeCap.round, // Çubukların ucu yuvarlak olsun
                ),
              ),
              Text(
                "%${(damageScore * 100).toInt()}",
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
