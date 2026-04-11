import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/luno_button.dart';
import '../../../core/constants/asset_constants.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showOnboardingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.90, // Ekranın %90'ını kaplar
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: const OnboardingScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Maskot
              Center(
                child: SvgPicture.asset(
                  AssetConstants.cigeritoDefault,
                  height: 200,
                ),
              ),
              const SizedBox(height: 48),
              // Hoş Geldin Metni
              Text(
                "Cigerito'ya\nHoş Geldin",
                textAlign: TextAlign.center,
                style: AppTextStyles.header.copyWith(
                  color: colors.primary,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Sigarasız, sağlıklı ve özgür bir hayata\nadım atmaya hazır mısın?",
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                   color: colors.onSurface.withOpacity(0.7),
                   height: 1.5,
                ),
              ),
              const Spacer(),
              // Butonlar
              LunoButton(
                text: "Başlayalım",
                onPressed: () => _showOnboardingSheet(context),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "Zaten üye misin? ",
                    style: AppTextStyles.body.copyWith(
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => context.go(AppRouter.authSelection),
                          child: Text(
                            "O zaman giriş yap",
                            style: AppTextStyles.bodySemibold.copyWith(
                              color: colors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: colors.primary.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}
