import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class DateTimeStep extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPickDate;

  const DateTimeStep({
    super.key,
    required this.selectedDate,
    required this.onPickDate,
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
            'ZAMAN',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            'Ne zamandı?',
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: AppSpacing.p40),
          InkWell(
            onTap: onPickDate,
            borderRadius: BorderRadius.circular(16),
            child: LunoCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.calendar_today, color: primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy').format(selectedDate),
                          style: AppTextStyles.bodySemibold,
                        ),
                        Text(
                          DateFormat('HH:mm').format(selectedDate),
                          style: AppTextStyles.caption.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
          Text(
            'Şu anı kaydetmek için direkt devam edebilirsin.',
            style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}
