import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/luno_button.dart';
import '../../../diary/application/history_provider.dart';
import '../../../diary/data/models/daily_log.dart';

/// Bottom sheet triggered by the "Sigara İçtim" button on TodaySummaryCard.
/// Two options: quick +1 or navigate to the full slip-log form.
void showQuickLogSheet(BuildContext context, WidgetRef ref) {
  HapticFeedback.lightImpact();
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bgColor = isDark
      ? Theme.of(context).colorScheme.surface
      : AppColors.lightBackground;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext sheetContext) {
      return SafeArea(
        bottom: true,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.p24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.p24),
              Text(
                "Bi' sigara yandı...",
                style: AppTextStyles.cardHeader.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppSpacing.p8),
              Text(
                "Neden içtiğine dair not düşmek ister misin? Yoksa sadece sayıyı mı ekleyelim?",
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.p32),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.flash_on_rounded),
                  label: const Text("Boş ver, sadece 1 sigara ekle"),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: isDark
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Colors.grey.shade200,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final log = DailyLog(
                      id: const Uuid().v4(),
                      date: DateTime.now(),
                      cravingIntensity: 0,
                      hasSmoked: true,
                      smokeCount: 1,
                      type: 'slip',
                      moods: const [],
                      context: const [],
                      companions: const [],
                    );
                    ref.read(historyLogsProvider.notifier).addLog(log);
                    ref.read(analyticsServiceProvider).logSmokeLogged(count: 1);
                    Navigator.pop(sheetContext);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.p12),
              SizedBox(
                width: double.infinity,
                child: LunoButton(
                  text: "Neden içtiğini paylaş",
                  icon: Icons.edit_note_rounded,
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.push(AppRouter.slipLog);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.p24),
            ],
          ),
        ),
      );
    },
  );
}
