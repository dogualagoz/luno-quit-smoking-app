import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/speech_bubble.dart';

class ReasonsStep extends StatefulWidget {
  final List<String> initialValues;
  final Function(List<String>) onValuesChanged;
  final Function(bool) onValidStateChanged;

  const ReasonsStep({
    super.key,
    required this.initialValues,
    required this.onValuesChanged,
    required this.onValidStateChanged,
  });

  @override
  State<ReasonsStep> createState() => _ReasonsStepState();
}

class _ReasonsStepState extends State<ReasonsStep> {
  late List<String> _selectedReasons;

  final List<Map<String, String>> _reasons = [
    {'title': 'Sağlık', 'icon': '❤️'},
    {'title': 'Ekonomi', 'icon': '💰'},
    {'title': 'Aile', 'icon': '👨‍👩‍👧‍👦'},
    {'title': 'Güzellik', 'icon': '✨'},
    {'title': 'Özgürlük', 'icon': '🕊️'},
    {'title': 'Koku', 'icon': '🧼'},
    {'title': 'Zindelik', 'icon': '🏃'},
    {'title': 'Daha uzun ömür', 'icon': '⏳'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedReasons = List.from(widget.initialValues);
    widget.onValidStateChanged(_selectedReasons.isNotEmpty);
  }

  void _toggleReason(String reason) {
    setState(() {
      if (_selectedReasons.contains(reason)) {
        _selectedReasons.remove(reason);
      } else {
        _selectedReasons.add(reason);
      }
    });
    widget.onValuesChanged(_selectedReasons);
    widget.onValidStateChanged(_selectedReasons.isNotEmpty);
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
              const Expanded(
                child: SpeechBubble(
                  text:
                      "En azından bir neden seç. Ciğerito senin için savaşıyor!",
                ),
              ),
              const SizedBox(width: AppSpacing.p12),
              Icon(
                Icons.monitor_heart_outlined,
                size: 40,
                color: _selectedReasons.isEmpty
                    ? AppColors.lightDestructive
                    : AppColors.lightChartSuccess,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _reasons.length,
              itemBuilder: (context, index) {
                final reason = _reasons[index];
                final isSelected = _selectedReasons.contains(reason['title']);
                return InkWell(
                  onTap: () => _toggleReason(reason['title']!),
                  borderRadius: AppRadius.mainCard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.lightChartSuccess.withOpacity(0.1)
                          : AppColors.lightCard,
                      borderRadius: AppRadius.mainCard,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.lightChartSuccess
                            : AppColors.lightBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          reason['icon']!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          reason['title']!,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.lightChartSuccess
                                : AppColors.lightForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
