import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

enum MilestoneStatus { completed, active, locked }

class RecoveryTimelineTile extends StatelessWidget {
  final String title;
  final String description;
  final String durationText;
  final String quote;
  final MilestoneStatus status;
  final bool isLast;

  const RecoveryTimelineTile({
    super.key,
    required this.title,
    required this.description,
    required this.durationText,
    required this.quote,
    required this.status,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final successColor = isDark
        ? AppColors.darkChartSuccess
        : AppColors.lightChartSuccess;
    final activeColor = theme.colorScheme.primary;
    final lockedColor = theme.hintColor.withValues(alpha: 0.2);

    Color getStatusColor() {
      switch (status) {
        case MilestoneStatus.completed:
          return successColor;
        case MilestoneStatus.active:
          return activeColor;
        case MilestoneStatus.locked:
          return lockedColor;
      }
    }

    Widget buildIcon() {
      switch (status) {
        case MilestoneStatus.completed:
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: successColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 16, color: Colors.white),
          );
        case MilestoneStatus.active:
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: activeColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              size: 16,
              color: Colors.white,
            ),
          );
        case MilestoneStatus.locked:
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              shape: BoxShape.circle,
              border: Border.all(color: lockedColor, width: 2),
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 14,
              color: theme.hintColor.withValues(alpha: 0.4),
            ),
          );
      }
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line and Icon
          SizedBox(
            width: 40,
            child: Column(
              children: [
                const SizedBox(height: 12),
                buildIcon(),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: getStatusColor().withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          // Card Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.p24),
              child: LunoCard(
                border: status == MilestoneStatus.active
                    ? Border.all(
                        color: activeColor.withValues(alpha: 0.5),
                        width: 2,
                      )
                    : null,
                color: status == MilestoneStatus.locked
                    ? theme.cardColor.withValues(alpha: 0.5)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            durationText,
                            style: AppTextStyles.micro.copyWith(
                              color: getStatusColor(),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (status == MilestoneStatus.active) ...[
                          const SizedBox(width: 8),
                          Text(
                            "← Buradasın",
                            style: AppTextStyles.micro.copyWith(
                              color: activeColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.p8),
                    Text(
                      title,
                      style: AppTextStyles.bodySemibold.copyWith(
                        fontSize: 16,
                        color: status == MilestoneStatus.locked
                            ? theme.hintColor
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13,
                        color: theme.hintColor.withValues(
                          alpha: status == MilestoneStatus.locked ? 0.4 : 0.7,
                        ),
                      ),
                    ),
                    if (status != MilestoneStatus.locked &&
                        quote.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.p12),
                      Text(
                        "\"$quote\"",
                        style: AppTextStyles.body.copyWith(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: theme.hintColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
