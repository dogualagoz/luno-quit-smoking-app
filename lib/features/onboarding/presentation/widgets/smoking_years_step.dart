import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

class SmokingYearsStep extends StatefulWidget {
  final int initialValue;
  final Function(int) onValueChanged;
  final Function(bool) onValidStateChanged;

  const SmokingYearsStep({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
    required this.onValidStateChanged,
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
    widget.onValidStateChanged(true);
  }

  void _updateValue(int value) {
    if (value < 1) return;
    setState(() => _currentValue = value);
    widget.onValueChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  text: "Daha yolun başındayız ya da yolun sonuna gelmişiz...",
                ),
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
                    color: AppColors.lightForeground.withValues(alpha: 0.6),
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
                    color: AppColors.lightForeground.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: AppSpacing.p32),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.lightPrimary,
                    inactiveTrackColor: AppColors.lightPrimary.withValues(
                      alpha: 0.1,
                    ),
                    thumbColor: Colors.white,
                    overlayColor: AppColors.lightPrimary.withValues(alpha: 0.2),
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
                          color: AppColors.lightForeground.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      Text(
                        "40 yıl",
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.lightForeground.withValues(
                            alpha: 0.3,
                          ),
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
            runSpacing: 8,
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
                    "$year yıl",
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
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.p40),
        ],
      ),
    );
  }
}
