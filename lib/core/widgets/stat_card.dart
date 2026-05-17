import 'package:flutter/material.dart';
import 'burning_bar.dart';
import 'digit_counter.dart';
import 'luno_card.dart';

/// Dashboard stat card.
///
/// Two display modes:
/// 1. **Value mode**: large number + optional money decimal.
/// 2. **Counter mode**: flip-card digit boxes when [digits] is provided.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? moneyDecimal;
  final List<String>? digits;
  final String? subtext;
  final IconData icon;
  final Color? iconColor;
  final bool isMoney;
  final bool showBurnIndicator;
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
            if (isMoney) ...[
              const SizedBox(height: 4),
              BurningBar(isBurning: showBurnIndicator),
            ],
            const SizedBox(height: 4),
            if (subtext != null) _buildSubtext(colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

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

  Widget _buildValue(
    ColorScheme colorScheme,
    TextTheme textTheme,
    BuildContext context,
  ) {
    if (digits != null && digits!.isNotEmpty) {
      return DigitCounter(digits: digits!);
    }

    if (rawValue != null && isMoney) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: rawValue, end: rawValue!),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
        builder: (context, val, child) {
          final intVal = val.floor();
          final decVal =
              ((val - intVal) * 100).toInt().toString().padLeft(2, '0');
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
                    color: colorScheme.onSurface
                        .withValues(alpha: _currencyOpacity),
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
                  color:
                      Colors.pink.shade300.withValues(alpha: _decimalOpacity),
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
                color: colorScheme.onSurface.withValues(alpha: _currencyOpacity),
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
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ));
                final outAnimation = Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInCubic,
                ));
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
              color:
                  Colors.pink.shade300.withValues(alpha: _decimalOpacity),
              fontWeight: FontWeight.w700,
              fontSize: _decimalFontSize,
            ),
          ),
      ],
    );
  }

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
