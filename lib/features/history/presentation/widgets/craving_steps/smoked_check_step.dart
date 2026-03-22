import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class SmokedCheckStep extends StatelessWidget {
  final bool? hasSmoked;
  final ValueChanged<bool> onStatusChanged;

  const SmokedCheckStep({
    super.key,
    required this.hasSmoked,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bugün nasıl geçti?",
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: 8),
          Text(
            "Ciğerito senin için not alıyor. Bugün hiç sigara içtin mi?",
            style: AppTextStyles.body.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: AppSpacing.p32),
          
          // Kartlar
          Row(
            children: [
              // İÇMEDİM (Başarı)
              Expanded(
                child: _OptionCard(
                  title: "Hayır,\nİçmedim!",
                  subtitle: "Krizi yendim",
                  icon: Icons.shield_outlined,
                  color: isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess,
                  isSelected: hasSmoked == false,
                  onTap: () => onStatusChanged(false),
                ),
              ),
              const SizedBox(width: AppSpacing.p16),
              // İÇTİM (Slip)
              Expanded(
                child: _OptionCard(
                  title: "Evet,\nİçtim",
                  subtitle: "Kaçamak yaptım",
                  icon: Icons.smoking_rooms,
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  isSelected: hasSmoked == true,
                  onTap: () => onStatusChanged(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.p16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : AppColors.lightBorder.withValues(alpha: 0.1),
            width: 2,
          ),
          boxShadow: isSelected 
            ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))]
            : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.p16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySemibold.copyWith(
                color: isSelected ? color : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
