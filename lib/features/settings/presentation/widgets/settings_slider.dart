import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class SettingsSlider extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double progress; // 0.0 - 1.0
  final Color activeColor;
  final Color? valueColor;
  final String? subtext;
  final IconData icon;
  final ValueChanged<double>? onChanged; // ✅ Yeni eklendi

  const SettingsSlider({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
    required this.activeColor,
    this.valueColor,
    this.subtext,
    required this.icon,
    this.onChanged, // ✅ Yeni eklendi
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiket ve değer satırı
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                const SizedBox(width: AppSpacing.p8),
                Text(label, style: AppTextStyles.bodySemibold),
              ],
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: valueColor ?? theme.colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: AppTextStyles.bodySemibold.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: unit,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.p12),

        // ✅ İnteraktif Kaydırıcı Alanı
        LayoutBuilder(
          builder: (context, constraints) {
            final double totalWidth = constraints.maxWidth;
            
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: (details) {
                _handleInteraction(totalWidth, details.localPosition.dx);
              },
              onTapDown: (details) {
                _handleInteraction(totalWidth, details.localPosition.dx);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  clipBehavior: Clip.none,
                  children: [
                    // Arka Plan (Muted Line)
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Aktif Dolgu
                    FractionallySizedBox(
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: activeColor.withValues(alpha: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // Tasarımdaki Thumb (Yuvarlak)
                    Positioned(
                      left: (totalWidth * progress.clamp(0.0, 1.0)) - 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: activeColor.withValues(alpha: 1),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // 3. Alt Bilgi Metni (Opsiyonel)
        if (subtext != null) ...[
          const SizedBox(height: AppSpacing.p8),
          Text(
            subtext!,
            style: AppTextStyles.hint.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ],
    );
  }

  void _handleInteraction(double totalWidth, double localDx) {
    if (onChanged == null || totalWidth <= 0) return;
    
    double newProgress = (localDx / totalWidth).clamp(0.0, 1.0);
    onChanged!(newProgress);
  }
}
