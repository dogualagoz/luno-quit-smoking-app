import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/cigerito_mascot.dart';
import '../../../core/widgets/speech_bubble.dart';
import 'controllers/auth_controller.dart';

class AuthSelectionScreen extends ConsumerWidget {
  final String userName;

  const AuthSelectionScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // Hataları dinleyip kullanıcıya gösteriyoruz
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: AppColors.lightDestructive,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: AppSpacing.pageHorizontal,
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.p40),
                  // Maskot Bölümü
                  const Center(
                    child: CigeritoMascot(mode: MascotMode.proud, size: 140),
                  ),
                  const SizedBox(height: AppSpacing.p16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✨ ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Onboarding tamamlandı!',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.lightMutedForeground,
                        ),
                      ),
                      const Text(' ✨', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.p12),

                  // Konuşma Balonu
                  SpeechBubble(
                    text:
                        "Harika ${userName.toUpperCase()}! Artık seninle bu yolculuğa çıkmaya hazırım. Nasıl devam etmek istersin?",
                  ),
                  const SizedBox(height: AppSpacing.p40),

                  // Giriş Butonları
                  _AuthButton(
                    iconPath: Icons.apple,
                    text: 'Apple ile devam et',
                    backgroundColor: const Color(0xFF2D2A3E),
                    textColor: Colors.white,
                    onPressed: () => context.go('/'),
                  ),
                  const SizedBox(height: AppSpacing.p16),
                  _AuthButton(
                    iconPath: Icons.g_mobiledata, // Yerici Google ikonu
                    text: 'Google ile devam et',
                    backgroundColor: Colors.white,
                    textColor: AppColors.lightForeground,
                    border: Border.all(color: AppColors.lightBorder),
                    onPressed: () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle(),
                  ),

                  const SizedBox(height: AppSpacing.p24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.lightBorder)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'veya',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.lightMutedForeground,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.lightBorder)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.p24),

                  _AuthButton(
                    iconPath: Icons.mail_outline,
                    text: 'E-posta ile giriş yap',
                    backgroundColor: Colors.white,
                    textColor: AppColors.lightForeground,
                    border: Border.all(color: AppColors.lightBorder),
                    onPressed: () => context.push('/email-login'),
                  ),
                  const SizedBox(height: AppSpacing.p16),

                  // Anonim buton (Dotted efektini simüle ediyoruz)
                  _AuthButton(
                    iconPath: Icons.face_retouching_natural_outlined,
                    text: 'Anonim olarak devam et',
                    backgroundColor: AppColors.lightMuted.withValues(
                      alpha: 0.3,
                    ),
                    textColor: AppColors.lightMutedForeground,
                    isDotted: true,
                    onPressed: () => context.go('/'),
                  ),

                  const SizedBox(height: AppSpacing.p24),

                  // Bilgi Kutusu
                  Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      color: AppColors.lightDestructive.withValues(alpha: 0.05),
                      borderRadius: AppRadius.mainCard,
                    ),
                    child: Text(
                      "Anonim girişte verilerin yalnızca bu cihazda saklanır. Hesap oluşturursan cihazlar arası senkron yapabilirsin.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.lightForeground.withValues(alpha: 0.6),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.p32),

                  // Alt Linkler
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'Devam ederek ',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.lightMutedForeground,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Kullanım Koşulları',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.lightMutedForeground,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        ' ve ',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.lightMutedForeground,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Gizlilik Politikası',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.lightMutedForeground,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        '\'nı kabul edersin.',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.lightMutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.p40),
                ],
              ),
            ),
            // Loading Overlay: İşlem sürerken ekranın üstüne biner
            if (authState.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final IconData iconPath;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final BoxBorder? border;
  final bool isDotted;

  const _AuthButton({
    required this.iconPath,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.border,
    this.isDotted = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppRadius.button,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.button,
          border: border,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isDotted)
              // Basit bir kesikli çizgi efekti (Container border'ı ile tam yapılamaz ama görsel benzer)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.button,
                    border: Border.all(
                      color: AppColors.lightBorder,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconPath, color: textColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: AppTextStyles.label.copyWith(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
