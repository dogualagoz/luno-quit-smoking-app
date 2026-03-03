import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import '../widgets/settings_header.dart';
import '../widgets/profile_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: AppSpacing.pageHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.p24),

                // 1. Başlık
                SettingsHeader(),

                SizedBox(height: AppSpacing.p24),

                // 2. Profil Kartı
                ProfileCard(userName: "Duman", registerDate: "2024-06-23"),

                SizedBox(height: AppSpacing.p24),

                // 3. Sigara Bilgilerin (Bir sonraki adım)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
