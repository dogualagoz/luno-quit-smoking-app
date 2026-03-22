import 'dart:math';
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

  /// Gerçek animasyonlu değer (opsiyonel)
  final double? rawValue;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.rawValue,
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
            if (isMoney) ...[const SizedBox(height: 4), const _BurningBar()],
            const SizedBox(height: 4),
            if (subtext != null) _buildSubtext(colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  /// Üst satır: ikon + etiket
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

    if (rawValue != null && isMoney) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: rawValue, end: rawValue!),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
        builder: (context, val, child) {
          final intVal = val.floor();
          final decVal = ((val - intVal) * 100).toInt().toString().padLeft(2, '0');
          final formattedInt = intVal.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]}.',
              );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Text(
                  "₺",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: _currencyOpacity),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formattedInt,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: _valueFontSize,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
              ),
              Text(
                ",$decVal",
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.pink.shade300.withValues(alpha: _decimalOpacity),
                  fontWeight: FontWeight.w700,
                  fontSize: _decimalFontSize,
                ),
              ),
            ],
          );
        },
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
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
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final isIncoming = child.key == ValueKey(value);

                final inAnimation = Tween<Offset>(
                  begin: const Offset(0.0, -1.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );

                final outAnimation = Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInCubic,
                  ),
                );

                return ClipRect(
                  child: SlideTransition(
                    position: isIncoming ? inAnimation : outAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
              child: Text(
                isMoney ? value.replaceAll("₺ ", "") : value,
                key: ValueKey(value),
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: _valueFontSize,
                  letterSpacing: -0.6,
                ),
              ),
            ),
          ),
        ),
        if (moneyDecimal != null && !isMoney)
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

/// Titreyen alev ikonu
class _FlickeringFlame extends StatefulWidget {
  final double size;
  const _FlickeringFlame({required this.size});

  @override
  State<_FlickeringFlame> createState() => _FlickeringFlameState();
}

class _FlickeringFlameState extends State<_FlickeringFlame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(
        Icons.local_fire_department_rounded,
        size: widget.size,
        color: Colors.orangeAccent.withValues(alpha: 0.6),
      ),
    );
  }
}

/// Para kartı için "Yanan Bar" - Sürekli akan bir fırın efekti
class _BurningBar extends StatefulWidget {
  const _BurningBar();

  @override
  State<_BurningBar> createState() => _BurningBarState();
}

class _BurningBarState extends State<_BurningBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth * 0.8;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // Arka plan rayı
                Container(
                  height: 10, // Biraz daha kalınlaştırdık ateşe oturması için
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                // Akan Akkor (Lava) Efekti
                Container(
                  height: 10,
                  width: barWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.pink.shade100.withValues(alpha: 0.3),
                        Colors.pink.shade400,
                        Colors.orange.shade400,
                        Colors.pink.shade400,
                        Colors.pink.shade100.withValues(alpha: 0.2),
                      ],
                      stops: [
                        0.0,
                        (_controller.value - 0.2).clamp(0.0, 1.0),
                        _controller.value,
                        (_controller.value + 0.2).clamp(0.0, 1.0),
                        1.0,
                      ],
                    ),
                  ),
                ),

                // Ucundaki Alev (Sıkıca bitişik)
                Positioned(
                  left: barWidth - 14 + (sin(_controller.value * 2 * pi) * 1.5),
                  top: -8,
                  child: const _FlickeringFlame(size: 26),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Sayaç kutucuklarını iki satırda gösteren iç widget.
class _DigitCounter extends StatelessWidget {
  final List<String> digits;

  static const _clockDigitCount = 6;
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
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < dayCount; i++)
                _digitBox(theme, digits[i], key: "day-$i-${digits[i]}"),
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
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              for (int i = dayCount; i < digits.length; i++) ...[
                if (i > dayCount && (i - dayCount) % 2 == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text(
                      ":",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: _separatorOpacity,
                        ),
                        fontSize: 10,
                      ),
                    ),
                  ),
                _digitBox(
                  theme,
                  digits[i],
                  isSmall: true,
                  key: "clock-$i-${digits[i]}",
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _digitBox(
    ThemeData theme,
    String char, {
    bool isSmall = false,
    required String key,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    
    // Tema uyumlu renkler
    final boxColor = isDark 
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
        : const Color(0xFFF5F0F2);
    
    final textColor = isDark 
        ? theme.colorScheme.onSurface 
        : theme.colorScheme.onSurface.withValues(alpha: 0.9);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) {
        final isIncoming = (child.key as ValueKey).value == key;

        final rotateAnim = Tween<double>(
          begin: isIncoming ? pi / 2 : 0,
          end: isIncoming ? 0 : -pi / 2,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return AnimatedBuilder(
          animation: rotateAnim,
          builder: (context, _) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.003) // Perspektif
                ..rotateX(rotateAnim.value),
              alignment: Alignment.center,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        );
      },
      child: Container(
        key: ValueKey(key),
        margin: const EdgeInsets.only(right: 3),
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 5 : 7,
          vertical: isSmall ? 3 : 4,
        ),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(6),
          border: isDark ? Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            width: 0.5,
          ) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          char,
          style: (isSmall
                  ? theme.textTheme.bodyMedium
                  : theme.textTheme.titleMedium)
              ?.copyWith(
                fontWeight: FontWeight.w800,
                color: textColor,
                fontSize: isSmall ? 18 : 24, // Sığması için hafif küçültüldü
                height: 1,
              ),
        ),
      ),
    );
  }
}
