import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';

class TodaySummaryCard extends StatelessWidget {
  final List<dynamic> logs;

  const TodaySummaryCard({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final todayLogs = logs.where((log) {
      final now = DateTime.now();
      return log.date.year == now.year &&
          log.date.month == now.month &&
          log.date.day == now.day;
    }).toList();

    // Sadece slip tipindeki kayıtlar sigara sayacını artırır
    final int todaySmoked = todayLogs
        .where((log) => _getLogType(log) == 'slip')
        .fold(0, (sum, log) => sum + (log.smokeCount as int));
    
    final int todayCravings = todayLogs
        .where((log) => _getLogType(log) == 'craving')
        .fold(0, (sum, _) => sum + 1);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasSmokedToday = todaySmoked > 0;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final successColor = isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;

    final cardBgColor = hasSmokedToday
        ? primary.withValues(alpha: 0.05)
        : Theme.of(context).cardColor;

    final borderColor = hasSmokedToday
        ? primary.withValues(alpha: 0.3)
        : Colors.transparent;

    return LunoCard(
      padding: EdgeInsets.zero,
      child: Container(
        padding: AppSpacing.cardPaddingLarge,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık + Rozet
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bugünün Özeti",
                  style: AppTextStyles.cardHeader.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (hasSmokedToday)
                  _buildBadge("Kayıp", primary, isDark)
                else
                  _buildBadge("Temiz", successColor, isDark, icon: Icons.star),
              ],
            ),
            const SizedBox(height: AppSpacing.p24),

            // Sigara Sayısı
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  todaySmoked.toString(),
                  style: AppTextStyles.largeNumber.copyWith(
                    fontSize: 56,
                    color: hasSmokedToday ? primary : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "sigara",
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            // Kriz Direnç Bilgisi
            if (todayCravings > 0) ...[
              const SizedBox(height: AppSpacing.p12),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield_outlined, size: 16, color: successColor),
                      const SizedBox(width: 6),
                      Text(
                        "$todayCravings krize direndin",
                        style: AppTextStyles.caption.copyWith(
                          color: successColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.p24),

            // Kayıt Ekle Butonu (→ SlipLogScreen)
            SizedBox(
              width: double.infinity,
              child: LunoButton(
                text: "Kayıt Ekle",
                icon: Icons.add_circle_outline,
                onPressed: () {
                  context.push(AppRouter.slipLog);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.p16),

            // Alt Mesaj
            Center(
              child: Text(
                hasSmokedToday
                    ? "Zararın neresinden dönersen kârdır. Kaydettiğin sürece ilerliyorsun."
                    : "Tertemiz! Bugün duman yok, hedefe bir adım daha yakınsın.",
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color, bool isDark, {IconData? icon}) {
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

  /// Eski kayıtlarda type null olabilir, güvenli erişim
  String _getLogType(dynamic log) {
    try {
      return log.type ?? 'craving';
    } catch (_) {
      return 'craving';
    }
  }
}
