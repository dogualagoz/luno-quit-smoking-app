import 'dart:math';
import 'package:flutter/material.dart';

/// Flip-card digit counter used by StatCard's timer display.
/// [digits] is the full list where the first (N-6) entries are day digits and
/// the last 6 are clock digits (HH:MM:SS).
class DigitCounter extends StatelessWidget {
  final List<String> digits;

  static const _clockDigitCount = 6;
  static const _separatorOpacity = 0.2;
  static const _labelOpacity = 0.4;

  const DigitCounter({super.key, required this.digits});

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
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: _labelOpacity),
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
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: _separatorOpacity),
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
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return AnimatedBuilder(
          animation: rotateAnim,
          builder: (context, _) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.003)
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
          border: isDark
              ? Border.all(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  width: 0.5,
                )
              : null,
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
            fontSize: isSmall ? 18 : 24,
            height: 1,
          ),
        ),
      ),
    );
  }
}
