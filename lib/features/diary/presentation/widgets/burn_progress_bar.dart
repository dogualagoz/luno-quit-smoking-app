import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

/// Progress bar shown below the swipeable stat slides. Animates when the user
/// has a cigarette "still burning" (elapsed < total duration).
class BurnProgressBar extends StatelessWidget {
  final bool isBurning;
  final double activeBurnRatio;
  final Color primary;

  const BurnProgressBar({
    super.key,
    required this.isBurning,
    required this.activeBurnRatio,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isBurning ? "Paramız yanıyor... 🔥" : "Şu an güvendeyiz",
                style: AppTextStyles.micro.copyWith(
                  color: isBurning
                      ? AppColors.lightDestructive
                      : primary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isBurning)
                Text(
                  "%${(activeBurnRatio * 100).toInt()} tamamlandı",
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.lightDestructive.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: isBurning
                  ? AppColors.lightDestructive.withValues(alpha: 0.2)
                  : primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(5),
              boxShadow: isBurning
                  ? [
                      BoxShadow(
                        color:
                            AppColors.lightDestructive.withValues(alpha: 0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: isBurning ? activeBurnRatio : 1.0,
                  end: isBurning ? activeBurnRatio : 1.0,
                ),
                duration: const Duration(seconds: 1),
                builder: (context, val, _) {
                  return LinearProgressIndicator(
                    value: val,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isBurning
                          ? AppColors.lightDestructive
                          : primary.withValues(alpha: 0.3),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
