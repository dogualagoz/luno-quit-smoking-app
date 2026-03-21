import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/asset_constants.dart';

class DailyCigarettesStep extends StatefulWidget {
  final int initialValue;
  final Function(int) onValueChanged;
  final Function(bool) onValidStateChanged;

  const DailyCigarettesStep({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
    required this.onValidStateChanged,
  });

  @override
  State<DailyCigarettesStep> createState() => _DailyCigarettesStepState();
}

class _DailyCigarettesStepState extends State<DailyCigarettesStep> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    widget.onValidStateChanged(true);
  }

  void _updateValue(int value) {
    if (value < 1) return;
    setState(() => _currentValue = value);
    widget.onValueChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p20),
          Row(
            children: [
              SvgPicture.asset(
                AssetConstants.cigeritoDefault,
                height: AppMascotSizes.medium,
              ),
              const SizedBox(width: AppSpacing.p12),
              const Expanded(
                child: SpeechBubble(
                  text: "Ortalama bir Türk sigara içicisi. Klasik.",
                ),
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
                  "Günde kaç sigara içiyorsun?",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.lightForeground.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: AppSpacing.p20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIncrementButton(
                      Icons.remove,
                      () => _updateValue(_currentValue - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _currentValue.toString(),
                        style: AppTextStyles.largeNumber,
                      ),
                    ),
                    _buildIncrementButton(
                      Icons.add,
                      () => _updateValue(_currentValue + 1),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "adet / gün",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.lightForeground.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: AppSpacing.p24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [5, 10, 15, 20].map((count) {
                    final isSelected = _currentValue == count;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () => _updateValue(count),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
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
                            "$count adet",
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.lightPrimary
                                  : AppColors.lightForeground.withValues(
                                      alpha: 0.7,
                                    ),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
          Container(
            width: double.infinity,
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.05),
              borderRadius: AppRadius.mainCard,
            ),
            child: Text(
              _getDynamicMessage(),
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.lightForeground.withValues(alpha: 0.6),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  String _getDynamicMessage() {
    if (_currentValue >= 20) {
      return "Günde $_currentValue sigara = Yılda ${(_currentValue * 365 / 20).round()} paket. Tütüncün en iyi müşterisi sensin.";
    }
    return "Günde $_currentValue sigara = Her ${(1440 / _currentValue).round()} dakikada bir nefes alıyorsun. Sigaradan.";
  }

  Widget _buildIncrementButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.lightForeground, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
