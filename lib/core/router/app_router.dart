import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/main/presentation/main_screen.dart';
import '../../core/widgets/main_shell.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/damage/presentation/damage_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/auth_selection_screen.dart';
import '../../features/auth/presentation/email_login_screen.dart';
import '../../features/auth/presentation/email_register_screen.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/onboarding/data/onboarding_repository.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingRepo = ref.watch(onboardingRepositoryProvider);

  return GoRouter(
    initialLocation: AppRouter.onboarding,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isBoardingFinished = onboardingRepo.isProfileCreated();

      final goingToOnboarding = state.matchedLocation == AppRouter.onboarding;
      final goingToAuth =
          state.matchedLocation == AppRouter.authSelection ||
          state.matchedLocation == AppRouter.emailLogin ||
          state.matchedLocation == AppRouter.register;

      // 1. Giriş yapılmışsa ve auth sayfalarındaysa -> Ana Sayfa
      if (isLoggedIn && (goingToAuth || goingToOnboarding)) {
        return AppRouter.root;
      }

      // 2. Giriş yapılmamışsa ama onboarding bitmişse ve onboarding sayfasındaysa -> Auth Selection
      if (!isLoggedIn && isBoardingFinished && goingToOnboarding) {
        return AppRouter.authSelection;
      }

      // 3. Hiçbir durum uymuyorsa olduğu yerde kalsın
      return null;
    },
    routes: [
      GoRoute(
        path: AppRouter.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRouter.authSelection,
        builder: (context, state) {
          final userName = state.extra as String? ?? "Dostum";
          return AuthSelectionScreen(userName: userName);
        },
      ),
      GoRoute(
        path: AppRouter.emailLogin,
        builder: (context, state) => const EmailLoginScreen(),
      ),
      GoRoute(
        path: AppRouter.register,
        builder: (context, state) => const EmailRegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.root,
                builder: (context, state) => const MainScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.damage,
                builder: (context, state) => const DamageScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.recovery,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: "İyileşme"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.crisis,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: "Kriz"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.history,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: "Geçmiş"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class AppRouter {
  // Sayfa isimleriin (adreslerini tanımlıyoruz)

  // Ana sayfanın adresi
  static const String root = '/';
  static const String onboarding = '/onboarding';
  static const String authSelection = '/auth-selection';
  static const String emailLogin = '/email-login';
  static const String register = '/register';
  static const String damage = '/damage';
  static const String recovery = '/recovery';
  static const String crisis = '/crisis';
  static const String history = '/history';
  static const String settings = '/settings';
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(title)));
}
