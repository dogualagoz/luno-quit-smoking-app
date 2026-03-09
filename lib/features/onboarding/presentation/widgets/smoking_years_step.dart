import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/speech_bubble.dart';

class SmokingYearsStep extends StatefulWidget {
  final int initialValue;
  final Function(int) onValueChanged;

  const SmokingYearsStep({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
  });

  @override
  State<SmokingYearsStep> createState() => _SmokingYearsStepState();
}

class _SmokingYearsStepState extends State<SmokingYearsStep> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _updateValue(int value) {
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
          const Row(
            children: [
              Expanded(
                child: SpeechBubble(
                  text: "Birkaç yıl olmuş... Hâlâ geç değil.",
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
            padding: AppSpacing.cardPaddingLarge,
            decoration: BoxDecoration(
              color: AppColors.lightCard,
              borderRadius: AppRadius.mainCard,
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Column(
              children: [
                Text(
                  "Ne kadar süredir sigara içiyorsun?",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.lightForeground.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: AppSpacing.p24),
                Text(
                  _currentValue.toString(),
                  style: AppTextStyles.largeNumber,
                ),
                Text(
                  "yıl",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.lightForeground.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: AppSpacing.p32),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.lightPrimary,
                    inactiveTrackColor: AppColors.lightPrimary.withOpacity(0.1),
                    thumbColor: Colors.white,
                    overlayColor: AppColors.lightPrimary.withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                      elevation: 4,
                    ),
                  ),
                  child: Slider(
                    value: _currentValue.toDouble(),
                    min: 1,
                    max: 40,
                    onChanged: (val) => _updateValue(val.round()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "1 yıl",
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.lightForeground.withOpacity(0.3),
                        ),
                      ),
                      Text(
                        "40 yıl",
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.lightForeground.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
          Wrap(
            spacing: 8,
            children: [1, 3, 5, 10].map((year) {
              final isSelected = _currentValue == year;
              return InkWell(
                onTap: () => _updateValue(year),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.lightPrimary.withOpacity(0.05)
                        : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.lightPrimary
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Text(
                    "$year yıl",
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.lightPrimary
                          : AppColors.lightForeground.withOpacity(0.7),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
