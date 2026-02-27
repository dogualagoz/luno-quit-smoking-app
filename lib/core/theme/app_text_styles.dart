import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Uygulama tipografi sistemi
abstract final class AppTextStyles {
  // Başlıklar
  static TextStyle get header =>
      GoogleFonts.nunito(fontSize: 28.8, fontWeight: FontWeight.w800);
  static TextStyle get pageHeader =>
      GoogleFonts.nunito(fontSize: 22.4, fontWeight: FontWeight.w700);
  static TextStyle get cardHeader =>
      GoogleFonts.nunito(fontSize: 17.6, fontWeight: FontWeight.w700);

  // Sayılar
  static TextStyle get largeNumber =>
      GoogleFonts.nunito(fontSize: 48, fontWeight: FontWeight.w800);

  static TextStyle get statValue =>
      GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w700);

  static TextStyle get summaryValue =>
      GoogleFonts.nunito(fontSize: 20.8, fontWeight: FontWeight.w800);

  static TextStyle get body => GoogleFonts.nunito(
    fontSize: 14.1,
    fontWeight: FontWeight.w400,
  );

   static TextStyle get bodySemibold => GoogleFonts.nunito(
        fontSize: 13.6,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get label => GoogleFonts.nunito(
        fontSize: 13.1,
        fontWeight: FontWeight.w600,
      );

  // Yardımcı Metinler
  static TextStyle get buttonQuickPick => GoogleFonts.nunito(
        fontSize: 12.8,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get caption => GoogleFonts.nunito(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get hint => GoogleFonts.nunito(
        fontSize: 11.5,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get micro => GoogleFonts.nunito(
        fontSize: 10.9,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get navLabel => GoogleFonts.nunito(
        fontSize: 9.6,
        fontWeight: FontWeight.w600,
      );


  
}
