import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/recovery_progress.dart';
import 'package:luno_quit_smoking_app/core/widgets/quote_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/stat_grid.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/main_header.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/summary_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Ekran kenarından boşluk

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Başlık
                MainHeader(userName: "Doğukan", subText: "Bugün 25 tane içtin"),

                AppSpacing.sectionGapLarge,

                //Ciğer ikonu
                Center(
                  child: Icon(
                    Icons.monitor_heart,
                    size: 80,
                    color: Colors.pink.shade200,
                  ),
                ),

                const SizedBox(height: 8),

                // Konuşma balonu
                const SpeechBubble(
                  text:
                      "Bugün kaç tane içtin ? Saymayı bıraktım, kalbim kaldırmıyor.",
                ),
                AppSpacing.sectionGap,

                // Özet çubuğu
                SummaryBar(
                  cigContent: "25.550",
                  spentContent: "95.813",
                  lossContent: "124",
                ),
                AppSpacing.sectionGap,

                // İstatistikler (ilerde sayaç eklenecek)
                StatGrid(
                  spentMoney: "₺95.813",
                  lostTime: "12 Gün",
                  smokedCount: "25.550",
                  healthRisk: "%85",
                ),
                AppSpacing.sectionGap,

                // Toparlanma ilerlemesi (başka bir şeye değiştirilebilir)
                const RecoveryProgress(
                  progress: 0.8,
                  progressText: "%80",
                  statusText: "Akciğerlerin temizleniyor",
                ),

                AppSpacing.sectionGap,

                // MOTİVASYON KARTI (Quote Card)
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
