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
import '../../../diary/application/history_provider.dart';
import '../../../diary/data/models/daily_log.dart';
import 'quick_count_sheet.dart';

/// Bottom sheet that pops up when the user opens the dashboard and hasn't
/// logged anything for today yet. Three coarse-grained options: clean day,
/// quick slip count, or full crisis flow.
void showDailyCheckinSheet(BuildContext context, WidgetRef ref) {
  HapticFeedback.lightImpact();
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final bgColor =
      isDark ? theme.colorScheme.surface : AppColors.lightBackground;
  final successColor = context.chartSuccess;
  final primary = context.primary;
  final warningColor = context.chartWarning;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        bottom: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.p20,
            AppSpacing.p16,
            AppSpacing.p20,
            AppSpacing.p32,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.p20),
              Text(
                'Bugün nasıl gidiyor?',
                style: AppTextStyles.cardHeader.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.p8),
              Text(
                'Ciğerito merak ediyor...',
                style:
                    AppTextStyles.caption.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: AppSpacing.p24),
              Row(
                children: [
                  Expanded(
                    child: _CheckinOptionCard(
                      icon: Icons.shield_outlined,
                      title: 'Temiz Gün',
                      subtitle: 'İçmedim ✨',
                      color: successColor,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(sheetContext);
                        _saveCleanDay(ref);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.p12),
                  Expanded(
                    child: _CheckinOptionCard(
                      icon: Icons.smoking_rooms_outlined,
                      title: 'Birkaç Dal',
                      subtitle: 'Kaydet 📝',
                      color: primary,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(sheetContext);
                        showQuickCountSheet(context, ref);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.p12),
                  Expanded(
                    child: _CheckinOptionCard(
                      icon: Icons.thunderstorm_outlined,
                      title: 'Zor Gün',
                      subtitle: 'Detaylı ⚡',
                      color: warningColor,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(sheetContext);
                        context.push(AppRouter.craving);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.p20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: Text(
                    'Sonra Hatırlat',
                    style: AppTextStyles.bodySemibold
                        .copyWith(color: theme.hintColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _saveCleanDay(WidgetRef ref) {
  final log = DailyLog(
    id: const Uuid().v4(),
    date: DateTime.now(),
    cravingIntensity: 0,
    hasSmoked: false,
    smokeCount: 0,
    type: 'craving',
    moods: const [],
    context: const [],
    companions: const [],
    note: 'Temiz Gün ✨',
  );
  ref.read(historyLogsProvider.notifier).addLog(log);
  ref.read(analyticsServiceProvider).logCravingResisted(intensity: 0);
}

/// Single tappable option inside the daily check-in sheet — follows the
/// StatCard anatomy from tema.md.
class _CheckinOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CheckinOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CheckinOptionCard> createState() => _CheckinOptionCardState();
}

class _CheckinOptionCardState extends State<_CheckinOptionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: _pressed
                ? widget.color.withValues(alpha: 0.14)
                : widget.color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? widget.color.withValues(alpha: 0.35)
                  : widget.color.withValues(alpha: 0.18),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySemibold
                    .copyWith(fontSize: 13, height: 1.2),
              ),
              const SizedBox(height: 3),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: widget.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
