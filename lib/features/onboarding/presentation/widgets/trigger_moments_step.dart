import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

class TriggerMomentsStep extends StatefulWidget {
  final String? initialValue;
  final Function(String) onValueChanged;
  final Function(bool) onValidStateChanged;

  const TriggerMomentsStep({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
    required this.onValidStateChanged,
  });

  @override
  State<TriggerMomentsStep> createState() => _TriggerMomentsStepState();
}

class _TriggerMomentsStepState extends State<TriggerMomentsStep> {
  String? _selectedValue;

  final List<Map<String, String>> _moments = [
    {'title': 'Sabah kahvesi', 'icon': '☕'},
    {'title': 'Stresli anlar', 'icon': '😫'},
    {'title': 'Yemek sonrası', 'icon': '🍽️'},
    {'title': 'Alkol ile', 'icon': '🍻'},
    {'title': 'Can sıkıntısı', 'icon': '🥱'},
    {'title': 'Mola anları', 'icon': '⏸️'},
    {'title': 'Gece vakti', 'icon': '🌙'},
    {'title': 'Diğer', 'icon': '✨'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    widget.onValidStateChanged(_selectedValue != null);
  }

  void _onSelect(String value) {
    setState(() => _selectedValue = value);
    widget.onValueChanged(value);
    widget.onValidStateChanged(true);
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
              const Expanded(
                child: SpeechBubble(
                  text:
                      "Tetikleyicini bil, düşmanını tanı. Ciğerito yanındayken stres yok!",
                ),
              ),
              const SizedBox(width: AppSpacing.p12),
              SvgPicture.asset(
                AssetConstants.cigeritoDefault,
                height: AppMascotSizes.medium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          ..._moments.map((moment) {
            final isSelected = _selectedValue == moment['title'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => _onSelect(moment['title']!),
                borderRadius: AppRadius.mainCard,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.lightPrimary.withValues(alpha: 0.05)
                        : AppColors.lightCard,
                    borderRadius: AppRadius.mainCard,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.lightPrimary
                          : AppColors.lightBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        moment['icon']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          moment['title']!,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isSelected
                                ? AppColors.lightPrimary
                                : AppColors.lightForeground,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.lightPrimary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.p40),
        ],
      ),
    );
  }
}
