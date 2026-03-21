import 'package:flutter/material.dart';

/// Ciğerito maskotu için canlılık katan animasyon (Yüzme + Nefes alma)
class MascotAnimation extends StatefulWidget {
  final Widget child;
  const MascotAnimation({super.key, required this.child});

  @override
  State<MascotAnimation> createState() => _MascotAnimationState();
}

class _MascotAnimationState extends State<MascotAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatingAnimation;
  late final Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    // 4 saniyelik döngü (nefes alıp verme hızı)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Aşağı yukarı nazik hareket (Floating)
    _floatingAnimation = Tween<double>(
      begin: -4.0,
      end: 4.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));

    // Çok hafif büyüme küçülme (Breathing)
    _breathingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03, // %3'lük çok hafif bir büyüme
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Transform.scale(
            scale: _breathingAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
