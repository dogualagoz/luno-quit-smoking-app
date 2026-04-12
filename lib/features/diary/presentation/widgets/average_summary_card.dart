import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class AverageSummaryCard extends StatelessWidget {
  final List<dynamic> logs;

  const AverageSummaryCard({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Son 7 gün (Şu anki hafta) ortalamasını hesapla
    final now = DateTime.now();
    final todayStr = DateTime(now.year, now.month, now.day);

    final currentWeekLogs = logs.where((log) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);
      final diff = todayStr.difference(logDate).inDays;
      return diff >= 0 && diff < 7;
    }).toList();

    // Önceki 7 gün (Geçen hafta) ortalamasını hesapla
    final previousWeekLogs = logs.where((log) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);
      final diff = todayStr.difference(logDate).inDays;
      return diff >= 7 && diff < 14;
    }).toList();

    final int currentTotal = currentWeekLogs.fold(
      0,
      (sum, log) => sum + (log.smokeCount as int),
    );
    final double currentAvg = currentWeekLogs.isEmpty
        ? 0
        : currentTotal / currentWeekLogs.length;

    final int previousTotal = previousWeekLogs.fold(
      0,
      (sum, log) => sum + (log.smokeCount as int),
    );
    final double previousAvg = previousWeekLogs.isEmpty
        ? 0
        : previousTotal / previousWeekLogs.length;

    // Eğer geçici olarak diff test etmek istersen diff = 3 diyebilirsin, ben gerçek formül veriyorum.
    // Şuanlık test için logs içi doldurulmamışsa mock gösterebiliriz. Demo için:
    final bool isMocking = logs.isEmpty;
    final double diff = isMocking ? -3 : currentAvg - previousAvg;
    final double displayAvg = isMocking ? 10 : currentAvg;

    // Durum analizi (Azaldıysa iyi, arttıysa kötü)
    final bool isDecreased = diff < 0;
    final bool isIncreased = diff > 0;

    Color cardColor;
    Color trendContentColor;
    IconData trendIcon;
    IconData trendArrowIcon;
    String trendText;
    String motivationText;

    if (isDecreased) {
      cardColor = isDark
          ? AppColors.darkChartSuccess
          : AppColors.lightChartSuccess;
      trendContentColor = cardColor;
      trendIcon = Icons.trending_down;
      trendArrowIcon = Icons.arrow_downward;
      trendText = "${diff.abs().toStringAsFixed(0)} azaldı";
      motivationText = "Azalma var! Küçük adımlar, büyük değişimler. 🌱";
    } else if (isIncreased) {
      cardColor = isDark
          ? AppColors.darkDestructive
          : AppColors.lightDestructive;
      trendContentColor = cardColor;
      trendIcon = Icons.trending_up;
      trendArrowIcon = Icons.arrow_upward;
      trendText = "${diff.abs().toStringAsFixed(0)} arttı";
      motivationText = "Biraz artış var. Ama kontrol hala sende! 💪";
    } else {
      cardColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
      trendContentColor = Colors.grey;
      trendIcon = Icons.trending_flat;
      trendArrowIcon = Icons.remove;
      trendText = "0 değişti";
      motivationText = "Geçen haftayla aynısın. Şimdi azaltma zamanı!";
    }

    return LunoCard(
      padding: AppSpacing.cardPaddingLarge,
      color: cardColor.withValues(alpha: 0.3),
      border: Border.all(color: cardColor.withValues(alpha: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Haftalık Ortalama",
                style: AppTextStyles.cardHeader.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    displayAvg.toStringAsFixed(0),
                    style: AppTextStyles.largeNumber.copyWith(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "sigara/gün",
                    style: AppTextStyles.body.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              // Sağda yer alan trend yönelimi (Screenshot ile aynı)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(trendIcon, color: trendContentColor, size: 22),
                  const SizedBox(width: 2),
                  Icon(trendArrowIcon, color: trendContentColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    trendText,
                    style: AppTextStyles.label.copyWith(
                      color: trendContentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            motivationText,
            style: AppTextStyles.bodySemibold.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
