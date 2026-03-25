import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';

class MainHeader extends ConsumerWidget {
  final String userName;
  final String subText;

  const MainHeader({super.key, required this.userName, required this.subText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final themeMode = ref.watch(themeModeProvider);
    
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // altındaki yazı
              Text(
                subText,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        //Ay ikonu (tema değiştirici)
        GestureDetector(
          onTap: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.nightlight_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
