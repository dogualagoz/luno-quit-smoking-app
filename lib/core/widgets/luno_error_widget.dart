import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/core/widgets/mascot_animation.dart';

class LunoErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final bool isFullPage;

  const LunoErrorWidget({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.isFullPage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final content = Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Üzgün/Default Maskot Animasyonu
          MascotAnimation(
            child: SvgPicture.asset(
              AssetConstants.cigeritoDefault, // İleride cigeritoSad ile değişebilir
              height: 120,
              // colorFilter: ColorFilter.mode(theme.colorScheme.error.withOpacity(0.5), BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
          
          // Başlık
          Text(
            title ?? "Küçük bir aksilik oldu!",
            textAlign: TextAlign.center,
            style: AppTextStyles.cardHeader.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.p12),
          
          // Açıklama
          Text(
            message ?? "Verilere ulaşırken bir sorun yaşadım. Ciğerlerim sönmeden bir daha denemeye ne dersin?",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: theme.hintColor,
            ),
          ),
          const SizedBox(height: AppSpacing.p32),
          
          // Tekrar Dene Butonu
          if (onRetry != null)
            LunoButton(
              text: "Tekrar Dene",
              onPressed: onRetry!,
              icon: Icons.refresh_rounded,
            ),
        ],
      ),
    );

    if (isFullPage) {
      return Scaffold(
        body: Center(child: content),
      );
    }

    return Center(child: content);
  }
}
