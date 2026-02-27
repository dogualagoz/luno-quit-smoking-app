import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_radius.dart';

abstract final class AppTheme {
  static const shadowSm = [
    BoxShadow(
      color: Color(0x0D000000), // black %5 opacity
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];
  static const shadowLg = [
    BoxShadow(
      color: Color(0x1A000000), // black %10 opacity
      blurRadius: 15,
      offset: Offset(0, 4),
    ),
  ];

  // Açık Tema
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,

    // Renk Şeması
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightCard,
      error: AppColors.lightDestructive,
      onPrimary: Colors.white,
      onSecondary: AppColors.lightForeground,
      onSurface: AppColors.lightForeground,
    ),

    // Metin Teması
    textTheme: TextTheme(
      displayLarge: AppTextStyles.header,
      headlineMedium: AppTextStyles.pageHeader,
      titleMedium: AppTextStyles.cardHeader,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.bodySemibold,
      labelSmall: AppTextStyles.navLabel,
    ),
    // Kart Teması
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mainCard,
        side: const BorderSide(color: AppColors.lightBorder),
      ),
    ),
    // Buton Teması
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        textStyle: AppTextStyles.bodySemibold,
        elevation: 0,
      ),
    ),
  );
  // ─── KOYU TEMA (Dark) ───
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,

    // Renk Şeması
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkCard,
      error: AppColors.darkDestructive,
      onPrimary: Colors.white,
      onSecondary: AppColors.darkForeground,
      onSurface: AppColors.darkForeground,
    ),
    // Metin Teması (Aynı stiller, Flutter renkleri otomatik ayarlar)
    textTheme: TextTheme(
      displayLarge: AppTextStyles.header,
      headlineMedium: AppTextStyles.pageHeader,
      titleMedium: AppTextStyles.cardHeader,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.bodySemibold,
    ),
    // Kart Teması
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mainCard,
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),
    // Buton Teması
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        textStyle: AppTextStyles.bodySemibold,
        elevation: 0,
      ),
    ),
  );
}
