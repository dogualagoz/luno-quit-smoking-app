import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/features/history/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/history/presentation/widgets/daily_log_card.dart';
import 'package:luno_quit_smoking_app/features/history/presentation/widgets/history_bar_chart.dart';
import 'package:luno_quit_smoking_app/features/history/presentation/widgets/today_summary_card.dart';
import 'package:luno_quit_smoking_app/features/history/presentation/widgets/average_summary_card.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _selectedFilter = 'A'; // 'H' (Haftalık), 'A' (Aylık), 'Y' (Yıllık)

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null); // DateFormat için türkçe
  }

  @override
  Widget build(BuildContext context) {
    final historyLogsState = ref.watch(historyLogsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: historyLogsState.when(
          data: (logs) {
            if (logs.isEmpty) {
              return const Center(child: Text("Henüz hiç kayıt girmedin."));
            }

            // Grafik verisini hazırla (Son 7 gün için mock/hesaplama)
            final Map<int, int> chartData = _calculateWeeklyData(logs);

            return SingleChildScrollView(
              child: Padding(
                padding: AppSpacing.pageHorizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.p24),
                    Text('Geçmiş & Kayıt 📋', style: AppTextStyles.header),
                    const SizedBox(height: 8),
                    Text(
                      "Gerçeklerle yüzleşmenin en acı yolu: rakamlar.",
                      style: AppTextStyles.body.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: AppSpacing.p24),

                    // Bugün Kartı (Tekrar İçtim butonu ile)
                    TodaySummaryCard(logs: logs),
                    const SizedBox(height: AppSpacing.p24),

                    // Ortalama Kartı (Haftalık)
                    AverageSummaryCard(logs: logs),
                    const SizedBox(height: AppSpacing.p24),

                    // Sütun Grafiği Kartı
                    LunoCard(
                      padding: AppSpacing.cardPaddingLarge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bu Hafta",
                                style: AppTextStyles.cardHeader.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              _buildFilterButtons(isDark),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.p24),
                          HistoryBarChart(weeklyData: chartData),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.p24),
                    Text("Günlük Kayıtlar", style: AppTextStyles.cardHeader),
                    const SizedBox(height: AppSpacing.p12),

                    // Liste Kartları
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (ctx, index) {
                        return DailyLogCard(log: logs[index]);
                      },
                    ),

                    const SizedBox(
                      height: AppSpacing.p96,
                    ), // Bottom nav için boşluk
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Hata oluştu: $err")),
        ),
      ),
    );
  }

  // Son 7 günün içim verilerini bul (basit mantık: 1=Pzt, 7=Paz)
  Map<int, int> _calculateWeeklyData(List<dynamic> logs) {
    Map<int, int> data = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    final now = DateTime.now();
    for (var log in logs) {
      if (now.difference(log.date).inDays <= 7) {
        int weekday = log.date.weekday; // 1 = Pzt, 7 = Paz
        data[weekday] = (data[weekday] ?? 0) + log.smokeCount as int;
      }
    }
    return data;
  }

  Widget _buildFilterButtons(bool isDark) {
    return Row(
      children: ['H', 'A', 'Y'].map((filter) {
        bool isSelected = _selectedFilter == filter;
        return GestureDetector(
          onTap: () => setState(() => _selectedFilter = filter),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                        ? AppColors.darkChartPrimary
                        : AppColors.lightChartPrimary)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Text(
              filter,
              style: AppTextStyles.label.copyWith(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
