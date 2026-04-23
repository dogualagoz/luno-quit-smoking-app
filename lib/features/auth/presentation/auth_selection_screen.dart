import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/speech_bubble.dart';
import 'controllers/auth_controller.dart';
import '../../../core/utils/error_translator.dart';
import '../../../core/router/app_router.dart';

class AuthSelectionScreen extends ConsumerWidget {
  final String userName;

  const AuthSelectionScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Hataları dinleyip kullanıcıya gösteriyoruz
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorTranslator.translate(next.error)),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Giriş Butonları ve İçerik
            SingleChildScrollView(
              padding: AppSpacing.pageHorizontal,
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.p40),
                  // Maskot Bölümü
                  Center(
                    child: SvgPicture.asset(
                      AssetConstants.cigeritoDefault,
                      height: 140,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.p16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✨ ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Onboarding tamamlandı!',
                        style: AppTextStyles.caption.copyWith(
                          color: theme.hintColor,
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
                    iconData: Icons.apple,
                    text: 'Apple ile devam et',
                    backgroundColor: const Color(0xFF2D2A3E),
                    textColor: Colors.white,
                    onPressed: () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithApple(),
                  ),
                  const SizedBox(height: AppSpacing.p16),
                  _AuthButton(
                    iconData: Icons.g_mobiledata,
                    text: 'Google ile devam et',
                    backgroundColor: colorScheme.surface,
                    textColor: colorScheme.onSurface,
                    border: Border.all(color: theme.dividerColor),
                    onPressed: () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle(),
                  ),

                  const SizedBox(height: AppSpacing.p24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: theme.dividerColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'veya',
                          style: AppTextStyles.caption.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: theme.dividerColor)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.p24),

                  _AuthButton(
                    iconData: Icons.mail_outline,
                    text: 'E-posta ile giriş yap',
                    backgroundColor: colorScheme.surface,
                    textColor: colorScheme.onSurface,
                    border: Border.all(color: theme.dividerColor),
                    onPressed: () => context.push(AppRouter.emailLogin),
                  ),
                  const SizedBox(height: AppSpacing.p12),
                  _AuthButton(
                    iconData: Icons.person_add_outlined,
                    text: 'E-posta ile kayıt ol',
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    textColor: colorScheme.primary,
                    border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                    onPressed: () => context.push(AppRouter.register),
                  ),
                  const SizedBox(height: AppSpacing.p16),

                  _AuthButton(
                    iconData: Icons.face_retouching_natural_outlined,
                    text: 'Anonim olarak devam et',
                    backgroundColor: theme.brightness == Brightness.light 
                        ? AppColors.lightMuted.withOpacity(0.3)
                        : colorScheme.secondaryContainer.withOpacity(0.3),
                    textColor: theme.hintColor,
                    isDotted: true,
                    onPressed: () => context.go(AppRouter.root),
                  ),


                  const SizedBox(height: AppSpacing.p24),

                  // Bilgi Kutusu
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      color: AppColors.lightDestructive.withOpacity(0.05),
                      borderRadius: AppRadius.mainCard,
                    ),
                    child: Text(
                      "Anonim girişte verilerin yalnızca bu cihazda saklanır. Hesap oluşturursan cihazlar arası senkron yapabilirsin.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.micro.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
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
                          color: theme.hintColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Kullanım Koşulları',
                          style: AppTextStyles.micro.copyWith(
                            color: theme.hintColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        ' ve ',
                        style: AppTextStyles.micro.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Gizlilik Politikası',
                          style: AppTextStyles.micro.copyWith(
                            color: theme.hintColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        '\'nı kabul edersin.',
                        style: AppTextStyles.micro.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.p40),
                ],
              ),
            ),
            
            // Geri Butonu (En üstte olması için sona ekledik)
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                onPressed: () => context.go(AppRouter.onboarding),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colorScheme.onSurface,
                  size: 20,
                ),
              ),
            ),

            // Loading Overlay
            if (authState.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final BoxBorder? border;
  final bool isDotted;

  const _AuthButton({
    required this.iconData,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, color: textColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: AppTextStyles.bodySemibold.copyWith(
                    color: textColor,
                    fontSize: 16,
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
