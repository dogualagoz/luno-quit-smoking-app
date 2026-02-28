import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_theme.dart';

// temel bilgi kartlarımız
class LunoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? width;
  final double? height;
  final List<BoxShadow>? shadow;
  final Border? border;

  const LunoCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.width,
    this.height,
    this.shadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      padding: padding ?? AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color ?? cardTheme.color,
        borderRadius: AppRadius.mainCard,
        border: border ?? Border.all(color: colorScheme.outline, width: 1),
        boxShadow: shadow ?? AppTheme.shadowSm,
      ),
      child: child,
    );
  }
}
