import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import '../widgets/settings_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_slider.dart';
import '../widgets/settings_toggle_tile.dart';
import '../widgets/settings_menu_tile.dart';
import '../widgets/weekly_goal_section.dart';
import '../widgets/account_actions_card.dart';
import '../controllers/settings_controller.dart';
import 'about_page.dart';
import 'error_preview_page.dart';
import '../../../onboarding/data/onboarding_repository.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originalProfile = ref.watch(userProfileProvider);
    final settingsState = ref.watch(settingsControllerProvider);
    final userProfile = settingsState.profile;

    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final String userName = originalProfile?.nickname ?? "Misafir";
    final String registerDate = originalProfile != null
        ? DateFormat('dd.MM.yyyy').format(originalProfile.createdAt)
        : "-";

    final int weeklyGoal = userProfile?.weeklySmokingGoal ?? 0;
    final double price = userProfile?.packPrice ?? 0.0;

    final logs = ref.watch(historyLogsProvider).value ?? [];
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final int weeklyActual = logs
        .where((log) => log.hasSmoked && !log.date.isBefore(startOfWeek))
        .fold(0, (sum, log) => sum + log.smokeCount);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await ref.read(settingsControllerProvider.notifier).saveSettings();
          ref.invalidate(userProfileProvider);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: AppSpacing.pageHorizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.p24),
                  const SettingsHeader(),
                  const SizedBox(height: AppSpacing.p24),
                  ProfileCard(
                    userName: userName,
                    registerDate: registerDate,
                  ),
                  const SizedBox(height: AppSpacing.p24),

                  if (userProfile != null)
                    LunoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sigara Bilgilerin',
                              style: AppTextStyles.cardHeader),
                          const SizedBox(height: AppSpacing.p24),
                          WeeklyGoalSection(
                            weeklyGoal: weeklyGoal,
                            weeklyActual: weeklyActual,
                            onChanged: (val) {
                              final newVal =
                                  (val * WeeklyGoalSection.maxWeeklySmoking)
                                      .round();
                              ref
                                  .read(settingsControllerProvider.notifier)
                                  .updateWeeklySmokingGoal(newVal);
                            },
                          ),
                          const SizedBox(height: AppSpacing.p24),
                          SettingsSlider(
                            label: "Paket fiyatı",
                            value: "₺${price.toStringAsFixed(0)}",
                            unit: "",
                            progress: (price / 150.0).clamp(0.0, 1.0),
                            activeColor: AppColors.lightChartWarning,
                            icon: Icons.currency_lira_rounded,
                            onChanged: (val) {
                              final newPrice =
                                  (val * 150).round().toDouble();
                              ref
                                  .read(settingsControllerProvider.notifier)
                                  .updatePackPrice(newPrice);
                            },
                          ),
                        ],
                      ),
                    ),

                  if (userProfile != null)
                    const SizedBox(height: AppSpacing.p24),

                  LunoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Araçlar & Görünüm',
                            style: AppTextStyles.cardHeader),
                        const SizedBox(height: AppSpacing.p16),
                        SettingsToggleTile(
                          title: "Koyu Tema",
                          icon: Icons.dark_mode_outlined,
                          value: isDarkMode,
                          onChanged: (_) =>
                              ref.read(themeModeProvider.notifier).toggleTheme(),
                        ),
                        const Divider(height: 1),
                        SettingsToggleTile(
                          title: "Hatırlatıcılar",
                          icon: Icons.notifications_none_rounded,
                          value: true,
                          onChanged: (_) {},
                        ),
                        const Divider(height: 1),
                        SettingsMenuTile(
                          title: "Ciğerito Özelleştirme (Yakında)",
                          icon: Icons.face_retouching_natural_rounded,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Bu özellik çok yakında sizlerle!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.p24),

                  LunoCard(
                    child: Column(
                      children: [
                        SettingsMenuTile(
                          title: "Uygulamayı Paylaş",
                          icon: Icons.share_rounded,
                          onTap: () {
                            // ignore: deprecated_member_use
                            Share.share(
                                "Cigerito ile sigarayı bırakma serüvenime başladım! Sen de bana katıl: https://luno-app.com");
                          },
                        ),
                        const Divider(height: 1),
                        SettingsMenuTile(
                          title: "Öneri Yak & Bildir",
                          icon: Icons.lightbulb_outline_rounded,
                          onTap: () async {
                            final Uri uri = Uri(
                              scheme: 'mailto',
                              path: 'alagozdogu@gmail.com',
                              query:
                                  'subject=Luno Uygulaması Hakkında Öneri',
                            );
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                        ),
                        const Divider(height: 1),
                        SettingsMenuTile(
                          title: "Hata Ekranı Testi (Geliştirici)",
                          icon: Icons.bug_report_outlined,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const ErrorPreviewPage(),
                            ));
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.p24),

                  LunoCard(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const AboutPage(),
                        ));
                      },
                      leading: Icon(
                        Icons.info_outline_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        'Hakkında',
                        style: AppTextStyles.body
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Kaynaklar, sorumluluk reddi ve uygulama bilgileri',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .hintColor
                                  .withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const AccountActionsCard(),

                  const SizedBox(height: AppSpacing.p40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
