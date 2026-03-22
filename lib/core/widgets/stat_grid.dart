import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/stat_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/recovery_stat_card.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';

/// Dashboard'taki 4 istatistik kartını 2x2 grid olarak düzenler.
///
/// Kart sıralaması:
/// [Harcanan Para]   [İçilen Sigara]
/// [Kaybedilen Zaman] [İyileşme Süresi]
class StatGrid extends StatelessWidget {
  final QuitStats stats;

  const StatGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.p12,
      crossAxisSpacing: AppSpacing.p12,
      childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // 1. Harcanan Para
        InkWell(
          onTap: () => context.push(AppRouter.moneyDetails),
          borderRadius: BorderRadius.circular(16),
          child: StatCard(
            label: stats.moneyLabel,
            value: stats.moneyValue,
            moneyDecimal: stats.moneyDecimal,
            subtext: stats.moneySubtext,
            icon: Icons.savings_outlined,
            iconColor: AppColors.lightChartPrimary,
            isMoney: true,
            showBurnIndicator: true,
          ),
        ),
        // 2. İçilen Sigara
        InkWell(
          onTap: () => context.push(AppRouter.cigarettesDetails),
          borderRadius: BorderRadius.circular(16),
          child: StatCard(
            label: stats.countLabel,
            value: stats.countValue,
            subtext: stats.countSubtext,
            icon: Icons.smoking_rooms_outlined,
            iconColor: AppColors.lightChartWarning,
          ),
        ),
        // 3. Kaybedilen Zaman
        InkWell(
          onTap: () => context.push(AppRouter.timeDetails),
          borderRadius: BorderRadius.circular(16),
          child: StatCard(
            label: stats.timeLabel,
            value: stats.timeValue,
            digits: stats.timeDigits,
            subtext: stats.timeSubtext,
            icon: Icons.timer_outlined,
            iconColor: Colors.blueGrey,
          ),
        ),
        // 4. İyileşme Süresi
        InkWell(
          onTap: () => context.push(AppRouter.recoveryDetails),
          borderRadius: BorderRadius.circular(16),
          child: RecoveryStatCard(stats: stats),
        ),
      ],
    );
  }
}
