import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/luno_button.dart';
import '../../../core/constants/asset_constants.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // Karakter Hero ile geldiği için karakter entrance yok, sadece float
  late final AnimationController _floatController;

  // İçerik stagger — Hero transition bittikten sonra başlasın diye geciktiriliyor
  late final AnimationController _entranceController;

  // Default → Happy crossfade (butona basınca tetiklenir)
  late final AnimationController _expressionController;
  late final Animation<double> _defaultFade;
  late final Animation<double> _happyFade;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _loginFade;

  late final Animation<double> _floatOffset;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // İçerik 500ms gecikmeyle başlar — Hero uçuşu bitmeden önce içerik
    // görünür olsun ama karmaşaya neden olmasın
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Başlık
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    // Alt yazı
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.68, curve: Curves.easeOut),
      ),
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.68, curve: Curves.easeOutCubic),
      ),
    );

    // Başlayalım butonu
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.32, 0.80, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.32, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    // Giriş yap linki
    _loginFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    // Float
    _floatOffset = Tween<double>(begin: -7.0, end: 7.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Expression: default → happy crossfade
    _expressionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // Default: hızlıca soluyor
    _defaultFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _expressionController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );
    // Happy: biraz gecikmeli beliriyor — hafif overlap crossfade
    _happyFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _expressionController,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
      ),
    );

    // Hero geçişi ~800ms sürdüğünden içerik 400ms sonra başlasın
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _entranceController.dispose();
    _expressionController.dispose();
    super.dispose();
  }

  void _onStartPressed() {
    _expressionController.forward();
    Future.delayed(const Duration(milliseconds: 420), () {
      if (mounted) _showOnboardingSheet(context);
    });
  }

  void _showOnboardingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.90,
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

              // Maskot: Hero ile gelir, float + expression crossfade
              AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatOffset.value),
                    child: child,
                  );
                },
                child: Center(
                  child: Hero(
                    tag: 'cigerito-mascot',
                    flightShuttleBuilder: (_, __, ___, ____, _____) {
                      return SvgPicture.asset(
                        AssetConstants.cigeritoDefault,
                        height: 200,
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _expressionController,
                      builder: (context, _) {
                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Default — soluyor
                              FadeTransition(
                                opacity: _defaultFade,
                                child: SvgPicture.asset(
                                  AssetConstants.cigeritoDefault,
                                  height: 200,
                                ),
                              ),
                              // Happy — beliriyor
                              FadeTransition(
                                opacity: _happyFade,
                                child: SvgPicture.asset(
                                  AssetConstants.cigeritoHappy,
                                  height: 200,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Başlık
              FadeTransition(
                opacity: _titleFade,
                child: SlideTransition(
                  position: _titleSlide,
                  child: Text(
                    "Cigerito'ya\nHoş Geldin",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.header.copyWith(
                      color: colors.primary,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Alt yazı
              FadeTransition(
                opacity: _subtitleFade,
                child: SlideTransition(
                  position: _subtitleSlide,
                  child: Text(
                    "Sigarasız, sağlıklı ve özgür bir hayata\nadım atmaya hazır mısın?",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Başlayalım butonu
              FadeTransition(
                opacity: _buttonFade,
                child: SlideTransition(
                  position: _buttonSlide,
                  child: LunoButton(
                    text: "Başlayalım",
                    onPressed: _onStartPressed,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Giriş yap linki
              FadeTransition(
                opacity: _loginFade,
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Zaten üye misin? ",
                      style: AppTextStyles.body.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.6),
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => context.push(AppRouter.emailLogin),
                            child: Text(
                              "Giriş yap",
                              style: AppTextStyles.bodySemibold.copyWith(
                                color: colors.primary,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    colors.primary.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
