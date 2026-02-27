import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
class LunoApp extends StatelessWidget {
  const LunoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luno',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // Telefon ayarına göre otomatik
      home: const Scaffold(
        body: Center(
          child: Text('Luno 🫁'),
        ),
      ),
    );
  }
}