import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class ProfileCard extends StatelessWidget {
  final String userName;
  final String registerDate;

  const ProfileCard({
    super.key,
    required this.userName,
    required this.registerDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LunoCard(
      child: Row(
        children: [
          // Avatar Kabı
          Container(
            width: 56, // Profil avatarı büyüklüğü (genelde sabit kalır)
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.iconContainer, // ✅ r12 sabitimiz
            ),
            child: Center(
              child: Icon(
                Icons.person_outline_rounded,
                color: theme.colorScheme.primary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.p16), // ✅ p16 sabiti
          // Kullanıcı Bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.cardHeader, // ✅ 17.6px/w700 sabitimiz
                ),
                const SizedBox(height: 4),
                Text(
                  'Sigara kullanıcısı • $registerDate tarihinden beri kayıt tutuyor',
                  style: AppTextStyles.caption.copyWith(
                    // ✅ 12.5px/w400 sabitimiz
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
