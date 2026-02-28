import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class LunoApp extends StatelessWidget {
  const LunoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Luno',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // Telefon ayarına göre otomatik
      routerConfig: AppRouter.router,
    );
  }
}
