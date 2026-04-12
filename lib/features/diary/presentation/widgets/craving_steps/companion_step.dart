import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/constants/craving_options.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/selection_chip_grid.dart';

class CompanionStep extends StatelessWidget {
  final List<String> selectedCompanions;
  final Function(String) onCompanionSelected;

  const CompanionStep({
    super.key,
    required this.selectedCompanions,
    required this.onCompanionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.p24),
          Text(
            'SOSYAL DURUM',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            'Kiminleydin?',
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: AppSpacing.p4),
          Text(
            'En çok kime duman çarptı? Sadece bir tane seçelim.',
            style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: AppSpacing.p24),
          Expanded(
            child: SingleChildScrollView(
              child: SelectionChipGrid(
                options: CravingOptions.companions,
                selectedOptions: selectedCompanions,
                onSelected: onCompanionSelected,
                multiSelect: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
