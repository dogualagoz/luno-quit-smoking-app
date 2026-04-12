import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';

class LunoProgressBar extends StatelessWidget {
  final double value; // 0.0 ile 1.0 arası
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final List<Color>? gradientColors;
  final Duration duration;
  final Curve curve;

  const LunoProgressBar({
    super.key,
    required this.value,
    this.height = 10.0,
    this.backgroundColor,
    this.progressColor,
    this.gradientColors,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic, // Hızlı başlayıp yavaşlayan (Ease Out)
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: AppRadius.progressBar,
      ),
      child: AnimatedFractionallySizedBox(
        duration: duration,
        curve: curve,
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: gradientColors == null
                ? (progressColor ?? theme.colorScheme.primary)
                : null,
            gradient: gradientColors != null
                ? LinearGradient(colors: gradientColors!)
                : null,
            borderRadius: AppRadius.progressBar,
          ),
        ),
      ),
    );
  }
}
