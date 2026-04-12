import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

// --- Widget Durumu ve Yaşam Döngüsü ---
class TodaySummaryCard extends ConsumerStatefulWidget {
  final List<dynamic> logs;

  const TodaySummaryCard({super.key, required this.logs});

  @override
  ConsumerState<TodaySummaryCard> createState() => _TodaySummaryCardState();
}

class _TodaySummaryCardState extends ConsumerState<TodaySummaryCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- Veri Hesaplama ve Hazırlık ---
    final profile = ref.watch(userProfileProvider);
    if (profile == null) return const SizedBox.shrink();

    // Sadece 'Bugün' için logları filtrele
    final todayLogs = widget.logs.where((log) {
      final now = DateTime.now();
      return log.date.year == now.year &&
          log.date.month == now.month &&
          log.date.day == now.day;
    }).toList();

    // Bugün içilen sigara ve krizlere direnme sayılarını topla
    final int todaySmoked = todayLogs
        .where((log) => _getLogType(log) == 'slip')
        .fold(0, (sum, log) => sum + (log.smokeCount as int));

    final int todayCravings = todayLogs
        .where((log) => _getLogType(log) == 'craving')
        .fold(0, (sum, _) => sum + 1);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasSmokedToday = todaySmoked > 0;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final successColor = isDark
        ? AppColors.darkChartSuccess
        : AppColors.lightChartSuccess;

    // Bugün için finansal ve zaman hesaplamaları
    final double pricePerCigarette =
        profile.packPrice / profile.cigarettesPerPack;
    final double todayCost = todaySmoked * pricePerCigarette;
    final int todayTimeLostMinutes = todaySmoked * 11; // Sigara başına 11 dk kayıp

    // --- Dünün Karşılaştırmalı Verileri ---
    final yesterdayDate = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayLogs = widget.logs.where((log) {
      return log.date.year == yesterdayDate.year &&
          log.date.month == yesterdayDate.month &&
          log.date.day == yesterdayDate.day;
    }).toList();

    // Dün kayıt girilmiş mi? (Yanlış kıyaslama yapmamak için kritik)
    final bool hasYesterdayLogs = yesterdayLogs.isNotEmpty;

    final int yesterdaySmoked = yesterdayLogs
        .where((log) => _getLogType(log) == 'slip')
        .fold(0, (sum, log) => sum + (log.smokeCount as int));

    final double yesterdayCost = yesterdaySmoked * pricePerCigarette;
    final int yesterdayTimeLostMinutes = yesterdaySmoked * 11;

    // --- Ana Widget Yapısı ---
    return LunoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Slider Alanı (Sigara Sayısı, Maliyet, Zaman)
          Container(
            height: 240,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.p20,
              AppSpacing.p20,
              AppSpacing.p20,
              0,
            ),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                // Slide 1: Günlük Özet (Sigara Sayısı)
                _buildSlide(
                  context,
                  title: "Bugünün Özeti",
                  value: todaySmoked.toString(),
                  unit: "sigara",
                  badge: hasSmokedToday
                      ? _buildBadge("Kayıp", primary, isDark)
                      : _buildBadge(
                          "Temiz",
                          successColor,
                          isDark,
                          icon: Icons.star,
                        ),
                  extra: todayCravings > 0
                      ? _buildMiniBadge(
                          "$todayCravings krize direndin",
                          successColor,
                        )
                      : null,
                  hasSmoked: hasSmokedToday,
                  primaryColor: primary,
                  comparisonData: hasYesterdayLogs
                      ? _getComparisonData(
                          current: todaySmoked.toDouble(),
                          previous: yesterdaySmoked.toDouble(),
                          unit: "sigara",
                          isImprovementBetter: false,
                        )
                      : null,
                ),
                // Slide 2: Günlük Maliyet (Finansal)
                _buildSlide(
                  context,
                  title: "Bugünkü Maliyet",
                  value: todayCost.toStringAsFixed(1),
                  unit: "₺",
                  badge: _buildBadge(
                    "Finansal",
                    AppColors.lightChartPrimary,
                    isDark,
                  ),
                  extra: _buildMiniBadge(
                    "Yanan para miktarı",
                    AppColors.lightChartPrimary,
                  ),
                  hasSmoked: hasSmokedToday,
                  primaryColor: AppColors.lightChartPrimary,
                  comparisonData: hasYesterdayLogs
                      ? _getComparisonData(
                          current: todayCost,
                          previous: yesterdayCost,
                          unit: "TL",
                          isImprovementBetter: false,
                          isCurrency: true,
                        )
                      : null,
                ),
                // Slide 3: Zaman Kaybı
                _buildSlide(
                  context,
                  title: "Kaybedilen Zaman",
                  value: todayTimeLostMinutes.toString(),
                  unit: "dakika",
                  badge: _buildBadge("Zaman", Colors.blueGrey, isDark),
                  extra: _buildMiniBadge(
                    "Hayatından çalınan süre",
                    Colors.blueGrey,
                  ),
                  hasSmoked: hasSmokedToday,
                  primaryColor: Colors.blueGrey,
                  comparisonData: hasYesterdayLogs
                      ? _getComparisonData(
                          current: todayTimeLostMinutes.toDouble(),
                          previous: yesterdayTimeLostMinutes.toDouble(),
                          unit: "dakika",
                          isImprovementBetter: false,
                        )
                      : null,
                ),
              ],
            ),
          ),

          // Sayfa Göstergeleri (Noktalar)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentPage == index ? 16 : 6,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? primary
                      : primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),

          // Alt Aksiyon Alanı ve Motivasyon Mesajı
          Padding(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: LunoButton(
                    text: "Sigara İçtim", // Hızlı sigara ekleme
                    icon: Icons.smoking_rooms_outlined,
                    onPressed: () => _showQuickAddSheet(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.p16),
                // Dinamik motivasyon mesajı
                Text(
                  hasSmokedToday
                      ? "Zararın neresinden dönersen kârdır. Kaydettiğin sürece ilerliyorsun."
                      : "Tertemiz! Bugün duman yok, hedefe bir adım daha yakınsın.",
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.8),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Slide Oluşturucu ---
  // Her bir istatistik görünümünü (Başlık, Değer, Birim ve Karşılaştırma Rozeti) oluşturur
  Widget _buildSlide(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required Widget badge,
    Widget? extra,
    required bool hasSmoked,
    required Color primaryColor,
    Map<String, dynamic>? comparisonData,
  }) {
    final String? comparisonText = comparisonData?['text'];
    final double? percent = (comparisonData?['percent'] as num?)?.toDouble();
    final Color? comparisonColor = comparisonData?['color'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.cardHeader),
            badge,
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.largeNumber.copyWith(
                        fontSize: 56,
                        color: hasSmoked
                            ? primaryColor
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (percent != null && percent > 0)
                      Positioned(
                        top: -10,
                        right: -36,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: comparisonColor?.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "%${percent.toStringAsFixed(0)}",
                            style: AppTextStyles.micro.copyWith(
                              color: comparisonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // Rozetle çakışmayı önlemek için ayarlanmış dinamik boşluk
                SizedBox(width: (percent != null && percent > 0) ? 36 : 8),
                Text(
                  unit,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // Açıklayıcı karşılaştırma metni (Örn: "düne göre 5 TL kardasın")
            if (comparisonText != null) ...[
              const SizedBox(height: 4),
              Text(
                comparisonText,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        if (extra != null) ...[const SizedBox(height: AppSpacing.p12), extra],
        const Spacer(),
      ],
    );
  }

  // --- Yardımcı Metodlar ve UI Bileşenleri ---
  
  // Dün ve bugün arasındaki farkı ve yüzdeyi hesaplar
  Map<String, dynamic>? _getComparisonData({
    required double current,
    required double previous,
    required String unit,
    bool isImprovementBetter = true,
    bool isCurrency = false,
  }) {
    if (previous == 0 && current == 0) return null;

    final diff = current - previous;
    final isImprovement = isImprovementBetter ? diff > 0 : diff < 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (diff == 0) {
      return {'text': 'Dünle aynı', 'percent': 0.0, 'color': Colors.grey};
    }

    final absDiff = diff.abs();
    final percent = previous > 0 ? (absDiff / previous * 100) : 0.0;
    final Color color = isImprovement
        ? (isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess)
        : (isDark ? AppColors.darkDestructive : AppColors.lightDestructive);

    String text = "";
    if (isCurrency) {
      text = isImprovement
          ? "düne göre ${absDiff.toStringAsFixed(0)} TL kardasın"
          : "düne göre ${absDiff.toStringAsFixed(0)} TL fazla harcadın";
    } else if (unit == "dakika") {
      text = isImprovement
          ? "düne göre $absDiff dakika kazandın"
          : "düne göre $absDiff dakika kaybettin";
    } else {
      final diffText = absDiff.toInt().toString();
      text = isImprovement
          ? "düne göre $diffText $unit az içtin"
          : "düne göre $diffText $unit fazla içtin";
    }

    return {'text': text, 'percent': percent, 'color': color};
  }

  // Krizler veya diğer ikincil bilgiler için mini bilgi etiketi
  Widget _buildMiniBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Ana durum rozeti (Kart içi slaytların sağ üstü)
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

  // Log tipi için güvenli erişim (eski kayıtlar için)
  String _getLogType(dynamic log) {
    try {
      return log.type ?? 'craving';
    } catch (_) {
      return 'craving';
    }
  }

  // Hızlı sigara ekleme için alt menü (Bottom Sheet)
  void _showQuickAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark
            ? Theme.of(context).colorScheme.surface
            : AppColors.lightBackground;

        return SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.p24),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.p24),
                Text(
                  "Bi' sigara yandı...",
                  style: AppTextStyles.cardHeader.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppSpacing.p8),
                Text(
                  "Neden içtiğine dair not düşmek ister misin? Yoksa sadece sayıyı mı ekleyelim?",
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.p32),

                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    icon: const Icon(Icons.flash_on_rounded),
                    label: const Text("Boş ver, sadece 1 sigara ekle"),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: isDark
                          ? Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest
                          : Colors.grey.shade200,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final log = DailyLog(
                        id: const Uuid().v4(),
                        date: DateTime.now(),
                        cravingIntensity: 0,
                        hasSmoked: true,
                        smokeCount: 1,
                        type: 'slip',
                        moods: const [],
                        context: const [],
                        companions: const [],
                      );

                      ref.read(historyLogsProvider.notifier).addLog(log);
                      ref.read(analyticsServiceProvider).logSmokeLogged(count: 1);
                      Navigator.pop(sheetContext);
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.p12),

                SizedBox(
                  width: double.infinity,
                  child: LunoButton(
                    text: "Neden içtiğini paylaş",
                    icon: Icons.edit_note_rounded,
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      context.push(AppRouter.slipLog);
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.p24),
              ],
            ),
          ),
        );
      },
    );
  }
}
