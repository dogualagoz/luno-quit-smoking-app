import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/speech_bubble.dart';

class LegalStep extends StatefulWidget {
  final Function(bool) onValidStateChanged;

  const LegalStep({super.key, required this.onValidStateChanged});

  @override
  State<LegalStep> createState() => _LegalStepState();
}

class _LegalStepState extends State<LegalStep> {
  @override
  void initState() {
    super.initState();
    widget.onValidStateChanged(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p20),
          const Row(
            children: [
              Icon(
                Icons.monitor_heart_outlined,
                size: 40,
                color: AppColors.lightPrimary,
              ),
              SizedBox(width: AppSpacing.p12),
              Expanded(
                child: SpeechBubble(
                  text:
                      "Burada kimse seni yargılamaz. Sadece dürüst olmanı istiyorum.",
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p40),
          Container(
            padding: AppSpacing.cardPaddingLarge,
            decoration: BoxDecoration(
              color: AppColors.lightCard,
              borderRadius: AppRadius.mainCard,
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 48,
                  color: AppColors.lightPrimary,
                ),
                const SizedBox(height: AppSpacing.p20),
                Text("Ciddi ve dürüst", style: AppTextStyles.cardHeader),
                const SizedBox(height: AppSpacing.p12),
                Text(
                  "Bu yolculuk senin iradenle ve doğru verilerle şekillenecek. Lütfen sorulara en dürüst halinle yanıt ver.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.lightForeground.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
