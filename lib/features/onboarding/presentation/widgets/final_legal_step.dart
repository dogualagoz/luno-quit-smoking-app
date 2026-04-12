import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class FinalLegalStep extends StatefulWidget {
  final Function(bool) onValidStateChanged;

  const FinalLegalStep({super.key, required this.onValidStateChanged});

  @override
  State<FinalLegalStep> createState() => FinalLegalStepState();
}

class FinalLegalStepState extends State<FinalLegalStep> with SingleTickerProviderStateMixin {
  bool _isAgreed = false;
  bool _showError = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    widget.onValidStateChanged(false);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  /// Dışarıdan (OnboardingScreen) çağrılacak hata gösterme fonksiyonu
  void triggerError() {
    if (!_isAgreed) {
      setState(() => _showError = true);
      _shakeController.forward(from: 0.0);
      // Hata sesi veya haptic feedback buraya eklenebilir
    }
  }

  void _toggleAgreement() {
    setState(() {
      _isAgreed = !_isAgreed;
      if (_isAgreed) _showError = false; // İşaretleyince hata kaybolur
    });
    widget.onValidStateChanged(_isAgreed);
  }

  @override
  Widget build(BuildContext context) {
    // Hafif sallanma animasyonu için Tween
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 12.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });

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
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1),
              ),
              _buildLegalItem(
                Icons.lock_outline,
                "Veri Gizliliği",
                "Tüm verilerin yalnızca cihazında saklanır. Kişisel sağlık bilgilerini üçüncü taraflarla paylaşmayız.",
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
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
        const SizedBox(height: 12),
        
        // --- ONAY KUTUSU (Hata efektli) ---
        AnimatedBuilder(
          animation: offsetAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(offsetAnimation.value, 0),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _showError 
                  ? AppColors.lightDestructive.withValues(alpha: 0.05)
                  : (_isAgreed 
                      ? AppColors.lightPrimary.withValues(alpha: 0.08)
                      : AppColors.lightPrimary.withValues(alpha: 0.03)),
              borderRadius: AppRadius.mainCard,
              border: Border.all(
                color: _showError 
                    ? AppColors.lightDestructive // Hata varsa kırmızı
                    : (_isAgreed ? AppColors.lightPrimary : AppColors.lightBorder),
                width: (_isAgreed || _showError) ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isAgreed,
                    onChanged: (val) => _toggleAgreement(),
                    activeColor: AppColors.lightPrimary,
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: _showError ? AppColors.lightDestructive : AppColors.lightBorder, 
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.lightForeground.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: "Kullanım Koşullarını "),
                        TextSpan(
                          text: "ve ",
                          style: TextStyle(color: AppColors.lightForeground.withValues(alpha: 0.5)),
                        ),
                        const TextSpan(text: "Gizlilik Politikasını "),
                        const TextSpan(text: "okudum, kabul ediyorum."),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLegalItem(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.lightPrimary, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.label.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: AppTextStyles.micro.copyWith(
                  fontSize: 10,
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
