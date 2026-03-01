import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/widgets/stat_card.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';

class StatGrid extends StatelessWidget {
  final String spentMoney;
  final String lostTime;
  final String smokedCount;
  final String healthRisk;

  const StatGrid({
    super.key,
    required this.spentMoney,
    required this.lostTime,
    required this.smokedCount,
    required this.healthRisk,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    // GridView'un Sütun içinde düzgün çalışması için ShrinkWrap: true
    // ve physics: NeverScrollableScrollPhysics kullanıyoruz.

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.p12,
      crossAxisSpacing: AppSpacing.p12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StatCard(
          label: "Harcanan",
          value: spentMoney,
          icon: Icons.money,
          iconColor: colorScheme.primary,
        ),
        StatCard(
          label: "Kayıp Zaman",
          value: lostTime,
          icon: Icons.timer_outlined,
          subtext: "59 tane netflixten dizi bitirebilirdin",
        ),
        StatCard(
          label: "İçilen Sigara",
          value: smokedCount,
          icon: Icons.smoking_rooms_outlined,
          iconColor: AppColors.lightChartWarning,
          subtext: "Üst üste koysan 7 kat bina eder",
        ),
        StatCard(
          label: "Zarar Seviyesi",
          value: healthRisk,
          icon: Icons.monitor_heart_sharp,
          iconColor: AppColors.lightChartPrimary,
          subtext: "vücudundaki tahribat",
        ),
      ],
    );
  }
}
