import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/speech_bubble.dart';

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

  final List<Map<String, String>> _options = [
    {
      'title': 'Stresli anlarda',
      'desc': 'İşte tartışma, trafik...',
      'icon': '😨',
    },
    {
      'title': 'Sosyal ortamlarda',
      'desc': 'Arkadaşlarla, çay-kahve...',
      'icon': '🍻',
    },
    {
      'title': 'Canım sıkıldığında',
      'desc': 'Boş zamanlar, bekleme...',
      'icon': '😑',
    },
    {'title': 'Sabah ilk iş', 'desc': 'Kahveyle veya uyanınca', 'icon': '☕'},
    {'title': 'Yemek sonrası', 'desc': 'Yemek bitince refleks', 'icon': '🍽️'},
    {
      'title': 'Araba kullanırken',
      'desc': 'Trafikte, uzun yolda',
      'icon': '🚗',
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
    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p20),
          const Row(
            children: [
              Icon(
                Icons.monitor_heart_outlined,
                size: 40,
                color: AppColors.lightPrimary,
              ),
              SizedBox(width: AppSpacing.p12),
              Expanded(
                child: SpeechBubble(
                  text:
                      "En çok ne zaman canın sigara ister? Düşmanını tanımak lazım...",
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          Expanded(
            child: ListView.builder(
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final opt = _options[index];
                final isSelected = _selectedValue == opt['title'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => _onSelect(opt['title']!),
                    borderRadius: AppRadius.mainCard,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.lightPrimary.withOpacity(0.05)
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
                                    color: AppColors.lightForeground
                                        .withOpacity(0.4),
                                  ),
                                ),
                              ],
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
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
