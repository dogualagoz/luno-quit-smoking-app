import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/settings_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_slider.dart';
import '../widgets/settings_toggle_tile.dart';
import '../widgets/settings_menu_tile.dart';
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
    // Profil kartı için orijinal veriyi kullanıyoruz (yukarıda login olunca güncellenmesi için)
    final originalProfile = ref.watch(userProfileProvider);
    
    // Sliders için geçici durumu takip eden controller
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

    // Slider değerleri (Controller'dan geliyor)
    final int weeklyGoal = userProfile?.weeklySmokingGoal ?? 0;
    final double price = userProfile?.packPrice ?? 0.0;

    // Bu haftaki toplam sigara sayısı (progress için)
    final logs = ref.watch(historyLogsProvider).value ?? [];
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final int weeklyActual = logs
        .where((log) =>
            log.hasSmoked &&
            !log.date.isBefore(startOfWeek))
        .fold(0, (sum, log) => sum + log.smokeCount);
    
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          // Sayfadan çıkarken (Geri tuşu veya Swipe) otomatik kaydet
          await ref.read(settingsControllerProvider.notifier).saveSettings();
          // Dashboard'un güncellenmesi için orijinal provider'ı da tetikle
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
  
                  // 1. Başlık
                  const SettingsHeader(),
  
                  const SizedBox(height: AppSpacing.p24),
  
                  // 2. Profil Kartı
                  ProfileCard(
                    userName: userName,
                    registerDate: registerDate,
                  ),
  
                  const SizedBox(height: AppSpacing.p24),
  
                  // 3. Sigara Bilgilerin
                  if (userProfile != null)
                    LunoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sigara Bilgilerin',
                            style: AppTextStyles.cardHeader,
                          ),
                          const SizedBox(height: AppSpacing.p24),

                          // --- Haftalık Azaltma Hedefi ---
                          _WeeklyGoalSection(
                            weeklyGoal: weeklyGoal,
                            weeklyActual: weeklyActual,
                            onChanged: (val) {
                              // Max 140 adet (günde 20 x 7)
                              const int maxWeeklySmoking = 140;
                              final newVal =
                                  (val * maxWeeklySmoking).round();
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
  
                  if (userProfile != null) const SizedBox(height: AppSpacing.p24),

                // 4. Görünüm & Bildirimler
                LunoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Araçlar & Görünüm',
                        style: AppTextStyles.cardHeader,
                      ),
                      const SizedBox(height: AppSpacing.p16),
                      SettingsToggleTile(
                        title: "Koyu Tema",
                        icon: Icons.dark_mode_outlined,
                        value: isDarkMode,
                        onChanged: (val) {
                          ref.read(themeModeProvider.notifier).toggleTheme();
                        },
                      ),
                      const Divider(height: 1),
                      SettingsToggleTile(
                        title: "Hatırlatıcılar",
                        icon: Icons.notifications_none_rounded,
                        value: true,
                        onChanged: (val) {
                          // TODO: Push Notifications On/Off
                        },
                      ),
                      const Divider(height: 1),
                      SettingsMenuTile(
                        title: "Ciğerito Özelleştirme (Yakında)",
                        icon: Icons.face_retouching_natural_rounded,
                        onTap: () {
                          // Bu özellik V1.1 sürümünde gelecek
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Bu özellik çok yakında sizlerle!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.p24),
                
                // 5. Ekstra Araçlar
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
                        title: "Öneri Yap & Bildir",
                        icon: Icons.lightbulb_outline_rounded,
                        onTap: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'alagozdogu@gmail.com',
                            query: 'subject=Luno Uygulaması Hakkında Öneri',
                          );
                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          }
                        },
                      ),
                      const Divider(height: 1),
                      // TEST: Hata Ekranı Önizleme
                      SettingsMenuTile(
                        title: "Hata Ekranı Testi (Geliştirici)",
                        icon: Icons.bug_report_outlined,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ErrorPreviewPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.p24),

                // 4.5 Hakkında
                LunoCard(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      );
                    },
                    leading: Icon(
                      Icons.info_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Hakkında',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Kaynaklar, sorumluluk reddi ve uygulama bilgileri',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).hintColor.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),

                LunoCard(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Çıkış yap?'),
                              content: const Text(
                                'Oturumu kapatmak istediğine emin misin?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Vazgeç'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Çıkış Yap',
                                    style: TextStyle(
                                      color: AppColors.lightDestructive,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signOut();
                          }
                        },
                        leading: Icon(
                          Icons.logout_rounded,
                          color: AppColors.lightDestructive.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        title: Text(
                          'Çıkış Yap',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.lightDestructive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        contentPadding: EdgeInsets.zero,
                      ),
                      ListTile(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hesabı Kalıcı Olarak Sil?'),
                              content: const Text(
                                'Tüm verilerin ve hesabın kalıcı olarak silinecektir. Bu işlem geri alınamaz. Onaylıyor musun?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Vazgeç'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Hesabı Sil',
                                    style: TextStyle(
                                      color: AppColors.lightDestructive,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ref
                                .read(authControllerProvider.notifier)
                                .deleteAccount();
                                
                            // Eğer hata olursa kullanıcıyı bilgilendir
                            final authState = ref.read(authControllerProvider);
                            if (authState.hasError) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Güvenlik için lütfen çıkış yapıp tekrar giriş yaptıktan sonra hesabı silmeyi deneyin.'),
                                    backgroundColor: AppColors.lightDestructive,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        leading: Icon(
                          Icons.delete_forever_rounded,
                          color: AppColors.lightDestructive.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        title: Text(
                          'Hesabı Sil',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.lightDestructive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

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

/// Ayarlar sayfasındaki haftalık sigara azaltma hedefi bölümü.
/// Slider ile hedef adet girilir, progress bar ile bu haftaki gerçekle karşılaştırılır.
class _WeeklyGoalSection extends StatelessWidget {
  // Sabitler
  static const int _maxWeeklySmoking = 140; // Günde 20 × 7 gün
  static const int _goalNotSet = 0;

  final int weeklyGoal;
  final int weeklyActual;
  final ValueChanged<double> onChanged;

  const _WeeklyGoalSection({
    required this.weeklyGoal,
    required this.weeklyActual,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final bool goalSet = weeklyGoal > _goalNotSet;

    // İlerleme oranı
    final double progress = goalSet
        ? (weeklyActual / weeklyGoal).clamp(0.0, 1.0)
        : 0.0;

    // Renk: %100 altı = yeşil, %80-100 arası = sarı, %100 üstü = kırmızı
    Color progressColor;
    if (!goalSet || weeklyActual == 0) {
      progressColor = AppColors.lightChartSuccess;
    } else if (progress < 0.8) {
      progressColor = AppColors.lightChartSuccess;
    } else if (progress < 1.0) {
      progressColor = AppColors.lightChartWarning;
    } else {
      progressColor = AppColors.lightDestructive;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık + ikon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.flag_outlined,
                size: 18,
                color: primary,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haftalık Azaltma Hedefi',
                  style: AppTextStyles.label.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                Text(
                  goalSet ? '$weeklyGoal adet/hafta' : 'Hedef belirlenmedi',
                  style: AppTextStyles.bodySemibold.copyWith(
                    color: goalSet
                        ? theme.colorScheme.onSurface
                        : theme.hintColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Slider
        const SizedBox(height: AppSpacing.p12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: primary,
            inactiveTrackColor: primary.withValues(alpha: 0.15),
            thumbColor: primary,
            overlayColor: primary.withValues(alpha: 0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: (weeklyGoal / _maxWeeklySmoking).clamp(0.0, 1.0),
            onChanged: onChanged,
          ),
        ),

        // Hız çizelgesi etiketleri
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: AppTextStyles.micro.copyWith(color: theme.hintColor),
              ),
              Text(
                '${_maxWeeklySmoking ~/ 2}',
                style: AppTextStyles.micro.copyWith(color: theme.hintColor),
              ),
              Text(
                '$_maxWeeklySmoking',
                style: AppTextStyles.micro.copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),

        // Progress bar — Bu haftaki gerçek vs hedef
        if (goalSet) ...[
          const SizedBox(height: AppSpacing.p16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bu hafta: $weeklyActual içildi',
                style: AppTextStyles.caption.copyWith(
                  color: theme.hintColor,
                ),
              ),
              Text(
                weeklyActual >= weeklyGoal ? 'Hedef aşıldı 🚨' : 'Hedef: $weeklyGoal',
                style: AppTextStyles.caption.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tema.md: progress bar radius 9999
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: progressColor.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ],
    );
  }
}
