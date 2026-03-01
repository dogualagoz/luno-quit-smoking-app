import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final String userName;
  final String subText;

  const MainHeader({super.key, required this.userName, required this.subText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Merhaba, x
            Text(
              "Merhaba, $userName 💨",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22.4,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),

            // altındaki yazı
            Text(
              subText,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),

        //Ay ikonu (tema değiştirici)
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.nightlight_outlined, size: 20),
        ),
      ],
    );
  }
}
