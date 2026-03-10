import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum MascotMode { normal, sad, happy, worried, sarcastic, proud }

class CigeritoMascot extends StatelessWidget {
  final MascotMode mode;
  final double size;

  const CigeritoMascot({
    super.key,
    this.mode = MascotMode.normal,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    // Şimdilik CustomPainter ile çizmek yerine ikon ve şekillerle temsil ediyoruz
    // İleride gerçek SVG veya Lottie eklenebilir.
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arka plan parıltısı (Proud/Happy modunda)
          if (mode == MascotMode.proud || mode == MascotMode.happy)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.mascotSparkle.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

          // Ana gövde (Akciğer formu)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLungLobe(isLeft: true),
              const SizedBox(width: 4),
              _buildCenterTube(),
              const SizedBox(width: 4),
              _buildLungLobe(isLeft: false),
            ],
          ),

          // Gözler ve Ağız (Yüz ifadesi)
          Positioned(top: size * 0.45, child: _buildFace()),

          // Ekstralar (Yara bandı, parıltı vb.)
          if (mode == MascotMode.proud)
            Positioned(
              right: size * 0.1,
              top: size * 0.2,
              child: const Text('✨', style: TextStyle(fontSize: 24)),
            ),
        ],
      ),
    );
  }

  Widget _buildLungLobe({required bool isLeft}) {
    return Container(
      width: size * 0.4,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: AppColors.mascotBody,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(50),
          topRight: const Radius.circular(50),
          bottomLeft: Radius.circular(isLeft ? 80 : 30),
          bottomRight: Radius.circular(isLeft ? 30 : 80),
        ),
        border: Border.all(color: AppColors.mascotOutline, width: 2),
      ),
      child: Stack(
        children: [
          // Yara bantları
          if (isLeft)
            Positioned(
              top: size * 0.1,
              left: size * 0.05,
              child: _buildBandaid(rotation: -0.3),
            ),
          if (!isLeft)
            Positioned(
              bottom: size * 0.1,
              right: size * 0.05,
              child: _buildBandaid(rotation: 0.3),
            ),

          // Allık (Blush)
          Positioned(
            top: size * 0.25,
            left: isLeft ? size * 0.15 : size * 0.05,
            child: Container(
              width: size * 0.1,
              height: size * 0.05,
              decoration: BoxDecoration(
                color: AppColors.mascotBlush.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterTube() {
    return Container(
      width: 4,
      height: size * 0.5,
      decoration: BoxDecoration(
        color: AppColors.mascotOutline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildBandaid({required double rotation}) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size * 0.15,
        height: size * 0.06,
        decoration: BoxDecoration(
          color: AppColors.mascotBandaid,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.brown.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFace() {
    switch (mode) {
      case MascotMode.sad:
        return const Column(
          children: [
            Row(
              children: [
                Text(
                  '^',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(width: 20),
                Text(
                  '^',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            Text('(', style: TextStyle(fontSize: 24)),
          ],
        );
      case MascotMode.happy:
      case MascotMode.proud:
        return Column(
          children: [
            const Row(
              children: [
                Text(
                  '>',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(width: 30),
                Text(
                  '<',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -5),
              child: const Text(
                '⌣',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      default:
        return const Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.mascotFace, radius: 3),
                SizedBox(width: 30),
                CircleAvatar(backgroundColor: AppColors.mascotFace, radius: 3),
              ],
            ),
            SizedBox(height: 5),
            Text(
              '⌣',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        );
    }
  }
}
