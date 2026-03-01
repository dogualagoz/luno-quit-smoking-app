import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/main_screen.dart';
import 'package:luno_quit_smoking_app/core/widgets/main_shell.dart';

class AppRouter {
  // Sayfa isimleriin (adreslerini tanımlıyoruz)

  // Ana sayfanın adresi
  static const String root = '/';
  static const String damage = '/damage';
  static const String recovery = '/recovery';
  static const String crisis = '/crisis';
  static const String history = '/history';
  static const String settings = '/settings';

  // router ayarlarını yapıyoruz
  static final router = GoRouter(
    // uygulama ilk açıldığında hangi adrese gidecek ?
    initialLocation: root, //
    routes: [
      // Ana sayfa tanımı
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: root,
                builder: (context, state) => const MainScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: root,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: "Zararlar"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: root,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: "İyileşme"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: root,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: "Kriz"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: root,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: "Geçmiş"),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: settings,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: "Ayarlar"),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(title)));
}
