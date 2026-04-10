import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

class MoneyInterstitialStep extends StatefulWidget {
  final int dailyCigarettes;
  final double packetPrice;
  final Function(bool) onValidStateChanged;

  const MoneyInterstitialStep({
    super.key,
    required this.dailyCigarettes,
    required this.packetPrice,
    required this.onValidStateChanged,
  });

  @override
  State<MoneyInterstitialStep> createState() => _MoneyInterstitialStepState();
}

class _MoneyInterstitialStepState extends State<MoneyInterstitialStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double monthlyExpense;

  @override
  void initState() {
    super.initState();
    widget.onValidStateChanged(true);

    final dailyPacks = widget.dailyCigarettes / 20.0;
    final dailyExpense = dailyPacks * widget.packetPrice;
    monthlyExpense = dailyExpense * 30;

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
          final currentMonthly = monthlyExpense * _animation.value;

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
                    "Sadece bir ayda harcadığın para yaklaşık ₺${currentMonthly.toInt()}! Bu parayla neler yapabileceğini bir düşün...",
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
                    Text("Bıraktığında Kazancın", style: AppTextStyles.cardHeader),
                    const SizedBox(height: AppSpacing.p20),
                    _buildSavingRow("1 Ayda", currentMonthly),
                    const Divider(height: 24),
                    _buildSavingRow("6 Ayda", currentMonthly * 6),
                    const Divider(height: 24),
                    _buildSavingRow("1 Yılda", currentMonthly * 12),
                    const Divider(height: 24),
                    _buildSavingRow("5 Yılda", currentMonthly * 60),
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

  Widget _buildSavingRow(String label, double value) {
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
          "₺${value.toInt()}",
          style: AppTextStyles.bodySemibold.copyWith(
            color: AppColors.lightPrimary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
