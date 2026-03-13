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
            const SizedBox(height: 4),
            _buildDuration(textTheme),
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
            color: AppColors.lightChartPrimary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.healing_outlined,
            size: _iconSize,
            color: AppColors.lightChartPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            stats.recoveryLabel,
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

  /// Süre gösterimi: "3 yıl 8 ay 30 gün"
  Widget _buildDuration(TextTheme textTheme) {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _durationValue(textTheme, stats.recoveryYears.toString()),
        _durationUnit(textTheme, "yıl"),
        _durationValue(textTheme, stats.recoveryMonths.toString()),
        _durationUnit(textTheme, "ay"),
        _durationValue(textTheme, stats.recoveryDays.toString()),
        _durationUnit(textTheme, "gün"),
      ],
    );
  }

  /// Alt açıklama: turuncu nokta + açıklama metni
  Widget _buildSubtext(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Container(
          width: _indicatorDotSize,
          height: _indicatorDotSize,
          decoration: const BoxDecoration(
            color: AppColors.lightChartWarning,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            stats.recoverySubtext,
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

  /// Aksiyon metni: "🌱 bırakırsan ne olur? — dokun"
  Widget _buildAction(ColorScheme colorScheme, TextTheme textTheme) {
    return Text(
      stats.recoveryAction,
      style: textTheme.labelSmall?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: _actionOpacity),
        fontSize: _subtextFontSize,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // — Yardımcı Widget'lar —

  Widget _durationValue(TextTheme textTheme, String val) {
    return Text(
      val,
      style: textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w900,
        fontSize: _valueFontSize,
      ),
    );
  }

  Widget _durationUnit(TextTheme textTheme, String unit) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Text(
        unit,
        style: textTheme.labelSmall?.copyWith(
          fontSize: _unitFontSize,
          color: Colors.grey,
        ),
      ),
    );
  }
}
