import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/burn_progress_bar.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/quick_log_sheet.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/summary_slide.dart';

class TodaySummaryCard extends ConsumerStatefulWidget {
  final List<dynamic> logs;

  const TodaySummaryCard({super.key, required this.logs});

  @override
  ConsumerState<TodaySummaryCard> createState() => _TodaySummaryCardState();
}

class _TodaySummaryCardState extends ConsumerState<TodaySummaryCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _checkTimer(bool isBurning) {
    if (isBurning && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (mounted) setState(() {});
      });
    } else if (!isBurning && _timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  String _logType(dynamic log) {
    try {
      return log.type ?? 'craving';
    } catch (_) {
      return 'craving';
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    if (profile == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final todayLogs = widget.logs.where((log) {
      return log.date.year == now.year &&
          log.date.month == now.month &&
          log.date.day == now.day;
    }).toList();

    final int todaySmoked = todayLogs
        .where((log) => _logType(log) == 'slip')
        .fold(0, (sum, log) => sum + (log.smokeCount as int));
    final int todayCravings = todayLogs
        .where((log) => _logType(log) == 'craving')
        .fold(0, (sum, _) => sum + 1);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasSmokedToday = todaySmoked > 0;
    final primary = context.primary;
    final successColor = context.chartSuccess;
    final double pricePerCigarette =
        profile.packPrice / profile.cigarettesPerPack;

    // Gradual burn calculation — 1 cigarette = 11 minutes
    double todayCost = 0.0;
    int todayTimeLostMinutes = 0;
    bool isBurning = false;
    double activeBurnRatio = 0.0;
    double minRatio = 1.0;

    for (var log in todayLogs) {
      if (_logType(log) == 'slip') {
        final int count = log.smokeCount as int;
        final int totalSec = count * 11 * 60;
        final int passedSec =
            DateTime.now().difference(log.date as DateTime).inSeconds;
        double ratio = 1.0;
        if (totalSec > 0 && passedSec >= 0) {
          ratio = (passedSec / totalSec).clamp(0.0, 1.0);
        } else if (passedSec < 0) {
          ratio = 0.0;
        }
        if (ratio < 1.0) {
          isBurning = true;
          if (ratio < minRatio) minRatio = ratio;
        }
        todayCost += count * ratio * pricePerCigarette;
        todayTimeLostMinutes += (count * 11 * ratio).round();
      }
    }
    if (isBurning) activeBurnRatio = minRatio;
    _checkTimer(isBurning);

    final yesterdayDate = now.subtract(const Duration(days: 1));
    final yesterdayLogs = widget.logs.where((log) {
      return log.date.year == yesterdayDate.year &&
          log.date.month == yesterdayDate.month &&
          log.date.day == yesterdayDate.day;
    }).toList();
    final bool hasYesterdayLogs = yesterdayLogs.isNotEmpty;
    final int yesterdaySmoked = yesterdayLogs
        .where((log) => _logType(log) == 'slip')
        .fold(0, (sum, log) => sum + (log.smokeCount as int));
    final double yesterdayCost = yesterdaySmoked * pricePerCigarette;
    final int yesterdayTimeLostMinutes = yesterdaySmoked * 11;

    return LunoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 240,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.p20, AppSpacing.p20, AppSpacing.p20, 0),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) =>
                  setState(() => _currentPage = index),
              children: [
                SummarySlide(
                  title: "Bugünün Özeti",
                  value: todaySmoked.toString(),
                  unit: "sigara",
                  hasSmoked: hasSmokedToday,
                  primaryColor: primary,
                  badge: buildSlideBadge(
                    hasSmokedToday ? "Kayıp" : "Temiz",
                    hasSmokedToday ? primary : successColor,
                    isDark,
                    icon: hasSmokedToday ? null : Icons.star,
                  ),
                  extra: todayCravings > 0
                      ? buildSlideMiniBadge(
                          "$todayCravings krize direndin", successColor)
                      : null,
                  comparisonData: hasYesterdayLogs
                      ? getSlideComparisonData(
                          context,
                          current: todaySmoked.toDouble(),
                          previous: yesterdaySmoked.toDouble(),
                          unit: "sigara",
                          isImprovementBetter: false,
                        )
                      : null,
                ),
                SummarySlide(
                  title: "Bugünkü Maliyet",
                  value: todayCost.toStringAsFixed(1),
                  unit: "₺",
                  hasSmoked: hasSmokedToday,
                  primaryColor: AppColors.lightChartPrimary,
                  badge: buildSlideBadge(
                      "Finansal", AppColors.lightChartPrimary, isDark),
                  extra: buildSlideMiniBadge(
                      "Yanan para miktarı", AppColors.lightChartPrimary),
                  comparisonData: hasYesterdayLogs
                      ? getSlideComparisonData(
                          context,
                          current: todayCost,
                          previous: yesterdayCost,
                          unit: "TL",
                          isImprovementBetter: false,
                          isCurrency: true,
                        )
                      : null,
                ),
                SummarySlide(
                  title: "Kaybedilen Zaman",
                  value: todayTimeLostMinutes.toString(),
                  unit: "dakika",
                  hasSmoked: hasSmokedToday,
                  primaryColor: Colors.blueGrey,
                  badge: buildSlideBadge("Zaman", Colors.blueGrey, isDark),
                  extra: buildSlideMiniBadge(
                      "Hayatından çalınan süre", Colors.blueGrey),
                  comparisonData: hasYesterdayLogs
                      ? getSlideComparisonData(
                          context,
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

          // Page dots
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

          const SizedBox(height: AppSpacing.p16),
          BurnProgressBar(
            isBurning: isBurning,
            activeBurnRatio: activeBurnRatio,
            primary: primary,
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: LunoButton(
                    text: "Sigara İçtim",
                    icon: Icons.smoking_rooms_outlined,
                    onPressed: () => showQuickLogSheet(context, ref),
                  ),
                ),
                const SizedBox(height: AppSpacing.p16),
                Text(
                  hasSmokedToday
                      ? "Zararın neresinden dönersen kârdır. Kaydettiğin sürece ilerliyorsun."
                      : "Tertemiz! Bugün duman yok, hedefe bir adım daha yakınsın.",
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.8),
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
}
