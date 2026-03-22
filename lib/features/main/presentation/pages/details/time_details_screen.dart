import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';

class TimeDetailsScreen extends ConsumerWidget {
  const TimeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Zaman Analizi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) {
          // timeDigits = [gün1, gün2, saat1, saat2, dk1, dk2, sn1, sn2]
          final days = int.parse(stats.timeDigits[0] + stats.timeDigits[1]);
          final hours = int.parse(stats.timeDigits[2] + stats.timeDigits[3]);
          final totalHours = (days * 24) + hours;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroStat(context, stats.timeDigits, isDark),
                AppSpacing.sectionGapLarge,
                Text("Bunun Yerine Ne Yapabilirdin?", style: AppTextStyles.cardHeader),
                AppSpacing.sectionGap,
                _buildEquivalenceList(context, totalHours, isDark),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }

  Widget _buildHeroStat(BuildContext context, List<String> digits, bool isDark) {
    return Container(
      padding: AppSpacing.cardPaddingLarge,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha:0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: Column(
        children: [
          const Icon(Icons.timer_outlined, size: 48, color: Colors.blueGrey),
          const SizedBox(height: 16),
          Text("Toplam Kayıp", style: AppTextStyles.body.copyWith(color: Theme.of(context).hintColor)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("${digits[0]}${digits[1]}", style: AppTextStyles.largeNumber),
              Text("g ", style: AppTextStyles.statValue.copyWith(color: Colors.blueGrey)),
              Text("${digits[2]}${digits[3]}", style: AppTextStyles.largeNumber),
              Text("s ", style: AppTextStyles.statValue.copyWith(color: Colors.blueGrey)),
              Text("${digits[4]}${digits[5]}", style: AppTextStyles.largeNumber),
              Text("d", style: AppTextStyles.statValue.copyWith(color: Theme.of(context).hintColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquivalenceList(BuildContext context, int totalHours, bool isDark) {
    final items = [
      {'title': 'Kitap Okuma', 'cost': 5, 'unit': 'kitap', 'icon': Icons.menu_book}, // 5 saat/kitap
      {'title': 'Film İzleme', 'cost': 2, 'unit': 'film', 'icon': Icons.movie}, // 2 saat/film
      {'title': 'Yeni Dil Öğrenme', 'cost': 480, 'unit': 'dil (Temel)', 'icon': Icons.language}, // 480 saat
    ];

    return Column(
      children: items.map((item) {
        final count = (totalHours / (item['cost'] as int)).floor();
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
             color: isDark ? AppColors.darkCard : AppColors.lightCard,
             borderRadius: BorderRadius.circular(16),
             border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, color: Colors.blueGrey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] as String, style: AppTextStyles.bodySemibold),
                    Text("\u2248 ${item['cost']} saat", style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
              Text(
                count > 0 ? "$count ${item['unit']}" : "%${((totalHours / (item['cost'] as int)) * 100).toStringAsFixed(1)}",
                style: AppTextStyles.cardHeader.copyWith(
                  color: count > 0 ? Colors.blueGrey : Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
