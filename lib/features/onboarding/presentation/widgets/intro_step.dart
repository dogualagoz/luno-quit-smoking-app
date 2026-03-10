import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/speech_bubble.dart';

class IntroStep extends StatefulWidget {
  final Function(bool) onValidStateChanged;

  const IntroStep({super.key, required this.onValidStateChanged});

  @override
  State<IntroStep> createState() => _IntroStepState();
}

class _IntroStepState extends State<IntroStep> {
  @override
  void initState() {
    super.initState();
    widget.onValidStateChanged(true); // Intro sayfası her zaman geçerlidir
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p40),
          const Icon(
            Icons.monitor_heart_outlined,
            size: 80,
            color: AppColors.lightDestructive,
          ),
          const SizedBox(height: AppSpacing.p24),
          const SpeechBubble(
            text:
                "Hoş geldin! Ben Ciğerito. Seninle birlikte sigarayı tarihe gömmeye geldim.",
          ),
          const SizedBox(height: AppSpacing.p32),
          Text(
            "Başarabilirsin",
            style: AppTextStyles.header,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.p12),
          Text(
            "Birlikte planlayacağız, birlikte savaşacağız ve en sonunda sen kazanacaksın. Hazırsan başlayalım mı?",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.lightForeground.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          Text(
            "Tamamen ücretsiz · Reklamsız · Veriler cihazında",
            style: AppTextStyles.micro.copyWith(
              color: AppColors.lightMutedForeground,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
