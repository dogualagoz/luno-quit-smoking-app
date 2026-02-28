import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'luno_card.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtext;
  final IconData icon;
  final Color? iconColor;
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.subtext,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LunoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Üst Satır: İkon ve Etiket (Hizalanmış)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Tam ortalı
            children: [
              Container(
                padding: AppSpacing.iconPadding, // 10px (tema.md)
                decoration: BoxDecoration(
                  color: (iconColor ?? colorScheme.primary).withOpacity(0.12),
                  borderRadius: AppRadius.iconContainer, // 12px (tema.md)
                ),
                child: Icon(
                  icon,
                  size: 20, // Tasarımdaki ikon boyutu
                  color: iconColor ?? colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: textTheme
                      .bodySmall, // caption: 12.5px / w400 (Zaten tema.md'den geliyor)
                ),
              ),
            ],
          ),

          // 2. Rakam ile Üst Kısım Arasındaki Boşluk (Section Gap: 20px)
          const SizedBox(height: 16),
          // 3. Büyük Rakam (Value)
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface, // Foreground rengi (koyu)
              fontWeight: FontWeight.w700, // Stat Değeri: w700 (tema.md)
            ),
          ),
          // 4. Rakam ile Alt Metin Arasındaki Boşluk (Element Gap: 8px veya 4px)
          const SizedBox(height: 4),
          // 5. Alt Metin (Subtext)
          if (subtext != null)
            Text(
              subtext!,
              style: textTheme
                  .labelSmall, // hint: 11.5px / w400 (Zaten tema.md'den geliyor)
            ),
        ],
      ),
    );
  }
}
