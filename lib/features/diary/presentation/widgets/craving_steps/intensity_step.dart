import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class IntensityStep extends StatelessWidget {
  final double value;
  final ValueChanged<double> onValueChanged;

  const IntensityStep({
    super.key,
    required this.value,
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
            'İSTEK ŞİDDETİ',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            'Sigara içme isteğin ne kadar güçlüydü?',
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: AppSpacing.p40),
          LunoCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hiç',
                      style: AppTextStyles.caption.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                      'Çıldırtıcı!',
                      style: AppTextStyles.caption.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: value,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: primaryColor,
                  label: value.round().toString(),
                  onChanged: onValueChanged,
                ),
                Text(
                  value.round().toString(),
                  style: AppTextStyles.largeNumber.copyWith(
                    color: primaryColor,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
