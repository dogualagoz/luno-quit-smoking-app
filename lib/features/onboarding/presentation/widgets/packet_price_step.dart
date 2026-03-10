import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/speech_bubble.dart';

class PacketPriceStep extends StatefulWidget {
  final double initialValue;
  final int dailyCigarettes;
  final Function(double) onValueChanged;

  const PacketPriceStep({
    super.key,
    required this.initialValue,
    required this.dailyCigarettes,
    required this.onValueChanged,
  });

  @override
  State<PacketPriceStep> createState() => _PacketPriceStepState();
}

class _PacketPriceStepState extends State<PacketPriceStep> {
  late double _currentPrice;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _currentPrice = widget.initialValue;
  }

  void _updateValue(double value) {
    setState(() => _currentPrice = value);
    widget.onValueChanged(value);
  }

  double get _monthlyExpense =>
      (_currentPrice / 20) * widget.dailyCigarettes * 30;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p20),
          const Row(
            children: [
              Expanded(
                child: SpeechBubble(
                  text:
                      "Bu parayı bana harcasan daha iyi olurdu. Mesela bana temiz hava alırdın.",
                ),
              ),
              SizedBox(width: AppSpacing.p12),
              Icon(
                Icons.monitor_heart_outlined,
                size: 40,
                color: AppColors.lightPrimary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p40),
          Container(
            width: double.infinity,
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.lightCard,
              borderRadius: AppRadius.mainCard,
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Column(
              children: [
                Text(
                  "Bir paket sigara kaç TL?",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.lightForeground.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: AppSpacing.p20),
                Text(
                  _currencyFormat.format(_currentPrice),
                  style: AppTextStyles.largeNumber,
                ),
                const SizedBox(height: AppSpacing.p24),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.lightPrimary,
                    inactiveTrackColor: AppColors.lightPrimary.withValues(alpha: 0.1),
                    thumbColor: Colors.white,
                    overlayColor: AppColors.lightPrimary.withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                      elevation: 4,
                    ),
                  ),
                  child: Slider(
                    value: _currentPrice,
                    min: 20,
                    max: 250,
                    onChanged: _updateValue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₺20",
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.lightForeground.withValues(alpha: 0.3),
                        ),
                      ),
                      Text(
                        "₺250",
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.lightForeground.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.p20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [50, 65, 75, 100].map((price) {
              final isSelected = _currentPrice.round() == price;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => _updateValue(price.toDouble()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.lightPrimary.withValues(alpha: 0.05)
                          : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.lightPrimary
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Text(
                      "₺$price",
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.lightPrimary
                            : AppColors.lightForeground.withValues(alpha: 0.7),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.p24),
          Container(
            width: double.infinity,
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.lightDestructive.withValues(alpha: 0.05),
              borderRadius: AppRadius.mainCard,
            ),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.lightForeground.withValues(alpha: 0.7),
                    ),
                    children: [
                      const TextSpan(text: "Aylık harcaman: "),
                      TextSpan(
                        text: _currencyFormat.format(_monthlyExpense),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Bu parayla her ay güzel bir restoranda yemek yiyebilirdin.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.lightForeground.withValues(alpha: 0.5),
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
