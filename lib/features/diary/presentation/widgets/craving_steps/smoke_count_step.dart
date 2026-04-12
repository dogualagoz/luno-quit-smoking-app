import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class SmokeCountStep extends StatelessWidget {
  final int count;
  final ValueChanged<int> onValueChanged;

  const SmokeCountStep({
    super.key,
    required this.count,
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
            'MİKTAR',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            'Kaç tane içtin?',
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: AppSpacing.p40),
          LunoCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIncrementButton(
                  context,
                  Icons.remove,
                  () {
                    if (count > 1) onValueChanged(count - 1);
                  },
                  primaryColor,
                ),
                const SizedBox(width: 32),
                Column(
                  children: [
                    Text(
                      count.toString(),
                      style: AppTextStyles.largeNumber.copyWith(
                        fontSize: 64,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1,
                      ),
                    ),
                    Text(
                      "sigara",
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                _buildIncrementButton(
                  context,
                  Icons.add,
                  () => onValueChanged(count + 1),
                  primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncrementButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    Color primaryColor,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: primaryColor,
          size: 28,
        ),
      ),
    );
  }
}
