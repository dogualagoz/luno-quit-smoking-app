import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/luno_button.dart';
import '../../../diary/application/history_provider.dart';
import '../../../diary/data/models/daily_log.dart';

/// Bottom sheet with a +/- counter for logging "a few cigarettes" without
/// going through the full craving flow.
void showQuickCountSheet(BuildContext context, WidgetRef ref) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bgColor = isDark
      ? Theme.of(context).colorScheme.surface
      : AppColors.lightBackground;
  final primary = context.primary;

  int count = 1;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (ctx, setSheetState) {
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
                    'Kaç tane oldu?',
                    style: AppTextStyles.cardHeader.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: AppSpacing.p32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CountButton(
                        icon: Icons.remove,
                        color: primary,
                        onTap: () {
                          if (count > 1) {
                            HapticFeedback.selectionClick();
                            setSheetState(() => count--);
                          }
                        },
                      ),
                      const SizedBox(width: 32),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Text(
                          count.toString(),
                          key: ValueKey(count),
                          style: AppTextStyles.largeNumber.copyWith(
                            fontSize: 48,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      _CountButton(
                        icon: Icons.add,
                        color: primary,
                        onTap: () {
                          if (count < 99) {
                            HapticFeedback.selectionClick();
                            setSheetState(() => count++);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'sigara',
                    style: AppTextStyles.body
                        .copyWith(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: AppSpacing.p32),
                  SizedBox(
                    width: double.infinity,
                    child: LunoButton(
                      text: 'Kaydet',
                      icon: Icons.check,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(sheetContext);
                        _quickAddCount(ref, count);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.p12),
                  TextButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: Text(
                      'İptal',
                      style: AppTextStyles.bodySemibold
                          .copyWith(color: Theme.of(context).hintColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void _quickAddCount(WidgetRef ref, int count) {
  final log = DailyLog(
    id: const Uuid().v4(),
    date: DateTime.now(),
    cravingIntensity: 0,
    hasSmoked: true,
    smokeCount: count,
    type: 'slip',
    moods: const [],
    context: const [],
    companions: const [],
  );
  ref.read(historyLogsProvider.notifier).addLog(log);
  ref.read(analyticsServiceProvider).logSmokeLogged(count: count);
}

class _CountButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CountButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
