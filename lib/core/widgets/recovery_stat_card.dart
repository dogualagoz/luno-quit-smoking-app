import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';
import 'luno_card.dart';

/// "İyileşme Süresi" kartı — vücudun tam iyileşme süresini
/// "3 yıl 8 ay 30 gün" formatında gösterir.
class RecoveryStatCard extends StatelessWidget {
  final QuitStats stats;

  const RecoveryStatCard({super.key, required this.stats});

  // — Tasarım Sabitleri —
  static const _cardPadding = EdgeInsets.all(2.0);
  static const _iconPadding = EdgeInsets.all(4.0);
  static const _iconSize = 24.0;
  static const _labelFontSize = 12.0;
  static const _valueFontSize = 22.0;
  static const _unitFontSize = 10.0;
  static const _subtextFontSize = 10.0;
  static const _indicatorDotSize = 8.0;
  static const _labelOpacity = 0.8;
  static const _subtextOpacity = 0.6;
  static const _actionOpacity = 0.3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LunoCard(
      child: Padding(
        padding: _cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colorScheme, textTheme),
            const SizedBox(height: 12),
            _buildProgress(context, colorScheme, textTheme),
            const Spacer(),
            _buildSubtext(colorScheme, textTheme),
            const SizedBox(height: 2),
            _buildAction(colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  /// Üst satır: ikon + etiket
  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Container(
          padding: _iconPadding,
          decoration: BoxDecoration(
            color: AppColors.lightChartSuccess.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.rocket_launch_outlined, // Healing yerine daha hazırlık odaklı bir ikon
            size: _iconSize,
            color: AppColors.lightChartSuccess,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            stats.prepLabel,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: _labelOpacity),
              fontSize: _labelFontSize,
            ),
          ),
        ),
      ],
    );
  }

  /// Hazırlık ilerlemesi ve yüzde gösterimi
  Widget _buildProgress(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    final percentage = (stats.prepPercentage * 100).toInt();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "%$percentage",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: _valueFontSize,
                color: AppColors.lightChartSuccess,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "hazır",
              style: textTheme.labelSmall?.copyWith(
                fontSize: _unitFontSize,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: stats.prepPercentage,
            backgroundColor: AppColors.lightChartSuccess.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lightChartSuccess),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  /// Alt açıklama: yeşil nokta + açıklama metni
  Widget _buildSubtext(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Container(
          width: _indicatorDotSize,
          height: _indicatorDotSize,
          decoration: const BoxDecoration(
            color: AppColors.lightChartSuccess,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            stats.prepSubtext,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: _subtextOpacity),
              fontSize: _subtextFontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Aksiyon metni: "Bırakmaya hazır mısın? — dokun"
  Widget _buildAction(ColorScheme colorScheme, TextTheme textTheme) {
    return Text(
      stats.prepAction,
      style: textTheme.labelSmall?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: _actionOpacity),
        fontSize: _subtextFontSize,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
