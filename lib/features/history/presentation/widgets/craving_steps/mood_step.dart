import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/constants/craving_options.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/selection_chip_grid.dart';

class MoodStep extends StatelessWidget {
  final List<String> selectedMoods;
  final Function(String) onMoodSelected;
  final TextEditingController otherController;

  const MoodStep({
    super.key,
    required this.selectedMoods,
    required this.onMoodSelected,
    required this.otherController,
  });

  @override
  Widget build(BuildContext context) {
    final showOther = selectedMoods.contains('Diğer');

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.p24),
          Text(
            'DUYGU DURUMU',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            'Nasıl hissediyordun?',
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: AppSpacing.p24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectionChipGrid(
                    options: CravingOptions.moods,
                    selectedOptions: selectedMoods,
                    onSelected: onMoodSelected,
                  ),
                  if (showOther) ...[
                    const SizedBox(height: AppSpacing.p24),
                    Text(
                      'Hangi duygu? Lütfen yazın:',
                      style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
                    ),
                    const SizedBox(height: AppSpacing.p8),
                    LunoCard(
                      child: TextField(
                        controller: otherController,
                        decoration: InputDecoration(
                          hintText: 'Endişeli, Heyecanlı vs...',
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
