import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';

class CigarettesDetailsScreen extends ConsumerWidget {
  const CigarettesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = AppColors.lightChartWarning;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sigara Miktarı"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) {
          final rawDouble = double.tryParse(stats.countValue.replaceAll('.', '').replaceAll(',', '')) ?? 0.0;
          final distanceMeters = rawDouble * 0.085; // 8.5 cm
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroStat(context, stats.countValue, distanceMeters, isDark, warningColor),
                AppSpacing.sectionGapLarge,
                Text("Bunları Geçecek Kadar Uzun:", style: AppTextStyles.cardHeader),
                AppSpacing.sectionGap,
                _buildEquivalenceList(context, distanceMeters, isDark, warningColor),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }

  Widget _buildHeroStat(BuildContext context, String value, double distanceM, bool isDark, Color color) {
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
          Icon(Icons.smoking_rooms_outlined, size: 48, color: color),
          const SizedBox(height: 16),
          Text("İçilen Toplam Adet", style: AppTextStyles.body.copyWith(color: Theme.of(context).hintColor)),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.largeNumber.copyWith(color: color)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Uç uca: ${distanceM >= 1000 ? '${(distanceM/1000).toStringAsFixed(1)} km' : '${distanceM.toStringAsFixed(0)} m'}", style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildEquivalenceList(BuildContext context, double totalMeters, bool isDark, Color color) {
    final items = [
      {'title': 'Özgürlük Anıtı', 'cost': 93.0, 'icon': Icons.account_balance},
      {'title': 'Eyfel Kulesi', 'cost': 300.0, 'icon': Icons.architecture},
      {'title': 'Burj Khalifa', 'cost': 828.0, 'icon': Icons.domain},
      {'title': 'Everest Dağı', 'cost': 8848.0, 'icon': Icons.landscape},
    ];

    return Column(
      children: items.map((item) {
        final cost = item['cost'] as double;
        final count = (totalMeters / cost).floor();
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
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] as String, style: AppTextStyles.bodySemibold),
                    Text("${cost}m Yükseklik", style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
              Text(
                count > 0 ? "$count kez" : "%${((totalMeters / cost) * 100).toStringAsFixed(1)}",
                style: AppTextStyles.cardHeader.copyWith(
                  color: count > 0 ? color : Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
