import 'package:flutter/material.dart';

// Boşluklar (Padding/Margin)
abstract final class AppSpacing {
  // Sayısal değerler
  static const double p8 = 8.0;
  static const double p10 = 10.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p96 = 96.0;

  //EdgeInsets (Direkt kullanım için)
  static const pageHorizontal = EdgeInsets.symmetric(horizontal: p20);
  static const pageTop = EdgeInsets.only(top: p24);

  // Card Padding
  static const cardPadding = EdgeInsets.all(p16); // default
  static const cardPaddingLarge = EdgeInsets.all(p24); // relaxed

  static const iconPadding = EdgeInsets.all(p10);
  static const bottomNavPaddingB = EdgeInsets.only(bottom: p24);
  static const contentBottom = EdgeInsets.only(bottom: p96);

  // SizedBox (boşluklar)x
  static const sectionGap = SizedBox(height: p20);
  static const sectionGapLarge = SizedBox(height: p24);

  // CardGap
  static const cardGap = SizedBox(width: p12, height: p12);

  // ElementGap
  static const elementGap = SizedBox(height: p8);
  static const elementGapLarge = SizedBox(height: p10);

  // Sabit yükseklikler
  static const double bottomNavHeight = 80.0;

}
