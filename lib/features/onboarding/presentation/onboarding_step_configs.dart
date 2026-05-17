import '../../../core/theme/app_mascot_styles.dart';
import '../../../core/widgets/speech_bubble.dart';
import 'models/onboarding_step_config.dart';

/// Returns the step configuration for a given onboarding page index.
/// Dynamic bubble text for pages 3, 5, 7 uses [smokingYears],
/// [dailyCigarettes], and [packetPrice].
OnboardingStepConfig getOnboardingStepConfig(
  int page, {
  required int smokingYears,
  required int dailyCigarettes,
  required double packetPrice,
}) {
  switch (page) {
    case 0:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.center,
        mascotSize: AppMascotSizes.hero,
        bubbleText:
            "Hoş geldin! Ben Ciğerito. Seninle birlikte sigarayı tarihe gömmeye geldim.\n\nBaşarabilirsin! Birlikte planlayacağız, birlikte savaşacağız ve en sonunda sen kazanacaksın.",
        arrowDirection: BubbleArrowDirection.top,
        buttonLabel: "Başlayalım",
      );

    case 1:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.center,
        mascotSize: AppMascotSizes.hero,
        bubbleText:
            "Burada kimse seni yargılamaz.\n\nBu yolculuk senin iradenle ve doğru verilerle şekillenecek. Lütfen sorulara dürüst yanıt ver ki sana en iyi şekilde yardımcı olabileyim.",
        arrowDirection: BubbleArrowDirection.top,
        buttonLabel: "Devam",
      );

    case 2:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.topLeft,
        mascotSize: AppMascotSizes.medium,
        bubbleText: "Daha yolun başındayız ya da yolun sonuna gelmişiz...",
        arrowDirection: BubbleArrowDirection.left,
        buttonLabel: "Devam",
      );

    case 3:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.center,
        mascotSize: AppMascotSizes.hero,
        bubbleText:
            "$smokingYears yıl içmişsin ha? Merak etme, birlikte bırakmamız $smokingYears gün bile sürmeyecek!",
        arrowDirection: BubbleArrowDirection.top,
        buttonLabel: "Devam",
      );

    case 4:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.topLeft,
        mascotSize: AppMascotSizes.medium,
        bubbleText:
            "Dürüst ol dostum, her sigara ciğerimizde fırt hırsızı... Kaç tane içiyorsan öyle kulemizi kuralım!",
        arrowDirection: BubbleArrowDirection.left,
        buttonLabel: "Devam",
      );

    case 5:
      final totalCigs = smokingYears * 365 * dailyCigarettes;
      final totalHeight = totalCigs * 0.085;
      final String comparison;
      if (totalHeight < 324) {
        comparison = "Eyfel Kulesi";
      } else if (totalHeight < 828) {
        comparison = "Burj Khalifa";
      } else if (totalHeight < 8848) {
        comparison = "Everest Dağı";
      } else {
        comparison = "Uzay Sınırı";
      }
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.center,
        mascotSize: AppMascotSizes.hero,
        bubbleText:
            "$smokingYears yılda toplam $totalCigs tane sigara içmişsin. Vay be bu sigaraları üst üste koysak boyu $comparison'ni geçiyor!",
        arrowDirection: BubbleArrowDirection.top,
        buttonLabel: "Devam",
      );

    case 6:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.topLeft,
        mascotSize: AppMascotSizes.medium,
        bubbleText:
            "Bu parayı bana harcasan daha iyi olurdu. Mesela bana temiz hava alırdın.",
        arrowDirection: BubbleArrowDirection.left,
        buttonLabel: "Devam",
      );

    case 7:
      final dailyPacks = dailyCigarettes / 20.0;
      final monthly = (dailyPacks * packetPrice * 30).toInt();
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.center,
        mascotSize: AppMascotSizes.hero,
        bubbleText:
            "Sadece bir ayda harcadığın para yaklaşık ₺$monthly! Bu parayla neler yapabileceğini bir düşün...",
        arrowDirection: BubbleArrowDirection.top,
        buttonLabel: "Devam",
      );

    case 8:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.topLeft,
        mascotSize: AppMascotSizes.medium,
        bubbleText:
            "Hata yapmak insanidir, ama denememek Ciğerito'nun kalbini kırar.",
        arrowDirection: BubbleArrowDirection.left,
        buttonLabel: "Devam",
      );

    case 9:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.topLeft,
        mascotSize: AppMascotSizes.medium,
        bubbleText: "En azından bir neden seç. Ciğerito senin için savaşıyor!",
        arrowDirection: BubbleArrowDirection.left,
        buttonLabel: "Devam",
      );

    case 10:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.topLeft,
        mascotSize: AppMascotSizes.medium,
        bubbleText:
            "Tetikleyicini bil, düşmanını tanı. Ciğerito yanındayken stres yok!",
        arrowDirection: BubbleArrowDirection.left,
        buttonLabel: "Devam",
      );

    case 11:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.center,
        mascotSize: AppMascotSizes.large,
        bubbleText: "Sıkıcı ama önemli kısım. Son bir şey, söz.",
        arrowDirection: BubbleArrowDirection.top,
        buttonLabel: "Devam",
      );

    case 12:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.center,
        mascotSize: AppMascotSizes.medium,
        bubbleText: "İşte gerçekler... Ama birlikte değiştireceğiz, söz.",
        arrowDirection: BubbleArrowDirection.top,
        buttonLabel: "Devam",
      );

    default:
      return OnboardingStepConfig(
        mascotPosition: MascotPosition.center,
        mascotSize: AppMascotSizes.hero,
        bubbleText: "",
        arrowDirection: BubbleArrowDirection.top,
      );
  }
}
