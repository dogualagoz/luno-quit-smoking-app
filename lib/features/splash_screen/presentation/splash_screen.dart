import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Giriş sekansı — tüm entrance animasyonlarını sürüyor
  late final AnimationController _entranceController;

  // Sürekli çalışanlar
  late final AnimationController _floatController;
  late final AnimationController _glowController;

  // Arka plan
  late final Animation<double> _bgFade;

  // Işıma halkası (character'ın arkasındaki glow)
  late final Animation<double> _glowOpacity;
  late final Animation<double> _glowScale;

  // Karakter
  late final Animation<double> _characterScale;
  late final Animation<double> _characterFade;

  // Logo
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoLetterSpacing;

  // Tagline
  late final Animation<double> _taglineFade;
  late final Animation<double> _taglineSlide;

  // İdle float
  late final Animation<double> _floatOffset;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));

    // ── Controller'lar ──────────────────────────────────────────────────────

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // ── Arka plan ───────────────────────────────────────────────────────────

    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // ── Glow halkası ────────────────────────────────────────────────────────

    _glowOpacity = Tween<double>(begin: 0.4, end: 0.75).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowScale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // ── Karakter: elastic scale-in ───────────────────────────────────────────

    _characterFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.08, 0.35, curve: Curves.easeIn),
      ),
    );

    _characterScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.08, 0.65, curve: Curves.elasticOut),
      ),
    );

    // ── Logo: scale + letter-spacing ─────────────────────────────────────────

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.52, 0.75, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.52, 0.78, curve: Curves.easeOutBack),
      ),
    );

    _logoLetterSpacing = Tween<double>(begin: 8.0, end: 2.5).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.52, 0.82, curve: Curves.easeOut),
      ),
    );

    // ── Tagline ──────────────────────────────────────────────────────────────

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.70, 0.92, curve: Curves.easeOut),
      ),
    );

    _taglineSlide = Tween<double>(begin: 16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.70, 0.92, curve: Curves.easeOutCubic),
      ),
    );

    // ── Float ────────────────────────────────────────────────────────────────

    _floatOffset = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _entranceController.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go(AppRouter.onboarding);
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.surface,
      body: FadeTransition(
        opacity: _bgFade,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Arka plan gradyanı ──────────────────────────────────────────
            _BackgroundGradient(colors: colors, isDark: isDark),

            // ── İçerik ─────────────────────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // Glow + Karakter
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow halkası
                        AnimatedBuilder(
                          animation: _glowController,
                          builder: (context, _) {
                            return Opacity(
                              opacity: _glowOpacity.value,
                              child: Transform.scale(
                                scale: _glowScale.value,
                                child: Container(
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        colors.primary.withValues(alpha: 0.28),
                                        colors.primary.withValues(alpha: 0.10),
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.6, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Karakter (Hero ile welcome'a uçuyor)
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _entranceController,
                            _floatController,
                          ]),
                          builder: (context, child) {
                            final floatY = _entranceController.isCompleted
                                ? _floatOffset.value
                                : 0.0;
                            return FadeTransition(
                              opacity: _characterFade,
                              child: Transform.translate(
                                offset: Offset(0, floatY),
                                child: ScaleTransition(
                                  scale: _characterScale,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'cigerito-mascot',
                            child: SvgPicture.asset(
                              'assets/images/mascot/default_cigerito.svg',
                              width: 180,
                              height: 180,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Logo
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, _) {
                      return FadeTransition(
                        opacity: _logoFade,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Text(
                            'Cigerito',
                            style: AppTextStyles.header.copyWith(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: colors.primary,
                              letterSpacing: _logoLetterSpacing.value,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, _) {
                      return FadeTransition(
                        opacity: _taglineFade,
                        child: Transform.translate(
                          offset: Offset(0, _taglineSlide.value),
                          child: Text(
                            'Sağlıklı Nefese İlk Adım',
                            style: AppTextStyles.body.copyWith(
                              color: colors.primary.withValues(alpha: 0.55),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 4),

                  // Alt versiyon / dekoratif çizgi
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: _BottomDots(color: colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Yardımcı widget'lar ──────────────────────────────────────────────────────

class _BackgroundGradient extends StatelessWidget {
  final ColorScheme colors;
  final bool isDark;

  const _BackgroundGradient({required this.colors, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackground,
                  Color.lerp(
                    AppColors.darkBackground,
                    AppColors.darkPrimary,
                    0.12,
                  )!,
                  Color.lerp(
                    AppColors.darkBackground,
                    AppColors.darkPrimary,
                    0.22,
                  )!,
                ]
              : [
                  AppColors.lightBackground,
                  Color.lerp(
                    AppColors.lightBackground,
                    AppColors.lightPrimary,
                    0.08,
                  )!,
                  Color.lerp(
                    AppColors.lightBackground,
                    AppColors.lightPrimary,
                    0.18,
                  )!,
                ],
        ),
      ),
    );
  }
}

// Üç küçük dekoratif nokta
class _BottomDots extends StatefulWidget {
  final Color color;
  const _BottomDots({required this.color});

  @override
  State<_BottomDots> createState() => _BottomDotsState();
}

class _BottomDotsState extends State<_BottomDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _dotAnim(double offset) {
    final begin = offset;
    final end = (offset + 0.4).clamp(0.0, 1.0);
    return Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(_dotAnim(0.0)),
            const SizedBox(width: 6),
            _dot(_dotAnim(0.2)),
            const SizedBox(width: 6),
            _dot(_dotAnim(0.4)),
          ],
        );
      },
    );
  }

  Widget _dot(Animation<double> anim) {
    return Opacity(
      opacity: anim.value,
      child: Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
