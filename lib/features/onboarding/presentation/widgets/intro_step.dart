import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

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
    return SingleChildScrollView(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p20),
          Center(
              child: SvgPicture.asset(
                AssetConstants.cigeritoDefault,
                height: AppMascotSizes.hero,
              ),
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
          const SizedBox(height: AppSpacing.p40),
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
