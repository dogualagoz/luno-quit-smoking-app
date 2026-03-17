import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/constants/app_constants.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/cigerito_mascot.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';
import '../widgets/recovery_progress_card.dart';
import '../widgets/recovery_timeline_tile.dart';

class RecoveryScreen extends ConsumerWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: stats.when(
          data: (statsData) {
            // Bırakılan süreyi dakika cinsinden hesapla
            final quitDuration = Duration(
              days:
                  statsData.recoveryYears * 365 +
                  statsData.recoveryMonths * 30 +
                  statsData.recoveryDays,
              hours: 0,
            );

            final milestones = RecoveryMilestones.timeline;

            // Kaçıncı milestone'da olduğumuzu bul
            int activeIndex = -1;
            for (int i = 0; i < milestones.length; i++) {
              if (quitDuration >= milestones[i].duration) {
                activeIndex = i;
              } else {
                break;
              }
            }

            final completedCount = activeIndex + 1;
            final progress = milestones.isEmpty
                ? 0.0
                : completedCount / milestones.length;

            // Tasarımdaki özel sözler
            const Map<int, String> milestoneQuotes = {
              0: "Evet, 20 dakika yeter. Ama sen çok daha fazlasını hak ediyorsun.",
              1: "Kanın sonunda temiz oksijen görür. Uzun zamandır hasretmiş.",
              2: "Kalbin: 'İnanmıyorum ama tamam, bir şans daha.'",
              3: "Meğer yemekler bu kadar güzelmiş. Bilmiyordun, değil mi?",
              4: "Akciğerlerin: 'Sonunda balkon camını açtılar!'",
            };

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: AppSpacing.pageHorizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.p24),

                    // Header
                    Text(
                      "İyileşme Yolculuğu 🌱",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Bıraktığın andan itibaren vücudun toparlanmaya başlıyor. Yavaş ama kararlı.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.p32),

                    // Mascot Section
                    Center(
                      child: Column(
                        children: [
                          const CigeritoMascot(
                            mode: MascotMode.happy,
                            size: 100,
                          ),
                          const SizedBox(height: AppSpacing.p12),
                          const SpeechBubble(
                            text:
                                "Her geçen gün biraz daha iyi hissediyorum. Devam et lütfen!",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.p32),

                    // Progress Card
                    RecoveryProgressCard(
                      progress: progress,
                      completedMilestones: completedCount,
                      totalMilestones: milestones.length,
                    ),

                    const SizedBox(height: AppSpacing.p32),

                    // Timeline
                    ...milestones.asMap().entries.map((entry) {
                      final index = entry.key;
                      final milestone = entry.value;

                      MilestoneStatus status;
                      if (index < activeIndex) {
                        status = MilestoneStatus.completed;
                      } else if (index == activeIndex) {
                        status = MilestoneStatus.active;
                      } else {
                        status = MilestoneStatus.locked;
                      }

                      if (activeIndex == -1 && index == 0) {
                        status = MilestoneStatus.active;
                      }

                      return RecoveryTimelineTile(
                        title: milestone.title,
                        description: milestone.description,
                        durationText: _formatDuration(milestone.duration),
                        status: status,
                        quote: milestoneQuotes[index] ?? "",
                        isLast: index == milestones.length - 1,
                      );
                    }),

                    const SizedBox(height: AppSpacing.p40),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 60) return "${duration.inMinutes} dakika";
    if (duration.inHours < 24) return "${duration.inHours} saat";
    if (duration.inDays < 30) return "${duration.inDays} gün";
    if (duration.inDays < 365) return "${duration.inDays ~/ 30} ay";
    final years = duration.inDays ~/ 365;
    return "$years yıl";
  }
}
