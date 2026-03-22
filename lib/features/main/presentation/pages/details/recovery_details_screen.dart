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
        title: const Text("İyileşme Haritası"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) {
          // stats.totalDamageScore gives us an idea of severity.
          // In a real medical app, timeline is rigid based on quit time.
          // Since they haven't quit yet ideally, we show them what HAPPENS if they quit NOW.
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroStat(context, stats.recoveryYears, stats.recoveryMonths, isDark, successColor),
                AppSpacing.sectionGapLarge,
                Text("Şimdi Bırakırsan Ne Olur?", style: AppTextStyles.cardHeader),
                AppSpacing.sectionGap,
                _buildTimelineList(context, isDark, successColor),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }

  Widget _buildHeroStat(BuildContext context, int years, int months, bool isDark, Color color) {
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
          Icon(Icons.monitor_heart_outlined, size: 48, color: color),
          const SizedBox(height: 16),
          Text("Tam İyileşme İçin Toplam Süre", style: AppTextStyles.body.copyWith(color: Theme.of(context).hintColor)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (years > 0) ...[
                Text("$years", style: AppTextStyles.largeNumber.copyWith(color: color)),
                Text("yıl ", style: AppTextStyles.statValue.copyWith(color: Theme.of(context).hintColor)),
              ],
              Text("$months", style: AppTextStyles.largeNumber.copyWith(color: color)),
              Text("ay", style: AppTextStyles.statValue.copyWith(color: Theme.of(context).hintColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList(BuildContext context, bool isDark, Color color) {
    final timeline = [
      {'time': '20 Dakika', 'desc': 'Kalp atış hızı normale döner.'},
      {'time': '12 Saat', 'desc': 'Kandaki karbonmonoksit seviyesi normale döner.'},
      {'time': '2 Hafta', 'desc': 'Kalp kriz riski düşmeye başlar, akciğerler güçlenir.'},
      {'time': '1-9 Ay', 'desc': 'Öksürük ve nefes darlığı azalır.'},
      {'time': '1 Yıl', 'desc': 'Koroner kalp hastalığı riski yarıya iner.'},
      {'time': '5 Yıl', 'desc': 'Ağız, gırtlak ve mesane kanseri riski yarı yarıya düşer.'},
      {'time': '10 Yıl', 'desc': 'Akciğer kanserinden ölüm riski yarıya düşer.'},
      {'time': '15 Yıl', 'desc': 'Kalp krizi riski hiç içmeyen biriyle aynı olur.'},
    ];

    return Column(
      children: List.generate(timeline.length, (index) {
        final item = timeline[index];
        return IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                      ),
                    ),
                    if (index != timeline.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: color.withValues(alpha: 0.3),
                        ),
                      )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                     color: isDark ? AppColors.darkCard : AppColors.lightCard,
                     borderRadius: BorderRadius.circular(16),
                     border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['time']!, style: AppTextStyles.cardHeader.copyWith(color: color)),
                      const SizedBox(height: 4),
                      Text(item['desc']!, style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
