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
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';

// --- Ekran Tanımı ve Durumu ---
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  // Filtreler: 'H' (Haftalık), 'A' (Aylık), 'Y' (Yıllık)
  String _selectedFilter = 'A';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null); // DateFormat için türkçe
  }

  @override
  Widget build(BuildContext context) {
    final historyLogsState = ref.watch(historyLogsProvider);
    final userProfile = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- Geçmiş kartları için birim sigara fiyatı hesaplama ---
    final double pricePerCigarette = (userProfile != null && userProfile.cigarettesPerPack > 0)
        ? userProfile.packPrice / userProfile.cigarettesPerPack
        : 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: historyLogsState.when(
          data: (logs) {
            if (logs.isEmpty) {
              return Center(
                child: Padding(
                  padding: AppSpacing.pageHorizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.p24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.history_edu,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.p24),
                      Text(
                        'Henüz Kayıt Yok',
                        style: AppTextStyles.pageHeader.copyWith(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: AppSpacing.p8),
                      Text(
                        "Sürecini başlatmak ve nasıl ilerlediğini görmek için ilk dürüst kaydını gir.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
              );
            }

            // --- Geçmiş Sayfası Düzeni Oluşturma ---
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

                    // --- Bugünün Özeti ve Hızlı Aksiyon Kartı ---
                    TodaySummaryCard(logs: logs),
                    const SizedBox(height: AppSpacing.p24),

                    // --- Ortalama İstatistik Masası ---
                    AverageSummaryCard(logs: logs),
                    const SizedBox(height: AppSpacing.p24),

                    // --- Analitik Grafiği (Haftalık/Aylık/Yıllık) ---
                    LunoCard(
                      padding: AppSpacing.cardPaddingLarge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedFilter == 'H'
                                    ? "Bu Hafta"
                                    : _selectedFilter == 'A'
                                        ? "Bu Ay"
                                        : "Bu Yıl",
                                style: AppTextStyles.cardHeader.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              _buildFilterButtons(isDark),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.p24),
                          HistoryBarChart(
                            data: _calculateChartData(logs),
                            filter: _selectedFilter,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.p24),
                    Text("Günlük Kayıtlar", style: AppTextStyles.cardHeader),
                    const SizedBox(height: AppSpacing.p12),

                    // --- Detaylı Aktivite Akışı (Günlük Kayıt Kartları) ---
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (ctx, index) {
                        return DailyLogCard(
                          log: logs[index],
                          pricePerCigarette: pricePerCigarette,
                        );
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

  // --- Mantık ve Veri İşleme ---

  // Seçilen filtreye (Haftalık, Aylık, Yıllık) göre grafik verilerini filtreler ve hazırlar
  Map<int, int> _calculateChartData(List<dynamic> logs) {
    final now = DateTime.now();
    Map<int, int> data = {};

    if (_selectedFilter == 'H') {
      // HAFTALIK: Pazartesiden pazara kadar
      for (int i = 1; i <= 7; i++) {
        data[i] = 0;
      }
      
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

      for (var log in logs) {
        if (_getLogType(log) == 'slip' && !log.date.isBefore(startOfDay)) {
          int weekday = log.date.weekday;
          data[weekday] = (data[weekday] ?? 0) + (log.smokeCount as int);
        }
      }
    } else if (_selectedFilter == 'A') {
      // AYLIK: Ayın günleri (1-31)
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      for (int i = 1; i <= daysInMonth; i++) {
        data[i] = 0;
      }

      final startOfMonth = DateTime(now.year, now.month, 1);

      for (var log in logs) {
        if (_getLogType(log) == 'slip' && !log.date.isBefore(startOfMonth)) {
          int day = log.date.day;
          data[day] = (data[day] ?? 0) + (log.smokeCount as int);
        }
      }
    } else {
      // YILLIK: Yılın ayları (1-12)
      for (int i = 1; i <= 12; i++) {
        data[i] = 0;
      }

      final startOfYear = DateTime(now.year, 1, 1);

      for (var log in logs) {
        if (_getLogType(log) == 'slip' && !log.date.isBefore(startOfYear)) {
          int month = log.date.month;
          data[month] = (data[month] ?? 0) + (log.smokeCount as int);
        }
      }
    }
    return data;
  }

  String _getLogType(dynamic log) {
    try {
      return log.type ?? 'craving';
    } catch (_) {
      return 'craving';
    }
  }

  // --- UI Bileşen Oluşturucuları ---

  // Grafiğin üstündeki H/A/Y filtre seçim butonlarını oluşturur
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
                  : Border.all(color: Colors.grey.withOpacity(0.3)),
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
