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
import '../../features/history/presentation/pages/craving_screen.dart';
import '../../features/history/presentation/pages/slip_log_screen.dart';
import '../../features/history/presentation/pages/history_screen.dart';
import '../../features/crisis/presentation/crisis_screen.dart';
import '../../features/main/presentation/pages/details/money_details_screen.dart';
import '../../features/main/presentation/pages/details/cigarettes_details_screen.dart';
import '../../features/main/presentation/pages/details/time_details_screen.dart';
import '../../features/main/presentation/pages/details/recovery_details_screen.dart';

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
      GoRoute(
        path: AppRouter.craving,
        builder: (context, state) => const CravingScreen(),
      ),
      GoRoute(
        path: AppRouter.slipLog,
        builder: (context, state) => const SlipLogScreen(),
      ),
      GoRoute(
        path: AppRouter.moneyDetails,
        builder: (context, state) => const MoneyDetailsScreen(),
      ),
      GoRoute(
        path: AppRouter.cigarettesDetails,
        builder: (context, state) => const CigarettesDetailsScreen(),
      ),
      GoRoute(
        path: AppRouter.timeDetails,
        builder: (context, state) => const TimeDetailsScreen(),
      ),
      GoRoute(
        path: AppRouter.recoveryDetails,
        builder: (context, state) => const RecoveryDetailsScreen(),
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
                path: AppRouter.crisis,
                builder: (context, state) => const CrisisScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.history,
                builder: (context, state) => const HistoryScreen(),
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
  static const String crisis = '/crisis';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String craving = '/craving';
  static const String slipLog = '/slip-log';
  static const String moneyDetails = '/money-details';
  static const String cigarettesDetails = '/cigarettes-details';
  static const String timeDetails = '/time-details';
  static const String recoveryDetails = '/recovery-details';
}
