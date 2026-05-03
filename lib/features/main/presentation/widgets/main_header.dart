import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/features/diary/application/streak_provider.dart';

/// Ana sayfa başlık bileşeni.
/// Karşılama metni + seri (streak) göstergesi içerir.
/// Dark mode toggle buradan kaldırıldı — Ayarlar > Araçlar & Görünüm'den erişilebilir.
class MainHeader extends ConsumerWidget {
  final String userName;
  final String subText;

  const MainHeader({super.key, required this.userName, required this.subText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final streak = ref.watch(streakProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Merhaba, x
              Text(
                'Merhaba, $userName 💨',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 22.4,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Alt bilgi metni
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

        // Streak rozeti — sadece streak > 0 olduğunda göster
        if (streak > 0) _StreakBadge(streak: streak),
      ],
    );
  }
}

/// Streak sayısını gösteren rozet.
/// Tema renklerini kullanır, animasyonla belirir.
class _StreakBadge extends StatelessWidget {
  final int streak;

  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(streak),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // Tema primary rengin açık tonu — tema.md secondary/accent benzeri
          color: primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primary.withValues(alpha: 0.25),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Alev ikonu
            Text(
              '🔥',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$streak',
                  style: AppTextStyles.bodySemibold.copyWith(
                    color: primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  'günlük seri',
                  style: AppTextStyles.micro.copyWith(
                    color: primary.withValues(alpha: 0.75),
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
