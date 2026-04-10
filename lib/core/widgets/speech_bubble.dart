import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';

class SpeechBubble extends StatefulWidget {
  final String text;
  final Duration typingSpeed;

  const SpeechBubble({
    super.key,
    required this.text,
    this.typingSpeed = const Duration(milliseconds: 30),
  });

  @override
  State<SpeechBubble> createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<SpeechBubble> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  @override
  void didUpdateWidget(SpeechBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.dispose();
      _setupAnimation();
    }
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.typingSpeed * widget.text.length,
    );
    _characterCount = StepTween(begin: 0, end: widget.text.length).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // ANA BALON
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppRadius.mascotBubble,
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.1),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Görünmez Katman: Balonun en baştan tam boyuta ulaşmasını sağlar
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.transparent, // Tamamen şeffaf
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Görünür Katman: Daktilo efekti
                AnimatedBuilder(
                  animation: _characterCount,
                  builder: (context, child) {
                    final int count = _characterCount.value.clamp(0, widget.text.length);
                    String visibleText = widget.text.substring(0, count);
                    return Text(
                      visibleText,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),

              ],
            ),

          ),

          // BALONUN OKU (Arrow)
          Positioned(
            top: -7,
            child: Transform.rotate(
              angle: 0.785,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    left: BorderSide(
                      color: colorScheme.primary.withOpacity(0.1),
                      width: 2,
                    ),
                    top: BorderSide(
                      color: colorScheme.primary.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
