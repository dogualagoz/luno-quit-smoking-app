import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:luno_quit_smoking_app/features/main/application/quit_calculator.dart';

class MoneyDetailsScreen extends ConsumerWidget {
  const MoneyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maliyet Analizi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) {
          // stats.moneyValue formattan dolayı "2.500" gibi gelebilir, sayıyı bulalım
          final rawDouble = double.tryParse(stats.moneyValue.replaceAll('.', '').replaceAll(',', '')) ?? 0.0;
          final profile = ref.watch(userProfileProvider);
          final rates = profile != null ? QuitCalculator.calculateRates(profile) : null;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroStat(context, stats.moneyValue, stats.moneyDecimal, isDark),
                AppSpacing.sectionGapLarge,
                Text("Bunları Alabilirdin:", style: AppTextStyles.cardHeader),
                AppSpacing.sectionGap,
                _buildEquivalenceList(context, rawDouble, isDark),
                if (rates != null) ...[
                  AppSpacing.sectionGapLarge,
                  Text("Gelecek Projeksiyonu", style: AppTextStyles.cardHeader),
                  AppSpacing.sectionGap,
                  _buildProjections(context, rates.moneyPerSecond * 86400, isDark),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }

  Widget _buildHeroStat(BuildContext context, String value, String decimal, bool isDark) {
    return Container(
      padding: AppSpacing.cardPaddingLarge,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha:0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightChartPrimary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: Column(
        children: [
          Icon(Icons.savings_outlined, size: 48, color: AppColors.lightChartPrimary),
          const SizedBox(height: 16),
          Text("Toplam Harcanan", style: AppTextStyles.body.copyWith(color: Theme.of(context).hintColor)),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('₺', style: AppTextStyles.largeNumber.copyWith(fontSize: 32, color: AppColors.lightChartPrimary)),
              Text(value, style: AppTextStyles.largeNumber),
              Text(decimal, style: AppTextStyles.statValue.copyWith(color: Theme.of(context).hintColor)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightChartPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Saniye saniye yanıyor...", style: AppTextStyles.caption.copyWith(color: AppColors.lightChartPrimary)),
          )
        ],
      ),
    );
  }

  Widget _buildEquivalenceList(BuildContext context, double total, bool isDark) {
    final items = [
      {'title': 'Kahve', 'cost': 150.0, 'icon': Icons.coffee},
      {'title': 'Sinema Bileti', 'cost': 250.0, 'icon': Icons.local_movies},
      {'title': 'Oyun Konsolu', 'cost': 25000.0, 'icon': Icons.videogame_asset},
      {'title': 'Kaliteli Telefon', 'cost': 50000.0, 'icon': Icons.smartphone},
    ];

    return Column(
      children: items.map((item) {
        final count = (total / (item['cost'] as double)).floor();
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
                  color: AppColors.lightChartPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, color: AppColors.lightChartPrimary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] as String, style: AppTextStyles.bodySemibold),
                    Text("₺${item['cost']}", style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
              Text(
                count > 0 ? "$count adet" : "%${((total / (item['cost'] as double)) * 100).toStringAsFixed(1)}",
                style: AppTextStyles.cardHeader.copyWith(
                  color: count > 0 ? AppColors.lightChartPrimary : Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProjections(BuildContext context, double dailyCost, bool isDark) {
    final periods = [
      {'title': '1 Hafta Sonra', 'days': 7, 'icon': Icons.calendar_view_week},
      {'title': '1 Ay Sonra', 'days': 30, 'icon': Icons.calendar_month},
      {'title': '1 Yıl Sonra', 'days': 365, 'icon': Icons.calendar_today},
    ];

    return Column(
      children: periods.map((period) {
        final total = dailyCost * (period['days'] as int);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(period['icon'] as IconData, color: Colors.orangeAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Text(period['title'] as String, style: AppTextStyles.bodySemibold),
              ),
              Text(
                "₺${total.toStringAsFixed(0)}",
                style: AppTextStyles.cardHeader.copyWith(color: Colors.orangeAccent),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
