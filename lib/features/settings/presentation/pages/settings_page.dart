import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import '../widgets/settings_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_slider.dart';
import '../widgets/settings_toggle_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: AppSpacing.pageHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.p24),

                // 1. Başlık
                const SettingsHeader(),

                const SizedBox(height: AppSpacing.p24),

                // 2. Profil Kartı
                const ProfileCard(
                  userName: "Duman",
                  registerDate: "2024-06-23",
                ),

                const SizedBox(height: AppSpacing.p24),

                // 3. Sigara Bilgilerin
                LunoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sigara Bilgilerin',
                        style: AppTextStyles.cardHeader,
                      ),
                      const SizedBox(height: AppSpacing.p24),
                      const SettingsSlider(
                        label: "Günlük ortalama",
                        value: "14",
                        unit: " adet",
                        progress: 0.4,
                        activeColor: AppColors.lightPrimary,
                        icon: Icons.smoke_free_rounded,
                        subtext: "Orta seviye. Ama hedef sıfır, unutma.",
                      ),
                      const SizedBox(height: AppSpacing.p24),
                      const SettingsSlider(
                        label: "Paket fiyatı",
                        value: "₺75",
                        unit: "",
                        progress: 0.6,
                        activeColor: AppColors.lightChartWarning,
                        icon: Icons.currency_lira_rounded,
                      ),
                      const SizedBox(height: AppSpacing.p24),
                      const SettingsSlider(
                        label: "Günlük hedef",
                        value: "max 10",
                        valueColor: AppColors.lightChartSuccess,
                        unit: " adet",
                        progress: 0.5,
                        activeColor: AppColors.lightChartSuccess,
                        icon: Icons.track_changes_rounded,
                        subtext:
                            "Hedef koymuşsun, güzel. Ama daha az olsa da olur.",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.p24),

                // 4. Görünüm & Bildirimler
                LunoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Görünüm & Bildirimler',
                        style: AppTextStyles.cardHeader,
                      ),
                      const SizedBox(height: AppSpacing.p16),
                      SettingsToggleTile(
                        title: "Açık Tema",
                        icon: Icons.light_mode_outlined,
                        value: true,
                        onChanged: (val) {},
                      ),
                      const Divider(height: 1),
                      SettingsToggleTile(
                        title: "Hatırlatıcılar",
                        icon: Icons.notifications_none_rounded,
                        value: true,
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.p24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
