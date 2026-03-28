import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';

class RecoveryDetailsScreen extends ConsumerWidget {
  const RecoveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bırakmaya Hazırlık"), // İyileşme Haritası -> Bırakmaya Hazırlık
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroStat(context, stats.prepPercentage, isDark, successColor),
                AppSpacing.sectionGapLarge,
                Text("Hazırlık Seviyeni Ne Artırır?", style: AppTextStyles.cardHeader),
                AppSpacing.sectionGap,
                _buildFactorsList(context, isDark, successColor),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }

  Widget _buildHeroStat(BuildContext context, double percentage, bool isDark, Color color) {
    return Container(
      padding: AppSpacing.cardPaddingLarge,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha:0.5)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: Column(
        children: [
          Icon(Icons.rocket_launch_outlined, size: 48, color: color),
          const SizedBox(height: 16),
          Text("Bırakmaya Hazırlık Skorun", style: AppTextStyles.body.copyWith(color: Theme.of(context).hintColor)),
          const SizedBox(height: 8),
          Text(
            "%${(percentage * 100).toInt()}",
            style: AppTextStyles.largeNumber.copyWith(color: color),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 12,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorsList(BuildContext context, bool isDark, Color color) {
    final factors = [
      {'title': 'Günlük Limit Uyumu', 'desc': 'Belirlediğin günlük sigara limitinin altında kaldığın her an skorun artar.', 'icon': Icons.check_circle_outline},
      {'title': 'Kriz Yönetimi', 'desc': 'Canın sigara istediğinde içmek yerine "Kriz" butonunu kullanman iradeni güçlendirir.', 'icon': Icons.psychology_outlined},
      {'title': 'Düzenli Takip', 'desc': 'Uygulamayı her gün kullanman ve verilerini girmen kararlılığını gösterir.', 'icon': Icons.calendar_today_outlined},
      {'title': 'Zaman Kazanımı', 'desc': 'Sigara içmeyerek kazandığın her dakika seni özgürlüğe yaklaştırır.', 'icon': Icons.timer_outlined},
    ];

    return Column(
      children: factors.map((f) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Icon(f['icon'] as IconData, color: color, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f['title'] as String, style: AppTextStyles.bodySemibold),
                    const SizedBox(height: 4),
                    Text(f['desc'] as String, style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
