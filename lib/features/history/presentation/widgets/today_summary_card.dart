import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:go_router/go_router.dart';

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
    final profile = ref.watch(userProfileProvider);
    if (profile == null) return const SizedBox.shrink();

    final todayLogs = widget.logs.where((log) {
      final now = DateTime.now();
      return log.date.year == now.year &&
          log.date.month == now.month &&
          log.date.day == now.day;
    }).toList();

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

    // Maliyet ve Zaman Hesaplamaları
    final double pricePerCigarette = profile.packPrice / profile.cigarettesPerPack;
    final double todayCost = todaySmoked * pricePerCigarette;
    final int todayTimeLostMinutes = todaySmoked * 11; // 11 dk/sigara

    return LunoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 220, // Slider içeriği için yükseklik
            padding: const EdgeInsets.fromLTRB(AppSpacing.p20, AppSpacing.p20, AppSpacing.p20, 0),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                // 1. Sigara Sayısı & Krizler
                _buildSlide(
                  context,
                  title: "Bugünün Özeti",
                  value: todaySmoked.toString(),
                  unit: "sigara",
                  badge: hasSmokedToday
                      ? _buildBadge("Kayıp", primary, isDark)
                      : _buildBadge("Temiz", successColor, isDark, icon: Icons.star),
                  extra: todayCravings > 0
                      ? _buildMiniBadge("$todayCravings krize direndin", successColor)
                      : null,
                  hasSmoked: hasSmokedToday,
                  primaryColor: primary,
                ),
                // 2. Maliyet
                _buildSlide(
                  context,
                  title: "Bugünkü Maliyet",
                  value: todayCost.toStringAsFixed(1),
                  unit: "₺",
                  badge: _buildBadge("Finansal", AppColors.lightChartPrimary, isDark),
                  extra: _buildMiniBadge("Yanan para miktarı", AppColors.lightChartPrimary),
                  hasSmoked: hasSmokedToday,
                  primaryColor: AppColors.lightChartPrimary,
                ),
                // 3. Zaman Kaybı
                _buildSlide(
                  context,
                  title: "Kaybedilen Zaman",
                  value: todayTimeLostMinutes.toString(),
                  unit: "dakika",
                  badge: _buildBadge("Zaman", Colors.blueGrey, isDark),
                  extra: _buildMiniBadge("Hayatından çalınan süre", Colors.blueGrey),
                  hasSmoked: hasSmokedToday,
                  primaryColor: Colors.blueGrey,
                ),
              ],
            ),
          ),

          // Sayfa Göstergesi (Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentPage == index ? 16 : 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? primary : primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: LunoButton(
                    text: "Kayıt Ekle",
                    icon: Icons.add_circle_outline,
                    onPressed: () => context.push(AppRouter.slipLog),
                  ),
                ),
                const SizedBox(height: AppSpacing.p16),
                Text(
                  hasSmokedToday
                      ? "Zararın neresinden dönersen kârdır. Kaydettiğin sürece ilerliyorsun."
                      : "Tertemiz! Bugün duman yok, hedefe bir adım daha yakınsın.",
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
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

  Widget _buildSlide(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required Widget badge,
    Widget? extra,
    required bool hasSmoked,
    required Color primaryColor,
  }) {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: AppTextStyles.largeNumber.copyWith(
                fontSize: 56,
                color: hasSmoked ? primaryColor : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              unit,
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 16,
              ),
            ),
          ],
        ),
        if (extra != null) ...[
          const SizedBox(height: AppSpacing.p12),
          extra,
        ],
        const Spacer(),
      ],
    );
  }

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
