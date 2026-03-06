import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class SettingsToggleTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.p8),
      child: Row(
        children: [
          // İkon
          Icon(
            icon,
            size: 24,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: AppSpacing.p16),
          // Başlık
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodySemibold.copyWith(fontSize: 16),
            ),
          ),
          // Switch (Aç/Kapa)
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
            activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}
