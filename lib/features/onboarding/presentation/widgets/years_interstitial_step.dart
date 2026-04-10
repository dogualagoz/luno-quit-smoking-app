import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

class YearsInterstitialStep extends StatefulWidget {
  final int smokingYears;
  final Function(bool) onValidStateChanged;

  const YearsInterstitialStep({
    super.key,
    required this.smokingYears,
    required this.onValidStateChanged,
  });

  @override
  State<YearsInterstitialStep> createState() => _YearsInterstitialStepState();
}

class _YearsInterstitialStepState extends State<YearsInterstitialStep> {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.p40),
          Center(
            child: SvgPicture.asset(
              AssetConstants.cigeritoDefault, // Veya 'default_cigerito.svg' yerine uyarsa
              height: AppMascotSizes.hero,
            ),
          ),
          const SizedBox(height: AppSpacing.p32),
          SpeechBubble(
            text:
                "${widget.smokingYears} yıl içmişsin ha? Merak etme, birlikte bırakmamız ${widget.smokingYears} gün bile sürmeyecek!",
          ),
        ],
      ),
    );
  }
}
