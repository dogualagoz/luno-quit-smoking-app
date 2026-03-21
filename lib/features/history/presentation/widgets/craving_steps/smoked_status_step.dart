import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class SmokedStatusStep extends StatelessWidget {
  final bool hasSmoked;
  final ValueChanged<bool> onValueChanged;

  const SmokedStatusStep({
    super.key,
    required this.hasSmoked,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.p24),
          Text(
            'SONUÇ',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            'Sigara içip içmediğini belirt lütfen',
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: AppSpacing.p40),
          LunoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildOption(
                  context,
                  title: 'Evet, maalesef içtim',
                  subtitle: 'Yenilgi değil, bir geri bildirim.',
                  isSelected: hasSmoked,
                  onTap: () => onValueChanged(true),
                  primaryColor: primaryColor,
                  icon: Icons.smoking_rooms,
                ),
                const Divider(height: 1),
                _buildOption(
                  context,
                  title: 'Hayır, direndim!',
                  subtitle: 'Harikasın, bir zafer daha!',
                  isSelected: !hasSmoked,
                  onTap: () => onValueChanged(false),
                  primaryColor: primaryColor,
                  icon: Icons.verified,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
    required IconData icon,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? primaryColor : Theme.of(context).hintColor,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodySemibold.copyWith(
          color: isSelected ? primaryColor : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(
          color: Theme.of(context).hintColor,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: primaryColor)
          : null,
      onTap: onTap,
    );
  }
}
