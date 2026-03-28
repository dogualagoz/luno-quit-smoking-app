import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

class TryingCountStep extends StatefulWidget {
  final String? initialValue;
  final Function(String) onValueChanged;
  final Function(bool) onValidStateChanged;

  const TryingCountStep({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
    required this.onValidStateChanged,
  });

  @override
  State<TryingCountStep> createState() => _TryingCountStepState();
}

class _TryingCountStepState extends State<TryingCountStep> {
  String? _selectedValue;

  final List<Map<String, String>> _options = [
    {
      'title': 'İlk denemem',
      'desc': 'Bu sefer gerçekten kararlıyım',
      'icon': '🌱',
    },
    {
      'title': '2-3 kez denedim',
      'desc': 'Daha önce savaştım, tecrübeliyim',
      'icon': '🔄',
    },
    {
      'title': 'Çok kez denedim',
      'desc': 'Defalarca denedim ama pes etmiyorum',
      'icon': '😤',
    },
    {
      'title': 'Hiç saymadım',
      'desc': 'Bırakma döngüsünde kayboldum',
      'icon': '🤕',
    },
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
              SvgPicture.asset(
                AssetConstants.cigeritoDefault,
                height: AppMascotSizes.medium,
              ),
              const SizedBox(width: AppSpacing.p12),
              const Expanded(
                child: SpeechBubble(
                  text:
                      "Hata yapmak insanidir, ama denememek Ciğerito'nun kalbini kırar.",
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p40),
          ..._options.map((opt) {
            final isSelected = _selectedValue == opt['title'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _onSelect(opt['title']!),
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
                        opt['icon']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              opt['title']!,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.lightPrimary
                                    : AppColors.lightForeground,
                              ),
                            ),
                            Text(
                              opt['desc']!,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.lightForeground.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.lightPrimary,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: AppSpacing.p40),
        ],
      ),
    );
  }
}
