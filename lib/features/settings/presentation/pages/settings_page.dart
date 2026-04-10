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
import 'cigerito_customization_page.dart';
import 'error_preview_page.dart';
import '../../../onboarding/data/onboarding_repository.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

    // Sliders değerleri (Controller'dan geliyor)
    final int dailyCig = userProfile?.dailyCigarettes ?? 0;
    final double price = userProfile?.packPrice ?? 0.0;
    
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
                          SettingsSlider(
                            label: "Günlük ortalama",
                            value: dailyCig.toString(),
                            unit: " adet",
                            progress: (dailyCig / 40.0).clamp(0.0, 1.0),
                            activeColor: AppColors.lightPrimary,
                            icon: Icons.smoke_free_rounded,
                            subtext: "Hedef sıfır, unutma.",
                            onChanged: (val) {
                              final newVal = (val * 40).round();
                              ref.read(settingsControllerProvider.notifier)
                                 .updateDailyCigarettes(newVal);
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
                               final newPrice = (val * 150).round().toDouble();
                               ref.read(settingsControllerProvider.notifier)
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
