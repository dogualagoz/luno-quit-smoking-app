import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_error_widget.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/daily_log_card.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/history_bar_chart.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/today_summary_card.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';

// --- Haftalık takvim offset sabiti (başlangıç: Pazartesi) ---
const int _kStartOfWeekDay = 1; // Pazartesi = 1

// --- Ekran Tanımı ve Durumu ---
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  // Filtreler: 'H' (Haftalık), 'A' (Aylık), 'Y' (Yıllık)
  String _selectedFilter = 'A';

  // Haftalık takvim için kaçıncı haftayı gösteriyoruz (0 = bu hafta, -1 = geçen hafta...)
  int _weekOffset = 0;

  // Seçili gün (takvimde tıklanan gün)
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null); // DateFormat için türkçe
  }

  /// Gösterilen haftanın Pazartesi gününü döndürür
  DateTime _weekStart() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Haftanın başı: bugün - (weekday-1) + offset*7
    return today.subtract(
      Duration(days: today.weekday - _kStartOfWeekDay) -
          Duration(days: _weekOffset * 7),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyLogsState = ref.watch(historyLogsProvider);
    final userProfile = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- Geçmiş kartları için birim sigara fiyatı hesaplama ---
    final double pricePerCigarette =
        (userProfile != null && userProfile.cigarettesPerPack > 0)
            ? userProfile.packPrice / userProfile.cigarettesPerPack
            : 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: historyLogsState.when(
          data: (logs) {
            if (logs.isEmpty) {
              return _buildEmptyState(theme);
            }

            // --- Günlük Sayfası Düzeni ---
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: AppSpacing.pageHorizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.p24),

                    // --- Sayfa Başlığı ---
                    Text('Günlüğüm 📖', style: AppTextStyles.header),
                    const SizedBox(height: 8),
                    Text(
                      'Atılan her adım, yazılan her satır daha temiz bir geleceğe.',
                      style:
                          AppTextStyles.body.copyWith(color: theme.hintColor),
                    ),
                    const SizedBox(height: AppSpacing.p24),

                    // --- Bugünün Özeti ---
                    TodaySummaryCard(logs: logs),
                    const SizedBox(height: AppSpacing.p24),

                    // --- İstatistik Grafiği ---
                    _buildCombinedChartCard(logs, theme, isDark),
                    const SizedBox(height: AppSpacing.p24),

                    // --- Haftalık Takvim Başlığı ---
                    _buildCalendarSection(logs, pricePerCigarette, theme),

                    const SizedBox(height: AppSpacing.p96),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => LunoErrorWidget(
            onRetry: () => ref.invalidate(historyLogsProvider),
          ),
        ),
      ),
    );
  }

  // --- Boş Durum Widget'ı ---
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppSpacing.pageHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.p24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.p24),
            Text(
              'Henüz Kayıt Yok',
              style: AppTextStyles.pageHeader
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.p8),
            Text(
              'Sürecini başlatmak ve nasıl ilerlediğini görmek için ilk dürüst kaydını gir.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }

  // --- Haftalık Takvim + Detay Bölümü ---
  Widget _buildCalendarSection(
    List<DailyLog> logs,
    double pricePerCigarette,
    ThemeData theme,
  ) {
    final weekStart = _weekStart();
    final weekDays = List.generate(
      7,
      (i) => weekStart.add(Duration(days: i)),
    );

    // Bu haftada log olan günleri bul
    final Set<String> loggedDays = logs.map((log) {
      final d = log.date;
      return '${d.year}-${d.month}-${d.day}';
    }).toSet();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Seçili günün logları
    List<DailyLog> selectedDayLogs = [];
    if (_selectedDay != null) {
      selectedDayLogs = logs
          .where((log) =>
              log.date.year == _selectedDay!.year &&
              log.date.month == _selectedDay!.month &&
              log.date.day == _selectedDay!.day)
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bölüm başlığı
        Text('Günler', style: AppTextStyles.cardHeader),
        const SizedBox(height: AppSpacing.p12),

        LunoCard(
          child: Column(
            children: [
              // Hafta başlığı + ok navigasyonu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Önceki hafta oku
                  _buildWeekArrow(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => setState(() => _weekOffset--),
                  ),

                  // Hafta aralığı metni
                  Text(
                    _formatWeekRange(weekStart),
                    style: AppTextStyles.bodySemibold.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: 13,
                    ),
                  ),

                  // Sonraki hafta oku (gelecek haftaya geçilmez)
                  _buildWeekArrow(
                    icon: Icons.chevron_right_rounded,
                    onTap: _weekOffset < 0
                        ? () => setState(() => _weekOffset++)
                        : null,
                    disabled: _weekOffset >= 0,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.p16),

              // 7 günlük hücre satırı
              Row(
                children: weekDays.asMap().entries.map((entry) {
                  final day = entry.value;
                  final dayKey = '${day.year}-${day.month}-${day.day}';
                  final hasLog = loggedDays.contains(dayKey);
                  final isToday = day == today;
                  final isSelected = _selectedDay != null &&
                      day.year == _selectedDay!.year &&
                      day.month == _selectedDay!.month &&
                      day.day == _selectedDay!.day;
                  final isFuture = day.isAfter(today);

                  return Expanded(
                    child: GestureDetector(
                      onTap: isFuture
                          ? null
                          : () => setState(() {
                                _selectedDay =
                                    isSelected ? null : day;
                              }),
                      child: _CalendarDayCell(
                        day: day,
                        hasLog: hasLog,
                        isToday: isToday,
                        isSelected: isSelected,
                        isFuture: isFuture,
                        primary: theme.colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Seçili günün detayları
        if (_selectedDay != null) ...[
          const SizedBox(height: AppSpacing.p16),
          _buildSelectedDayDetail(
            selectedDayLogs,
            pricePerCigarette,
            theme,
          ),
        ],
      ],
    );
  }

  // Hafta aralığı metin formatı — "1–7 May 2026" gibi
  String _formatWeekRange(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final startStr =
        DateFormat('d MMM', 'tr_TR').format(weekStart);
    final endStr = DateFormat('d MMM yyyy', 'tr_TR').format(weekEnd);
    return '$startStr – $endStr';
  }

  // Ok butonu
  Widget _buildWeekArrow({
    required IconData icon,
    VoidCallback? onTap,
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: disabled
              ? Colors.transparent
              : Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: disabled
              ? Theme.of(context).hintColor.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // Seçili günün log detay bölümü
  Widget _buildSelectedDayDetail(
    List<DailyLog> logs,
    double pricePerCigarette,
    ThemeData theme,
  ) {
    final dateStr = DateFormat('dd MMMM yyyy, EEEE', 'tr_TR')
        .format(_selectedDay!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarih başlığı
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              dateStr,
              style: AppTextStyles.bodySemibold.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.p12),

        if (logs.isEmpty)
          LunoCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.p8),
              child: Center(
                child: Text(
                  'Bu gün için kayıt yok.',
                  style: AppTextStyles.body.copyWith(color: theme.hintColor),
                ),
              ),
            ),
          )
        else
          ...logs.map(
            (log) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.p12),
              child: DailyLogCard(
                log: log,
                pricePerCigarette: pricePerCigarette,
              ),
            ),
          ),
      ],
    );
  }

  // --- Analitik Grafiği ---
  Widget _buildCombinedChartCard(
      List<dynamic> logs, ThemeData theme, bool isDark) {
    final chartData = _calculateChartData(logs);

    final now = DateTime.now();
    int totalSum = chartData.values.fold(0, (sum, val) => sum + val);

    int elapsedDays = 1;
    if (_selectedFilter == 'H') {
      elapsedDays = now.weekday;
    } else if (_selectedFilter == 'A') {
      elapsedDays = now.day;
    } else if (_selectedFilter == 'Y') {
      elapsedDays = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    }

    final double average = elapsedDays > 0 ? totalSum / elapsedDays : 0;

    return LunoCard(
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'İstatistikler',
                style: AppTextStyles.cardHeader.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              _buildFilterButtons(isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                average
                    .toStringAsFixed(1)
                    .replaceAll(RegExp(r'\.0$'), ''),
                style: AppTextStyles.largeNumber.copyWith(
                  fontSize: 48,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'sigara/gün',
                style: AppTextStyles.body.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _selectedFilter == 'H'
                ? 'Bu hafta boyunca ortalama'
                : _selectedFilter == 'A'
                    ? 'Bu ay boyunca ortalama'
                    : 'Bu yıl boyunca ortalama',
            style: AppTextStyles.label.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
          HistoryBarChart(
            data: chartData,
            filter: _selectedFilter,
          ),
        ],
      ),
    );
  }

  // --- Veri Hesaplama ---

  Map<int, int> _calculateChartData(List<dynamic> logs) {
    final now = DateTime.now();
    Map<int, int> data = {};

    if (_selectedFilter == 'H') {
      for (int i = 1; i <= 7; i++) {
        data[i] = 0;
      }
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfDay =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      for (var log in logs) {
        if (_getLogType(log) == 'slip' && !log.date.isBefore(startOfDay)) {
          int weekday = log.date.weekday;
          data[weekday] = (data[weekday] ?? 0) + (log.smokeCount as int);
        }
      }
    } else if (_selectedFilter == 'A') {
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      for (int i = 1; i <= daysInMonth; i++) {
        data[i] = 0;
      }
      final startOfMonth = DateTime(now.year, now.month, 1);
      for (var log in logs) {
        if (_getLogType(log) == 'slip' &&
            !log.date.isBefore(startOfMonth)) {
          int day = log.date.day;
          data[day] = (data[day] ?? 0) + (log.smokeCount as int);
        }
      }
    } else {
      for (int i = 1; i <= 12; i++) {
        data[i] = 0;
      }
      final startOfYear = DateTime(now.year, 1, 1);
      for (var log in logs) {
        if (_getLogType(log) == 'slip' &&
            !log.date.isBefore(startOfYear)) {
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

  // H/A/Y filtre butonları
  Widget _buildFilterButtons(bool isDark) {
    return Row(
      children: ['H', 'A', 'Y'].map((filter) {
        bool isSelected = _selectedFilter == filter;
        return GestureDetector(
          onTap: () => setState(() => _selectedFilter = filter),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? AppColors.darkChartPrimary
                      : AppColors.lightChartPrimary)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(
                      color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Text(
              filter,
              style: AppTextStyles.label.copyWith(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// --- Haftalık Takvim Gün Hücresi ---
// Tema.md: card radius 16px, primary renk, border, shadow-sm uyumlu
class _CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final bool hasLog;
  final bool isToday;
  final bool isSelected;
  final bool isFuture;
  final Color primary;

  const _CalendarDayCell({
    required this.day,
    required this.hasLog,
    required this.isToday,
    required this.isSelected,
    required this.isFuture,
    required this.primary,
  });

  // Türkçe gün kısaltmaları sabit listesi
  static const List<String> _weekdayLabels = [
    '', // index 0 kullanılmıyor
    'Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pa',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bgColor;
    Color textColor;
    Color borderColor;

    if (isSelected) {
      bgColor = primary;
      textColor = Colors.white;
      borderColor = primary;
    } else if (isToday) {
      bgColor = primary.withValues(alpha: 0.12);
      textColor = primary;
      borderColor = primary.withValues(alpha: 0.4);
    } else if (hasLog) {
      bgColor = primary.withValues(alpha: 0.07);
      textColor = theme.colorScheme.onSurface;
      borderColor = primary.withValues(alpha: 0.2);
    } else {
      bgColor = Colors.transparent;
      textColor = isFuture
          ? theme.hintColor.withValues(alpha: 0.35)
          : theme.hintColor.withValues(alpha: 0.6);
      borderColor = Colors.transparent;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gün etiketi — Pt, Sa, Ça ...
            Text(
              _weekdayLabels[day.weekday],
              style: AppTextStyles.micro.copyWith(
                color: textColor.withValues(alpha: isSelected ? 0.85 : 0.65),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            // Gün sayısı
            Text(
              '${day.day}',
              style: AppTextStyles.bodySemibold.copyWith(
                color: textColor,
                fontSize: 14,
                fontWeight: isToday || isSelected
                    ? FontWeight.w800
                    : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Log var mı nokta göstergesi
            AnimatedOpacity(
              opacity: hasLog ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
