import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/stat_card.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/summary_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Ekran kenarından boşluk

        child: Column(
          children: [
            const SizedBox(height: 50),
            SummaryBar(
              cigContent: "25.550",
              spentContent: "95.813",
              lossContent: "124",
            ),
            GridView.count(
              crossAxisCount: 2, // Yan yana 2 tane
              mainAxisSpacing: 12, // Dikey boşluk
              crossAxisSpacing: 12, // Yatay boşluk
              shrinkWrap: true,
              children: [
                StatCard(
                  label: "Harcanan Para",
                  value: "₺95.813",
                  icon: Icons.money,
                  subtext: "Bu parayla 2 tatil yapabilirdin",
                ),
                StatCard(
                  label: "Kayıp Zaman",
                  value: "12 Gün",
                  icon: Icons.timer,
                  subtext: "toplam süre",
                ),
                StatCard(
                  label: "Kayıp Zaman",
                  value: "12 Gün",
                  icon: Icons.timer,
                  subtext: "toplam süre",
                ),
                StatCard(
                  label: "Kayıp Zaman",
                  value: "12 Gün",
                  icon: Icons.timer,
                  subtext: "toplam süre",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
