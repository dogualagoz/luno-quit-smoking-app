import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _fadeController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Sürekli Nefes Alma (Pulse) Animasyonu
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 2. Giriş (Fade ve Slide) Animasyonu
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();

    // Yönlendirme (WelcomeScreen'e)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRouter.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Yumuşak Gradyan Arka Plan
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.surface,
              colors.primary.withOpacity(0.05),
              colors.primary.withOpacity(0.15),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasyonlu Ciğerito
              ScaleTransition(
                scale: _pulseAnimation,
                child: SvgPicture.asset(
                  'assets/images/mascot/default_cigerito.svg',
                  width: 160,
                  height: 160,
                ),
              ),
              const SizedBox(height: 40),
              // Kayarak gelen Logo Metni
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Cigerito',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              shadows: [
                                Shadow(
                                  color: colors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sağlıklı Nefese İlk Adım',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.primary.withOpacity(0.6),
                              letterSpacing: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
