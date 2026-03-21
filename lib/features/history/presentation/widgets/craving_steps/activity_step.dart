import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/constants/craving_options.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/selection_chip_grid.dart';

class ActivityStep extends StatelessWidget {
  final List<String> selectedActivities;
  final Function(String) onActivitySelected;
  final TextEditingController otherController;

  const ActivityStep({
    super.key,
    required this.selectedActivities,
    required this.onActivitySelected,
    required this.otherController,
  });

  @override
  Widget build(BuildContext context) {
    final showOther = selectedActivities.contains('Diğer');

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.p24),
          Text(
            'KOŞULLAR',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            'O sırada ne yapıyordun?',
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: AppSpacing.p24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectionChipGrid(
                    options: CravingOptions.activities,
                    selectedOptions: selectedActivities,
                    onSelected: onActivitySelected,
                  ),
                  if (showOther) ...[
                    const SizedBox(height: AppSpacing.p24),
                    Text(
                      'Hangi aktivite? Lütfen yazın:',
                      style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
                    ),
                    const SizedBox(height: AppSpacing.p8),
                    LunoCard(
                      child: TextField(
                        controller: otherController,
                        decoration: InputDecoration(
                          hintText: 'Yemek sonrası, kahve yanı vs...',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.p40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
