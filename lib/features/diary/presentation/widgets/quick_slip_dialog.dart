import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:uuid/uuid.dart';

class QuickSlipDialog extends ConsumerStatefulWidget {
  const QuickSlipDialog({super.key});

  @override
  ConsumerState<QuickSlipDialog> createState() => _QuickSlipDialogState();
}

class _QuickSlipDialogState extends ConsumerState<QuickSlipDialog> {
  int _count = 1;

  void _submit() {
    final log = DailyLog(
      id: const Uuid().v4(),
      date: DateTime.now(),
      cravingIntensity: 0, // Kriz detayı yok, direkt içilmiş
      hasSmoked: true,
      smokeCount: _count,
      type: 'slip',
      location: null,
      moods: [],
      context: [],
      companions: [],
      note: 'Hızlı Kayıt',
    );

    // Önce dialog'u kapat, kayıt arkada devam etsin
    Navigator.of(context).pop();
    ref.read(historyLogsProvider.notifier).addLog(log);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smoking_rooms, color: primary, size: 32),
            ),
            const SizedBox(height: AppSpacing.p16),
            Text(
              "Kayıt Düşelim",
              style: AppTextStyles.cardHeader.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kaydetmek en büyük adımdır. Kaç tane oldu?",
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: AppSpacing.p24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCountButton(
                  icon: Icons.remove,
                  onTap: () {
                    if (_count > 1) setState(() => _count--);
                  },
                  primary: primary,
                ),
                const SizedBox(width: AppSpacing.p24),
                Text(
                  _count.toString(),
                  style: AppTextStyles.largeNumber.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(width: AppSpacing.p24),
                _buildCountButton(
                  icon: Icons.add,
                  onTap: () {
                    if (_count < 99) setState(() => _count++);
                  },
                  primary: primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.p32),
            SizedBox(
              width: double.infinity,
              child: LunoButton(
                text: "Kaydet",
                onPressed: _submit,
              ),
            ),
            const SizedBox(height: AppSpacing.p12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "İptal",
                  style: AppTextStyles.bodySemibold.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountButton({required IconData icon, required VoidCallback onTap, required Color primary}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: primary),
      ),
    );
  }
}
