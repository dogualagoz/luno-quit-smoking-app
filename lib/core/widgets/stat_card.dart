import 'package:flutter/material.dart';
import 'luno_card.dart';

/// Dashboard'taki tek bir istatistik bilgisini gösteren kart widget'ı.
///
/// İki farklı görünüm modunu destekler:
/// 1. **Değer modu**: Büyük bir rakam ve opsiyonel kuruş kısmı gösterir.
/// 2. **Sayaç modu**: [digits] sağlandığında kutucuklu bir sayaç gösterir.
class StatCard extends StatelessWidget {
  /// Kartın başlığı (Örn: "Harcanan Para")
  final String label;

  /// Gösterilecek ana değer (Örn: "₺ 68.438")
  final String value;

  /// Para birimi kartlarında kuruş kısmı (Örn: ",21")
  final String? moneyDecimal;

  /// Sayaç görünümü için rakam listesi (Gün + Saat:Dakika:Saniye)
  final List<String>? digits;

  /// Değerin altında gösterilen açıklama metni
  final String? subtext;

  /// Kart başlığının yanındaki ikon
  final IconData icon;

  /// İkon arka plan rengi
  final Color? iconColor;

  /// true ise ₺ sembolü ve kuruş kısmı gösterilir
  final bool isMoney;

  /// true ise ateş ikonu gösterilir (para kartları için)
  final bool showBurnIndicator;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.moneyDecimal,
    this.digits,
    this.subtext,
    this.iconColor,
    this.isMoney = false,
    this.showBurnIndicator = false,
  });

  // — Tasarım Sabitleri —
  static const _cardPadding = EdgeInsets.all(2.0);
  static const _iconPadding = EdgeInsets.all(4.0);
  static const _iconSize = 24.0;
  static const _labelFontSize = 12.0;
  static const _valueFontSize = 24.0;
  static const _decimalFontSize = 14.0;
  static const _subtextFontSize = 11.0;
  static const _burnIndicatorSize = 16.0;
  static const _iconBackgroundOpacity = 0.1;
  static const _labelOpacity = 0.8;
  static const _currencyOpacity = 0.5;
  static const _decimalOpacity = 0.5;
  static const _subtextOpacity = 0.6;

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
            _buildValue(colorScheme, textTheme, context),
            const SizedBox(height: 4),
            if (subtext != null) _buildSubtext(colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  /// Üst satır: ikon + etiket + opsiyonel ateş ikonu
  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    final effectiveColor = iconColor ?? colorScheme.primary;

    return Row(
      children: [
        Container(
          padding: _iconPadding,
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: _iconBackgroundOpacity),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: _iconSize, color: effectiveColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: _labelOpacity),
              fontSize: _labelFontSize,
            ),
          ),
        ),
        if (showBurnIndicator)
          Icon(
            Icons.local_fire_department_rounded,
            size: _burnIndicatorSize,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
      ],
    );
  }

  /// Değer bölümü: sayaç modunda kutucuklar, normal modda büyük rakam
  Widget _buildValue(
    ColorScheme colorScheme,
    TextTheme textTheme,
    BuildContext context,
  ) {
    if (digits != null && digits!.isNotEmpty) {
      return _DigitCounter(digits: digits!);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // ₺ sembolü (sadece para kartlarında)
        if (isMoney)
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Text(
              "₺",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(
                  alpha: _currencyOpacity,
                ),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        // Ana değer
        Flexible(
          child: Text(
            isMoney ? value.replaceAll("₺ ", "") : value,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: _valueFontSize,
              letterSpacing: -0.6,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Kuruş kısmı
        if (moneyDecimal != null)
          Text(
            moneyDecimal!,
            style: textTheme.labelLarge?.copyWith(
              color: Colors.pink.shade300.withValues(alpha: _decimalOpacity),
              fontWeight: FontWeight.w700,
              fontSize: _decimalFontSize,
            ),
          ),
      ],
    );
  }

  /// Alt açıklama metni
  Widget _buildSubtext(ColorScheme colorScheme, TextTheme textTheme) {
    return Text(
      subtext!,
      style: textTheme.labelSmall?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: _subtextOpacity),
        fontSize: _subtextFontSize,
        height: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Sayaç kutucuklarını iki satırda gösteren iç widget.
///
/// Üst satır: Gün rakamları + "gün" etiketi
/// Alt satır: Saat:Dakika:Saniye rakamları
class _DigitCounter extends StatelessWidget {
  final List<String> digits;

  /// Saat(2) + Dakika(2) + Saniye(2) = 6 hane
  static const _clockDigitCount = 6;
  static const _digitBoxRadius = 6.0;
  static const _backgroundOpacity = 0.3;
  static const _dayFontSize = 16.0;
  static const _clockFontSize = 12.0;
  static const _separatorOpacity = 0.2;
  static const _labelOpacity = 0.4;

  const _DigitCounter({required this.digits});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayCount = digits.length - _clockDigitCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gün satırı
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < dayCount; i++) _digitBox(theme, digits[i]),
            const SizedBox(width: 4),
            Text(
              "gün",
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: _labelOpacity,
                ),
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Saat:Dakika:Saniye satırı
        Row(
          children: [
            for (int i = dayCount; i < digits.length; i++) ...[
              if (i > dayCount && (i - dayCount) % 2 == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    ":",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: _separatorOpacity,
                      ),
                      fontSize: 12,
                    ),
                  ),
                ),
              _digitBox(theme, digits[i], isSmall: true),
            ],
          ],
        ),
      ],
    );
  }

  /// Tek bir rakam kutucuğu oluşturur.
  Widget _digitBox(ThemeData theme, String char, {bool isSmall = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 2),
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 4 : 6,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: _backgroundOpacity,
        ),
        borderRadius: BorderRadius.circular(_digitBoxRadius),
      ),
      child: Text(
        char,
        style:
            (isSmall ? theme.textTheme.bodyMedium : theme.textTheme.titleMedium)
                ?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  fontSize: isSmall ? _clockFontSize : _dayFontSize,
                ),
      ),
    );
  }
}
