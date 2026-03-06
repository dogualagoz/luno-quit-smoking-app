import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';

class DamageHeader extends StatelessWidget {
  const DamageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Hasar Raporu",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            const Text("🩹", style: TextStyle(fontSize: 24)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Kötü haberlerim var. İyi haberlerim de var ama önce kötüleri dinle.",
          style: textTheme.bodyMedium?.copyWith(
            color: theme.hintColor.withValues(alpha: 0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
