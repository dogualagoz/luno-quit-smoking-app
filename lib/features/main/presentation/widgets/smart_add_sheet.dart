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

/// FAB-triggered bottom sheet offering three quick log shortcuts.
void showSmartAddSheet(BuildContext context, WidgetRef ref) {
  HapticFeedback.lightImpact();
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bgColor = isDark
      ? Theme.of(context).colorScheme.surface
      : AppColors.lightBackground;
  final primary = context.primary;
  final successColor = context.chartSuccess;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        bottom: true,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.p24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
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
                'Kayıt Ekle',
                style: AppTextStyles.cardHeader.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppSpacing.p8),
              Text(
                'Dürüstçe kaydetmek en büyük adımdır.',
                style: AppTextStyles.caption
                    .copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: AppSpacing.p24),
              _SheetOption(
                icon: Icons.flash_on_rounded,
                title: 'Sadece 1 sigara ekle',
                color: primary,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(sheetContext);
                  _quickAddOne(ref);
                },
              ),
              const SizedBox(height: AppSpacing.p12),
              _SheetOption(
                icon: Icons.edit_note_rounded,
                title: 'Detaylı kayıt',
                color: primary,
                isPrimary: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.push(AppRouter.craving);
                },
              ),
              const SizedBox(height: AppSpacing.p12),
              _SheetOption(
                icon: Icons.shield_outlined,
                title: 'Krize direndim',
                color: successColor,
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.push(AppRouter.craving, extra: false);
                },
              ),
              const SizedBox(height: AppSpacing.p24),
            ],
          ),
        ),
      );
    },
  );
}

void _quickAddOne(WidgetRef ref) {
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
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool isPrimary;

  const _SheetOption({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        child: LunoButton(text: title, icon: icon, onPressed: onTap),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: Icon(icon),
        label: Text(title),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isDark
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Colors.grey.shade200,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
      ),
    );
  }
}
