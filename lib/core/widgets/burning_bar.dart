import 'package:flutter/material.dart';

/// Animated progress bar shown on the money StatCard.
/// When [isBurning] is false it renders a solid full bar; when true it shows a
/// lava-flow gradient with a flickering flame icon at the tip.
class BurningBar extends StatefulWidget {
  final bool isBurning;

  const BurningBar({super.key, required this.isBurning});

  @override
  State<BurningBar> createState() => _BurningBarState();
}

class _BurningBarState extends State<BurningBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
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

        if (!widget.isBurning) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                height: 10,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          );
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
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
                        Colors.pink.shade300,
                        Color.lerp(Colors.pink.shade400,
                            Colors.orange.shade400, _controller.value)!,
                        Color.lerp(Colors.orange.shade400, Colors.deepOrange,
                            _controller.value)!,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: barWidth - 14,
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
