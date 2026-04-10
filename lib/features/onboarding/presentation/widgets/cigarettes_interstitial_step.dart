import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

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
  State<CigarettesInterstitialStep> createState() =>
      _CigarettesInterstitialStepState();
}

class _CigarettesInterstitialStepState extends State<CigarettesInterstitialStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late int totalCigarettes;
  late double totalHeightMeters;
  late String comparisonText;

  @override
  void initState() {
    super.initState();
    widget.onValidStateChanged(true);

    totalCigarettes = widget.smokingYears * 365 * widget.dailyCigarettes;
    totalHeightMeters = totalCigarettes * 0.085; // Ortalama 8.5 cm

    if (totalHeightMeters < 324) {
      comparisonText = "Eyfel Kulesi";
    } else if (totalHeightMeters < 828) {
      comparisonText = "Burj Khalifa";
    } else if (totalHeightMeters < 8848) {
      comparisonText = "Everest Dağı";
    } else {
      comparisonText = "Uzay Sınırı";
    }

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
    return SingleChildScrollView(
      padding: AppSpacing.pageHorizontal,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final currentTotal = (totalCigarettes * _animation.value).toInt();
          final currentHeight = totalHeightMeters * _animation.value;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.p20),
              Center(
                child: SvgPicture.asset(
                  AssetConstants.cigeritoDefault,
                  height: AppMascotSizes.hero,
                ),
              ),
              const SizedBox(height: AppSpacing.p32),
              SpeechBubble(
                text:
                    "${widget.smokingYears} yılda toplam $currentTotal tane sigara içmişsin. Vay be bu sigaraları üst üste koysak boyu $comparisonText'ni geçiyor!",
              ),
              const SizedBox(height: AppSpacing.p32),
              Container(
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
              ),
              const SizedBox(height: AppSpacing.p40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.lightMutedForeground,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.statValue.copyWith(
            color: AppColors.lightDestructive,
          ),
        ),
      ],
    );
  }
}
