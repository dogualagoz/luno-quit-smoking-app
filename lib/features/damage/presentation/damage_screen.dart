import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/features/damage/widgets/damage_card.dart';
import 'package:luno_quit_smoking_app/features/damage/widgets/total_damage_card.dart';
import 'package:luno_quit_smoking_app/features/damage/widgets/damage_header.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';

class DamageScreen extends ConsumerWidget {
  const DamageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    return stats.when(
      data: (statsData) {
        final organs = statsData.organDamages;
        final totalDays =
            statsData.recoveryYears * 365 +
            statsData.recoveryMonths * 30 +
            statsData.recoveryDays;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: AppSpacing.pageHorizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.p24),

                    // 1. Başlık Bölümü
                    const DamageHeader(),

                    const SizedBox(height: AppSpacing.p40),

                    // 2. Ciğerito (Mascot Placeholder)
                    const Center(child: Icon(Icons.monitor_heart, size: 80)),

                    const SizedBox(height: 12),

                    // 3. Konuşma Balonu
                    const SpeechBubble(
                      text:
                          "Acı gerçeklerle yüzleşme vakti. Hazır mısın? Ben değilim.",
                    ),

                    const SizedBox(height: AppSpacing.p32),

                    // 4. Genel Hasar Skoru (Dinamik)
                    TotalDamageCard(
                      damageScore: statsData.totalDamageScore,
                      subtext: "$totalDays günde birikmiş toplam hasar",
                    ),

                    const SizedBox(height: AppSpacing.p24),

                    // 5. Organ Kartları Listesi (Dinamik)
                    ...organs.map(
                      (organ) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.p16),
                        child: DamageCard(
                          title: organ.title,
                          description: organ.description,
                          quote: organ.quote,
                          damagePercentage: organ.damage,
                          icon: organ.icon,
                          gradientColors: organ.colors,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.p24),

                    // 6. Kaynak Referansı + Uyarı Metni (Footer)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.p24,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Bu veriler ortalama değerlere dayanır. Gerçek hasar kişiye göre değişebilir.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).hintColor.withValues(alpha: 0.6),
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Kaynaklar: ACS, WHO, U.S. Surgeon General, CDC",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).hintColor.withValues(alpha: 0.4),
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: AppSpacing.p96,
                    ), // Nav bar için boşluk
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
