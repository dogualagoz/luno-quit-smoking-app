import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';

class SpeechBubble extends StatelessWidget {
  final String text;
  const SpeechBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none, // Okun dışarı taşmasına izin veriyoruz
        children: [
          // ANA BALON
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppRadius.mascotBubble,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // BALONUN OKU (Arrow)
          Positioned(
            top: -7, // Balonun üst kenarından dışarı taşacak
            child: Transform.rotate(
              angle: 0.785, // 45 derece döndürerek üçgen efekti veriyoruz
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    left: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      width: 2,
                    ),
                    top: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
