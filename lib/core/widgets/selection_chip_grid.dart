import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';

/// Reusable selection chip grid for cravings options (Moods, Activities, Companions)
class SelectionChipGrid extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final Function(String) onSelected;
  final bool multiSelect;

  const SelectionChipGrid({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelected,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.p8,
      runSpacing: AppSpacing.p8,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        return GestureDetector(
          onTap: () => onSelected(option),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.p16,
              vertical: AppSpacing.p8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkChartSuccess
                        : AppColors.lightChartSuccess)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
