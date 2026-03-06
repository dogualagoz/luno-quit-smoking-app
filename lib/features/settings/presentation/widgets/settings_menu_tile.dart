import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class SettingsMenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const SettingsMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.p12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color:
                  iconColor ??
                  theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: AppSpacing.p16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodySemibold.copyWith(fontSize: 16),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
