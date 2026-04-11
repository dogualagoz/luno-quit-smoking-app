import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_radius.dart';

/// Ok yönü sabitleri
enum BubbleArrowDirection {
  top,    // Ok yukarı bakar (Ciğerito üstte)
  bottom, // Ok aşağı bakar (Ciğerito altta)
  left,   // Ok sola bakar (Ciğerito solda)
  right,  // Ok sağa bakar (Ciğerito sağda)
}

class SpeechBubble extends StatefulWidget {
  final String text;
  final Duration typingSpeed;
  final BubbleArrowDirection arrowDirection;
  /// Daktilo efektini başlatmak için dışarıdan sinyal
  final bool startTyping;

  const SpeechBubble({
    super.key,
    required this.text,
    this.typingSpeed = const Duration(milliseconds: 30),
    this.arrowDirection = BubbleArrowDirection.top,
    this.startTyping = true,
  });

  @override
  State<SpeechBubble> createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<SpeechBubble> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    if (widget.startTyping) {
      _startWithDelay();
    }
  }

  @override
  void didUpdateWidget(SpeechBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.dispose();
      _hasStarted = false;
      _setupAnimation();
      if (widget.startTyping) {
        _startWithDelay();
      }
    }
    // Dışarıdan startTyping sinyali geldiğinde başlat
    if (!oldWidget.startTyping && widget.startTyping && !_hasStarted) {
      _startWithDelay();
    }
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.typingSpeed * widget.text.length,
    );
    _characterCount = StepTween(begin: 0, end: widget.text.length).animate(_controller);
  }

  void _startWithDelay() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !_hasStarted) {
        _hasStarted = true;
        _controller.forward();
      }
    });
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
    final borderColor = colorScheme.primary.withOpacity(0.1);
    const borderWidth = 2.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ANA BALON
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadius.mascotBubble,
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _characterCount,
            builder: (context, child) {
              final int count = _characterCount.value.clamp(0, widget.text.length);
              final String visiblePart = widget.text.substring(0, count);
              final String invisiblePart = widget.text.substring(count);

              return Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: visiblePart,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: invisiblePart,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.transparent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),

        // BALONUN OKU
        _buildArrow(colorScheme, borderColor, borderWidth),
      ],
    );
  }

  /// Ok yönüne göre doğru konumlandırma
  Widget _buildArrow(ColorScheme colorScheme, Color borderColor, double borderWidth) {
    switch (widget.arrowDirection) {
      case BubbleArrowDirection.top:
        return Positioned(
          top: -7,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.rotate(
              angle: 0.785, // 45 derece
              child: _arrowBox(colorScheme, borderColor, borderWidth, showLeft: true, showTop: true),
            ),
          ),
        );
      case BubbleArrowDirection.bottom:
        return Positioned(
          bottom: -7,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.rotate(
              angle: 0.785,
              child: _arrowBox(colorScheme, borderColor, borderWidth, showRight: true, showBottom: true),
            ),
          ),
        );
      case BubbleArrowDirection.left:
        return Positioned(
          left: -7,
          top: 24, // Sola bakan oklarda Ciğerito'nun ortasına hizalanması için sabit üst boşluk
          child: Transform.rotate(
            angle: 0.785,
            child: _arrowBox(colorScheme, borderColor, borderWidth, showLeft: true, showBottom: true),
          ),
        );
      case BubbleArrowDirection.right:
        return Positioned(
          right: -7,
          top: 24, // Sağa bakan oklarda Ciğerito'nun ortasına hizalanması için sabit üst boşluk
          child: Transform.rotate(
            angle: 0.785,
            child: _arrowBox(colorScheme, borderColor, borderWidth, showRight: true, showTop: true),
          ),
        );
    }
  }

  Widget _arrowBox(
    ColorScheme colorScheme,
    Color borderColor,
    double borderWidth, {
    bool showLeft = false,
    bool showTop = false,
    bool showRight = false,
    bool showBottom = false,
  }) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          left: showLeft ? BorderSide(color: borderColor, width: borderWidth) : BorderSide.none,
          top: showTop ? BorderSide(color: borderColor, width: borderWidth) : BorderSide.none,
          right: showRight ? BorderSide(color: borderColor, width: borderWidth) : BorderSide.none,
          bottom: showBottom ? BorderSide(color: borderColor, width: borderWidth) : BorderSide.none,
        ),
      ),
    );
  }
}
