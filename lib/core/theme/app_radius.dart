import 'package:flutter/material.dart';

// Kenar yuvarlaklığı

abstract final class AppRadius {
  // Sayısal değerler
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double circular = 9999.0;

  // Border Radius Nesneleri
  static final mainCard = BorderRadius.circular(r16);
  static final button = BorderRadius.circular(r16);
  static final input = BorderRadius.circular(r12);
  static final iconContainer = BorderRadius.circular(r12);
  static final chip = BorderRadius.circular(r12);
  static final checkBox = BorderRadius.circular(r8);
  static final mascotBubble = BorderRadius.circular(r16);

  // Progress bar
  static final progressBar = BorderRadius.circular(circular);
  


}
