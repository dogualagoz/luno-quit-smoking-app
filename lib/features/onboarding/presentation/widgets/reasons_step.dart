import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';

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
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _reasons.map((reason) {
        final isSelected = _selectedReasons.contains(reason['title']);
        final width = (MediaQuery.of(context).size.width - (AppSpacing.p20 * 2) - 12) / 2;
        return InkWell(
          onTap: () => _toggleReason(reason['title']!),
          borderRadius: AppRadius.mainCard,
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.lightChartSuccess.withValues(alpha: 0.1)
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
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reason['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.lightChartSuccess
                          : AppColors.lightForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
