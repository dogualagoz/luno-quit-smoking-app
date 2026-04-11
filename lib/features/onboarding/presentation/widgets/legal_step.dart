import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

class LegalStep extends StatefulWidget {
  final Function(bool) onValidStateChanged;

  const LegalStep({super.key, required this.onValidStateChanged});

  @override
  State<LegalStep> createState() => _LegalStepState();
}

class _LegalStepState extends State<LegalStep> {
  @override
  void initState() {
    super.initState();
    widget.onValidStateChanged(true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p20),
          const SizedBox(height: AppSpacing.p20),
          Center(
            child: SvgPicture.asset(
              AssetConstants.cigeritoDefault,
              height: AppMascotSizes.hero,
            ),
          ),
          const SizedBox(height: AppSpacing.p32),
          const SpeechBubble(
            text:
                "Burada kimse seni yargılamaz.\n\nBu yolculuk senin iradenle ve doğru verilerle şekillenecek. Lütfen sorulara dürüst yanıt ver ki sana en iyi şekilde yardımcı olabileyim.",
          ),
          const SizedBox(height: AppSpacing.p40),

        ],
      ),
    );
  }
}
