import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ayarlar ⚙️',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 28.8, // tema.md H1
              ),
            ),
          ],
        ),
        AppSpacing.elementGap,
        Text(
          'Kişiselleştir, düzenle, kendini tanı.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
