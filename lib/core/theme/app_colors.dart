import 'package:flutter/material.dart';

// Uygulama renk paleti
abstract final class AppColors {



  // Açık Tema
  static const Color lightBackground = Color(0xFFFAF8F5);
  static const lightForeground = Color(0xFF2D2A3E);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightPrimary = Color(0xFFE8A0BF);
  static const lightSecondary = Color(0xFFF0E6EF);
  static const lightMuted = Color(0xFFF3EFF2);
  static const lightMutedForeground = Color(0xFF8A8494);
  static const lightAccent = Color(0xFFFCE4EC);
  static const lightDestructive = Color(0xFFE57373);
  static const lightBorder = Color(0x142D2A3E); // rgba(45,42,62,0.08)
  static const lightInputBg = Color(0xFFF5F2F4);
  static const lightRing = Color(0xFFE8A0BF);

  // Açık Vurgu Renkleri
  static const lightChartPrimary = Color(0xFFE8A0BF);
  static const lightChartSuccess = Color(0xFFA8D8B9);
  static const lightChartInfo = Color(0xFFB8C5E8);
  static const lightChartWarning = Color(0xFFF0C987);
  static const lightChartPurple = Color(0xFFC4A8E8);

  // Koyu Tema
  static const darkBackground = Color(0xFF1A1625);
  static const darkForeground = Color(0xFFE8E4EF);
  static const darkCard = Color(0xFF231E30);
  static const darkPrimary = Color(0xFFD4789E);
  static const darkSecondary = Color(0xFF2D2640);
  static const darkMuted = Color(0xFF2D2640);
  static const darkMutedForeground = Color(0xFF9B95A8);
  static const darkAccent = Color(0xFF3A2D45);
  static const darkDestructive = Color(0xFFE57373);
  static const darkBorder = Color(0x1AE8E4EF); // rgba(232,228,239,0.1)
  static const darkRing = Color(0xFFD4789E);

  // Koyu Vurgu Renkleri
  static const darkChartPrimary = Color(0xFFD4789E);
  static const darkChartSuccess = Color(0xFF7BC49A);
  static const darkChartInfo = Color(0xFF8FA4D4);
  static const darkChartWarning = Color(0xFFDBB06E);
  static const darkChartPurple = Color(0xFFA87FD4);


  
  // Primary Gradient
  static const gradientPrimaryLight = [Color(0xFFE8A0BF), Color(0xFFD4789E)];
  static const gradientPrimaryDark  = [Color(0xFFD4789E), Color(0xFFB85E82)];
  // Success Gradient (Recovery Bar)
  static const gradientSuccessLight = [Color(0xFFA8D8B9), Color(0xFF7BC49A)];
  static const gradientSuccessDark  = [Color(0xFF7BC49A), Color(0xFF5AAF7A)];

  // 


    // ─── Ciğerito Maskot Renkleri ───
  static const mascotBody    = Color(0xFFF4C2D7);
  static const mascotBlush   = Color(0xFFF0A0B8);
  static const mascotBandaid = Color(0xFFFFE0B2);
  static const mascotOutline = Color(0xFFD4789E);
  static const mascotFace    = Color(0xFF2D2A3E); // eyes / mouth
  static const mascotTear    = Color(0xFFA8D8E8);
  static const mascotSparkle = Color(0xFFF0C987);
}

