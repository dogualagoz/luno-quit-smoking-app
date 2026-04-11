import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class FinalLegalStep extends StatefulWidget {
  final Function(bool) onValidStateChanged;

  const FinalLegalStep({super.key, required this.onValidStateChanged});

  @override
  State<FinalLegalStep> createState() => _FinalLegalStepState();
}

class _FinalLegalStepState extends State<FinalLegalStep> {
  @override
  void initState() {
    super.initState();
    widget.onValidStateChanged(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: AppSpacing.cardPaddingLarge,
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: AppRadius.mainCard,
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            children: [
              _buildLegalItem(
                Icons.local_hospital_outlined,
                "Tıbbi Tavsiye Değildir",
                "Bu uygulama tıbbi bir cihaz veya tedavi yöntemi değildir. Sigara bırakma sürecinde mutlaka bir sağlık profesyoneline danışın.",
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(height: 1),
              ),
              _buildLegalItem(
                Icons.lock_outline,
                "Veri Gizliliği",
                "Tüm verilerin yalnızca cihazında saklanır. Kişisel sağlık bilgilerini üçüncü taraflarla paylaşmayız.",
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(height: 1),
              ),
              _buildLegalItem(
                Icons.track_changes,
                "Amaç",
                "Bu uygulama sigara içmeyi teşvik etmez. Amacı farkındalık yaratmak ve bırakma sürecinizi desteklemektir.",
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.p24),
        Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.lightPrimary.withValues(alpha: 0.05),
            borderRadius: AppRadius.mainCard,
          ),
          child: Text(
            "Devam ederek Kullanım Koşullarını ve Gizlilik Politikasını kabul etmiş olursun.",
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.lightForeground.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.p20),
      ],
    );
  }

  Widget _buildLegalItem(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.lightPrimary, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.lightForeground.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
