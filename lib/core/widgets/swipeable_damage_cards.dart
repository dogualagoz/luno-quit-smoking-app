import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/constants/damage_model.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_progress_bar.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class SwipeableDamageCards extends ConsumerStatefulWidget {
  final List<OrganDamageModel> organs;

  const SwipeableDamageCards({super.key, required this.organs});

  @override
  ConsumerState<SwipeableDamageCards> createState() =>
      _SwipeableDamageCardsState();
}

class _SwipeableDamageCardsState extends ConsumerState<SwipeableDamageCards>
    with SingleTickerProviderStateMixin {
  // Kaydırma miktarını takip eden değer
  double _dragX = 0.0;
  // Mevcut kartın indeksi
  int _currentIndex = 0;

  // Kartın ekrandan çıkma animasyonu
  late AnimationController _animController;
  late Animation<double> _animX;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animController.addListener(() {
      setState(() {
        _dragX = _animX.value;
      });
    });
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final organs = widget.organs;
        final count = organs.isNotEmpty ? organs.length : 1;
        setState(() {
          _currentIndex = (_currentIndex + 1) % count;
          _dragX = 0.0;
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    setState(() {
      _dragX += details.delta.dx;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    // Eşik değeri: ekranın %25'ini geçtiyse kartı fırlat
    final threshold = screenWidth * 0.25;

    if (_dragX.abs() > threshold) {
      // Kartı ekrandan çıkar
      final exitDirection = _dragX > 0 ? 1 : -1;
      _isAnimating = true;
      _animX =
          Tween<double>(
            begin: _dragX,
            end: exitDirection * screenWidth * 1.5,
          ).animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeInCubic),
          );
      _animController.forward(from: 0);
    } else {
      // Geri dön
      setState(() {
        _dragX = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Dinamik organ hasar verilerini al
    final organs = widget.organs;

    if (organs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık satırı
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.p12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Organ Hasar Durumu",
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "← kaydır →",
                style: textTheme.bodySmall?.copyWith(
                  color: theme.hintColor.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        // Kart Yığını
        SizedBox(
          height: 145,
          child: Stack(
            clipBehavior: Clip.none,
            children: _buildCardStack(screenWidth, theme, textTheme, organs),
          ),
        ),

        // Sayfa Göstergesi (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(organs.length, (index) {
            final isActive = index == _currentIndex;
            final organ = organs[_currentIndex];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 5,
              height: 5,
              decoration: BoxDecoration(
                color: isActive
                    ? organ.colors.first
                    : theme.hintColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  List<Widget> _buildCardStack(
    double screenWidth,
    ThemeData theme,
    TextTheme textTheme,
    List<OrganDamageModel> organs,
  ) {
    final List<Widget> cards = [];
    const visibleCards = 3;

    for (int i = visibleCards - 1; i >= 0; i--) {
      final dataIndex = (_currentIndex + i) % organs.length;
      final organ = organs[dataIndex];

      final isTop = i == 0;

      // Arkadaki kartların ölçek ve offset'i
      final scale = 1.0 - (i * 0.05);
      final yOffset = i * 10.0;

      // Üstteki kart sürüklenirken arkadakilerin büyümesi
      final dragProgress = isTop
          ? 0.0
          : (_dragX.abs() / screenWidth).clamp(0.0, 1.0);
      final dynamicScale = scale + (0.05 * dragProgress);
      final dynamicYOffset = yOffset - (10.0 * dragProgress);

      // Üstteki kartın sürükleme ve dönme efekti
      final xOffset = isTop ? _dragX : 0.0;
      final rotation = isTop ? _dragX / screenWidth * 0.3 : 0.0;

      cards.add(
        AnimatedPositioned(
          duration: isTop ? Duration.zero : const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          top: dynamicYOffset,
          left: 0,
          right: 0,
          child: GestureDetector(
            onPanUpdate: isTop ? _onPanUpdate : null,
            onPanEnd: isTop ? _onPanEnd : null,
            child: Transform.translate(
              offset: Offset(xOffset, 0),
              child: Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: dynamicScale,
                  child: Opacity(
                    opacity: isTop
                        ? 1.0
                        : (0.6 + (0.4 * dragProgress)).clamp(0.0, 1.0),
                    child: _buildMiniDamageCard(organ, theme, textTheme),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return cards;
  }

  Widget _buildMiniDamageCard(
    OrganDamageModel organ,
    ThemeData theme,
    TextTheme textTheme,
  ) {
    return LunoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İkon
          Container(
            padding: AppSpacing.iconPadding,
            decoration: BoxDecoration(
              color: organ.colors.first.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(organ.icon, color: organ.colors.first, size: 24),
          ),
          const SizedBox(width: AppSpacing.p12),

          // İçerik
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başlık + Yüzde
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      organ.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "%${(organ.damage * 100).toInt()}",
                      style: textTheme.titleSmall?.copyWith(
                        color: organ.colors.first,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Açıklama
                Text(
                  organ.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),

                // Progress Bar
                LunoProgressBar(
                  value: organ.damage,
                  height: 8,
                  gradientColors: organ.colors,
                  backgroundColor: organ.colors.first.withValues(alpha: 0.05),
                ),
                const SizedBox(height: 8),

                // Quote
                Text(
                  '"${organ.quote}"',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 11,
                    color: theme.hintColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
