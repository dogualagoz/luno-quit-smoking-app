import 'package:flutter/material.dart';
import '../../../../core/widgets/speech_bubble.dart';

/// Ciğerito'nun sayfadaki konumu
enum MascotPosition {
  center,   // Yorum sayfaları: ortada, büyük
  topLeft,  // Soru sayfaları: sol üst, küçük
}

/// Her onboarding adımının konfigürasyonu
class OnboardingStepConfig {
  final MascotPosition mascotPosition;
  final double mascotSize;
  final String bubbleText;
  final BubbleArrowDirection arrowDirection;
  final String buttonLabel;
  final Widget? contentWidget;

  const OnboardingStepConfig({
    required this.mascotPosition,
    required this.mascotSize,
    required this.bubbleText,
    required this.arrowDirection,
    this.buttonLabel = "Devam",
    this.contentWidget,
  });
}
