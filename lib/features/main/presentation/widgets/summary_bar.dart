import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class SummaryBar extends StatelessWidget {
  final String cigContent;
  final String spentContent;
  final String lossContent;

  const SummaryBar({
    super.key,
    required this.cigContent,
    required this.spentContent,
    required this.lossContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LunoCard(
      color: colorScheme.primary.withValues(alpha: 0.2),
      shadow: const [],
      border: Border.all(
        color: colorScheme.primary.withValues(alpha: 0.2),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SummaryItem(
            value: cigContent,
            label: "sigara",
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          _divider(colorScheme),
          _SummaryItem(
            value: spentContent,
            label: "harcanan",
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          _divider(colorScheme),
          _SummaryItem(
            value: lossContent,
            label: "gün kayıp",
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

// İnce dikey çizgi
Widget _divider(ColorScheme colorScheme) {
  return Container(
    width: 1,
    height: 24,
    color: colorScheme.outline.withValues(alpha: 0.3),
  );
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  const _SummaryItem({
    required this.value,
    required this.label,
    required this.textTheme,
    required this.colorScheme,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme
                  .primary, // Değerler pembe/primary (görseldeki gibi)
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.bodySmall, // caption: 12.5px
          ),
        ],
      ),
    );
  }
}
