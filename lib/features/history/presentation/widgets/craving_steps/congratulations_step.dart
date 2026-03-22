import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class CongratulationsStep extends StatelessWidget {
  const CongratulationsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: successColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              color: successColor,
              size: 80,
            ),
          ),
          const SizedBox(height: AppSpacing.p32),
          Text(
            "Harikasın!",
            textAlign: TextAlign.center,
            style: AppTextStyles.cardHeader.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 16),
          Text(
            "Bugünü de dumansız kapatmayı başardın. Ciğerlerin sana teşekkür ediyor! 🫁✨",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: Theme.of(context).hintColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.p40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: successColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, color: successColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Dumansız Gün Kaydedilecek",
                  style: AppTextStyles.caption.copyWith(color: successColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
