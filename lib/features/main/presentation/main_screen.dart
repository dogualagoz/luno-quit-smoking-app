import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/recovery_progress.dart';
import 'package:luno_quit_smoking_app/core/widgets/quote_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/stat_grid.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/main_header.dart';
import 'package:luno_quit_smoking_app/core/widgets/swipeable_damage_cards.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gerçek istatistikleri ve kullanıcı profilini dinle
    final stats = ref.watch(statsProvider);
    final profile = ref.watch(userProfileProvider);

    final userName = profile?.nickname ?? "Kullanıcı";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dinamik Başlık
                MainHeader(userName: userName, subText: stats.recoverySubtext),

                AppSpacing.sectionGapLarge,

                // Dinamik Maskot Bölümü
                Center(
                  child: Icon(
                    Icons.monitor_heart,
                    size: 80,
                    color: stats.type == QuitStatType.success
                        ? Colors.pink.shade200
                        : Colors.redAccent.withValues(alpha: 0.5),
                  ),
                ),

                const SizedBox(height: 8),

                // Konuşma Balonu
                SpeechBubble(text: stats.recoverySubtext),
                AppSpacing.sectionGap,

                // Organ Hasar Kartları
                const SwipeableDamageCards(),
                AppSpacing.sectionGap,

                // Dinamik İstatistik Grid'i
                StatGrid(stats: stats),
                AppSpacing.sectionGap,

                // Dinamik Toparlanma İlerlemesi
                RecoveryProgress(
                  progress: stats.progress,
                  progressText: "%${(stats.progress * 100).toInt()}",
                  statusText: stats.recoverySubtext,
                ),

                AppSpacing.sectionGap,

                // Motivasyon Kartı (Quote Card)
                const QuoteCard(
                  quote:
                      "Her sigara hayatından 11 dakika çalar. Ama sen zaten zamanı dumanla harcamayı seviyorsun, değil mi?",
                  author: "Ciğerito, senin akciğer dostun",
                ),

                const SizedBox(height: AppSpacing.p96),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
