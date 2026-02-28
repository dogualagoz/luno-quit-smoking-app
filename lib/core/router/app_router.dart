import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/main_screen.dart';

class AppRouter {
  // Sayfa isimleriin (adreslerini tanımlıyoruz)

  // Ana sayfanın adresi
  static const String root = '/';

  static const String settings = '/settings';

  // router ayarlarını yapıyoruz
  static final router = GoRouter(

    // uygulama ilk açıldığında hangi adrese gidecek ?
    initialLocation: root, //
    routes: [
      // Ana sayfa tanımı
      GoRoute(
        path: root,
        builder: (context, state) => const MainScreen()
        )
      ,

      // Ayarlar sayfası
      GoRoute(
        path: settings,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Settings'))
        )
      )   
    ]
  );
}
