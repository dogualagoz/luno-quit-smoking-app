import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';

class TodaySummaryCard extends StatelessWidget {
  final List<dynamic> logs;

  const TodaySummaryCard({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final todayLogs = logs.where((log) {
      final now = DateTime.now();
      return log.date.year == now.year &&
          log.date.month == now.month &&
          log.date.day == now.day;
    }).toList();

    final int todayTotal = todayLogs.fold(
      0,
      (sum, log) => sum + (log.smokeCount as int),
    );

    return LunoCard(
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bugün Kaç Tane? 🚬",
            style: AppTextStyles.cardHeader.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                todayTotal.toString(),
                style: AppTextStyles.largeNumber.copyWith(
                  fontSize: 56,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "sigara",
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: LunoButton(
              text: "Tekrar İçtim",
              icon: Icons.add_circle_outline,
              onPressed: () {
                context.push(AppRouter.craving);
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              todayTotal > 0
                  ? "Ortalama civarı. Ama ortalama olmak da bir hedef değil ya."
                  : "Tertemiz, bugün duman yok!",
              style: AppTextStyles.caption.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
