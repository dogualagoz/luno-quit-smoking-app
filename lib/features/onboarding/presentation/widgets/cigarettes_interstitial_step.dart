import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

/// Sigara İstatistikleri Interstitial - Sadece istatistik kartı
class CigarettesInterstitialStep extends StatefulWidget {
  final int smokingYears;
  final int dailyCigarettes;
  final Function(bool) onValidStateChanged;

  const CigarettesInterstitialStep({
    super.key,
    required this.smokingYears,
    required this.dailyCigarettes,
    required this.onValidStateChanged,
  });

  @override
  State<CigarettesInterstitialStep> createState() => _CigarettesInterstitialStepState();
}

class _CigarettesInterstitialStepState extends State<CigarettesInterstitialStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int totalCigarettes;
  late double totalHeightMeters;

  @override
  void initState() {
    super.initState();
    widget.onValidStateChanged(true);

    totalCigarettes = widget.smokingYears * 365 * widget.dailyCigarettes;
    totalHeightMeters = totalCigarettes * 0.085;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentTotal = (totalCigarettes * _animation.value).toInt();
        final currentHeight = totalHeightMeters * _animation.value;

        return Container(
          width: double.infinity,
          padding: AppSpacing.cardPaddingLarge,
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: AppRadius.mainCard,
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            children: [
              Text("Acı Tableau", style: AppTextStyles.cardHeader),
              const SizedBox(height: AppSpacing.p20),
              _buildStatRow("Toplam Sigara", "$currentTotal adet"),
              const Divider(height: 32),
              _buildStatRow(
                "Oluşan Kule Boyu",
                currentHeight > 1000
                    ? "${(currentHeight / 1000).toStringAsFixed(2)} km"
                    : "${currentHeight.toStringAsFixed(1)} m",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(color: AppColors.lightMutedForeground),
        ),
        Text(
          value,
          style: AppTextStyles.statValue.copyWith(color: AppColors.lightDestructive),
        ),
      ],
    );
  }
}
