import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_mascot_styles.dart';
import '../../../core/widgets/luno_button.dart';
import '../../../core/widgets/luno_progress_bar.dart';
import '../../../core/widgets/speech_bubble.dart';
import 'models/onboarding_step_config.dart';
import 'widgets/smoking_years_step.dart';
import 'widgets/daily_cigarettes_step.dart';
import 'widgets/packet_price_step.dart';
import 'widgets/trying_count_step.dart';
import 'widgets/reasons_step.dart';
import 'widgets/trigger_moments_step.dart';
import 'widgets/final_legal_step.dart';
import 'widgets/summary_step.dart';
import 'widgets/cigarettes_interstitial_step.dart';
import 'widgets/money_interstitial_step.dart';
import '../application/onboarding_provider.dart';
import '../../../core/constants/app_constants.dart';

/// Onboarding geçiş durumları
enum _TransitionPhase {
  idle,           // Animasyon yok, herşey stabil
  bubbleShrink,   // Balon küçülüyor
  contentOut,     // İçerik sola kayıyor
  mascotMove,     // Ciğerito yeni pozisyonuna gidiyor
  contentIn,      // Yeni içerik sağdan geliyor
  bubbleGrow,     // Yeni balon büyüyor
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  // --- Sayfa durumu ---
  int _currentPage = 0;
  final int _totalSteps = 13;

  // --- Geçici Form Verileri ---
  int _dailyCigarettes = 20;
  int _smokingYears = 5;
  double _packetPrice = 75.0;
  String? _tryingCount;
  List<String> _selectedReasons = [];
  String? _triggerMoment;
  String _userName = "";

  // --- Buton durumu ---
  bool _isButtonEnabled = true;
  String _buttonLabel = "Başlayalım";

  // --- Animasyon kontrollleri ---
  late AnimationController _bubbleScaleController;
  late AnimationController _contentSlideController;
  late Animation<double> _bubbleScale;
  late Animation<Offset> _contentOffset;

  // --- GlobalKey for Legal Step ---
  final GlobalKey<FinalLegalStepState> _legalStepKey = GlobalKey<FinalLegalStepState>();

  // --- Geçiş durumu ---
  _TransitionPhase _phase = _TransitionPhase.idle;
  bool _showBubble = true;
  bool _showContent = true;
  bool _startTyping = false;

  // --- Ciğerito pozisyon değerleri (AnimatedPositioned için) ---
  double _mascotTop = 0;
  double _mascotLeft = 0;
  double _mascotSize = AppMascotSizes.hero;
  bool _mascotCentered = true;

  @override
  void initState() {
    super.initState();

    // Balon ölçek animasyonu
    _bubbleScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bubbleScale = CurvedAnimation(
      parent: _bubbleScaleController,
      curve: Curves.easeOutBack,
    );
    _bubbleScaleController.value = 1.0;

    // İçerik kayma animasyonu
    _contentSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    // İlk değeri sıfırlıyoruz, tween'i geçiş anında belirleyeceğiz
    _contentOffset = AlwaysStoppedAnimation(Offset.zero);
    _contentSlideController.value = 1.0;

    // İlk sayfa yüklendiğinde animasyonları başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFirstPage();
    });
  }

  void _initializeFirstPage() {
    final config = _getStepConfig(_currentPage);
    _updateMascotPosition(config, animate: false);
    setState(() {
      _showBubble = true;
      _showContent = true;
      _startTyping = true;
    });
    _bubbleScaleController.forward();
  }

  @override
  void dispose() {
    _bubbleScaleController.dispose();
    _contentSlideController.dispose();
    super.dispose();
  }

  // --- Buton durumu güncelleme ---
  void _updateButtonState({required bool isEnabled, String? label}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isButtonEnabled = isEnabled;
          if (label != null) _buttonLabel = label;
        });
      }
    });
  }

  // --- Ciğerito pozisyonunu hesapla ---
  void _updateMascotPosition(OnboardingStepConfig config, {bool animate = true}) {
    if (!mounted) return;
    setState(() {
      _mascotSize = config.mascotSize;
      _mascotCentered = config.mascotPosition == MascotPosition.center;
      if (_mascotCentered) {
        _mascotTop = 20;
        _mascotLeft = 0; // Ortada olacak, merkez hesaplaması build'de
      } else {
        _mascotTop = 10;
        _mascotLeft = 16;
      }
    });
  }

  // --- SAYFA GEÇİŞ ANİMASYONU (Duolingo tarzı) ---
  Future<void> _transitionToPage(int newPage) async {
    if (_phase != _TransitionPhase.idle) return;

    // 1️⃣ Balon küçülüyor
    setState(() => _phase = _TransitionPhase.bubbleShrink);
    await _bubbleScaleController.reverse();

    // 2️⃣ Mevcut içerik sola kayarak çıkıyor
    setState(() {
      _phase = _TransitionPhase.contentOut;
      _startTyping = false;
      _contentOffset = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.2, 0),
      ).animate(CurvedAnimation(
        parent: _contentSlideController,
        curve: Curves.easeInOutCubic,
      ));
    });
    _contentSlideController.value = 0.0;
    await _contentSlideController.forward();

    // 3️⃣ Sayfa değişiyor + Ciğerito yeni pozisyona gidiyor
    final newConfig = _getStepConfig(newPage);
    setState(() {
      _phase = _TransitionPhase.mascotMove;
      _currentPage = newPage;
      _showContent = false;
    });
    _updateMascotPosition(newConfig);
    await Future.delayed(const Duration(milliseconds: 400));

    // 4️⃣ Yeni içerik sağdan sola gelerek giriyor
    setState(() {
      _phase = _TransitionPhase.contentIn;
      _showContent = true;
      _contentOffset = Tween<Offset>(
        begin: const Offset(1.2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _contentSlideController,
        curve: Curves.easeInOutCubic,
      ));
    });
    _contentSlideController.value = 0.0;
    await _contentSlideController.forward();

    // 5️⃣ Yeni balon büyüyor
    setState(() => _phase = _TransitionPhase.bubbleGrow);
    await _bubbleScaleController.forward();

    // 6️⃣ Daktilo efekti başlıyor
    setState(() {
      _phase = _TransitionPhase.idle;
      _startTyping = true;
    });
  }

  // --- GERİ GİTME ANİMASYONU ---
  Future<void> _transitionBack() async {
    if (_phase != _TransitionPhase.idle || _currentPage <= 0) return;

    setState(() => _phase = _TransitionPhase.bubbleShrink);
    await _bubbleScaleController.reverse();

    // 2️⃣ Mevcut içerik sağa kayarak çıkıyor
    setState(() {
      _phase = _TransitionPhase.contentOut;
      _startTyping = false;
      _contentOffset = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1.2, 0),
      ).animate(CurvedAnimation(
        parent: _contentSlideController,
        curve: Curves.easeInOutCubic,
      ));
    });
    _contentSlideController.value = 0.0;
    await _contentSlideController.forward();

    final newPage = _currentPage - 1;
    final newConfig = _getStepConfig(newPage);
    setState(() {
      _phase = _TransitionPhase.mascotMove;
      _currentPage = newPage;
      _showContent = false;
    });
    _updateMascotPosition(newConfig);
    await Future.delayed(const Duration(milliseconds: 400));

    // 4️⃣ Yeni içerik soldan sağa gelerek giriyor
    setState(() {
      _phase = _TransitionPhase.contentIn;
      _showContent = true;
      _contentOffset = Tween<Offset>(
        begin: const Offset(-1.2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _contentSlideController,
        curve: Curves.easeInOutCubic,
      ));
    });
    _contentSlideController.value = 0.0;
    await _contentSlideController.forward();

    setState(() => _phase = _TransitionPhase.bubbleGrow);
    await _bubbleScaleController.forward();

    setState(() {
      _phase = _TransitionPhase.idle;
      _startTyping = true;
    });
  }

  // --- İleri/Geri navigasyon ---
  void _nextPage() {
    // Özel durum: Yasal onay sayfasındayız ama kullanıcı işaretlememiş
    if (_currentPage == 11 && !_isButtonEnabled) {
      _legalStepKey.currentState?.triggerError();
      return;
    }

    if (_currentPage < _totalSteps - 1) {
      _transitionToPage(_currentPage + 1);
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    _transitionBack();
  }

  Future<void> _finishOnboarding() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding(
      nickname: _userName.trim().isEmpty ? AppMockData.userName : _userName,
      dailyCigarettes: _dailyCigarettes,
      smokingYears: _smokingYears,
      packPrice: _packetPrice,
      tryingToQuitCount: _tryingCount,
      quitReasons: _selectedReasons,
      triggerMoment: _triggerMoment,
      quitDate: DateTime.now(),
    );
    if (mounted) {
      context.go('/auth-selection', extra: _userName);
    }
  }

  // ═══════════════════════════════════════════
  //  STEP KONFİGÜRASYON TANIMLARI
  // ═══════════════════════════════════════════
  OnboardingStepConfig _getStepConfig(int page) {
    switch (page) {
      // 0: Intro - Sadece yorum
      case 0:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.center,
          mascotSize: AppMascotSizes.hero,
          bubbleText: "Hoş geldin! Ben Ciğerito. Seninle birlikte sigarayı tarihe gömmeye geldim.\n\nBaşarabilirsin! Birlikte planlayacağız, birlikte savaşacağız ve en sonunda sen kazanacaksın.",
          arrowDirection: BubbleArrowDirection.top,
          buttonLabel: "Başlayalım",
        );

      // 1: Legal - Sadece yorum
      case 1:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.center,
          mascotSize: AppMascotSizes.hero,
          bubbleText: "Burada kimse seni yargılamaz.\n\nBu yolculuk senin iradenle ve doğru verilerle şekillenecek. Lütfen sorulara dürüst yanıt ver ki sana en iyi şekilde yardımcı olabileyim.",
          arrowDirection: BubbleArrowDirection.top,
          buttonLabel: "Devam",
        );

      // 2: Kaç yıldır içiyorsun? - Soru
      case 2:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.topLeft,
          mascotSize: AppMascotSizes.medium,
          bubbleText: "Daha yolun başındayız ya da yolun sonuna gelmişiz...",
          arrowDirection: BubbleArrowDirection.left,
          buttonLabel: "Devam",
        );

      // 3: Yıl Interstitial - Yorum
      case 3:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.center,
          mascotSize: AppMascotSizes.hero,
          bubbleText: "$_smokingYears yıl içmişsin ha? Merak etme, birlikte bırakmamız $_smokingYears gün bile sürmeyecek!",
          arrowDirection: BubbleArrowDirection.top,
          buttonLabel: "Devam",
        );

      // 4: Günde kaç sigara? - Soru
      case 4:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.topLeft,
          mascotSize: AppMascotSizes.medium,
          bubbleText: "Dürüst ol dostum, her sigara ciğerimizde fırt hırsızı... Kaç tane içiyorsan öyle kulemizi kuralım!",
          arrowDirection: BubbleArrowDirection.left,
          buttonLabel: "Devam",
        );

      // 5: Sigara Interstitial - Yorum + İstatistik kartı
      case 5:
        final totalCigs = _smokingYears * 365 * _dailyCigarettes;
        final totalHeight = totalCigs * 0.085;
        String comparison;
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
          bubbleText: "$_smokingYears yılda toplam $totalCigs tane sigara içmişsin. Vay be bu sigaraları üst üste koysak boyu $comparison'ni geçiyor!",
          arrowDirection: BubbleArrowDirection.top,
          buttonLabel: "Devam",
        );

      // 6: Paket fiyatı - Soru
      case 6:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.topLeft,
          mascotSize: AppMascotSizes.medium,
          bubbleText: "Bu parayı bana harcasan daha iyi olurdu. Mesela bana temiz hava alırdın.",
          arrowDirection: BubbleArrowDirection.left,
          buttonLabel: "Devam",
        );

      // 7: Para Interstitial - Yorum + Kazanç kartı
      case 7:
        final dailyPacks = _dailyCigarettes / 20.0;
        final monthly = (dailyPacks * _packetPrice * 30).toInt();
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.center,
          mascotSize: AppMascotSizes.hero,
          bubbleText: "Sadece bir ayda harcadığın para yaklaşık ₺$monthly! Bu parayla neler yapabileceğini bir düşün...",
          arrowDirection: BubbleArrowDirection.top,
          buttonLabel: "Devam",
        );

      // 8: Kaç kez denedin? - Soru
      case 8:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.topLeft,
          mascotSize: AppMascotSizes.medium,
          bubbleText: "Hata yapmak insanidir, ama denememek Ciğerito'nun kalbini kırar.",
          arrowDirection: BubbleArrowDirection.left,
          buttonLabel: "Devam",
        );

      // 9: Nedenler - Soru
      case 9:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.topLeft,
          mascotSize: AppMascotSizes.medium,
          bubbleText: "En azından bir neden seç. Ciğerito senin için savaşıyor!",
          arrowDirection: BubbleArrowDirection.left,
          buttonLabel: "Devam",
        );

      // 10: Tetikleyiciler - Soru
      case 10:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.topLeft,
          mascotSize: AppMascotSizes.medium,
          bubbleText: "Tetikleyicini bil, düşmanını tanı. Ciğerito yanındayken stres yok!",
          arrowDirection: BubbleArrowDirection.left,
          buttonLabel: "Devam",
        );

      // 11: Son yasal uyarı - Yorum + Kartlar
      case 11:
        return OnboardingStepConfig(
          mascotPosition: MascotPosition.center,
          mascotSize: AppMascotSizes.large,
          bubbleText: "Sıkıcı ama önemli kısım. Son bir şey, söz.",
          arrowDirection: BubbleArrowDirection.top,
          buttonLabel: "Devam",
        );

      // 12: Özet + İsim - Yorum + Kartlar
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

  // --- İçerik widget'ını getir (Ciğerito ve SpeechBubble HARİÇ) ---
  Widget? _getContentWidget(int page) {
    switch (page) {
      case 0: return null; // Intro: sadece balon
      case 1: return null; // Legal: sadece balon
      case 2: return SmokingYearsStep(
        initialValue: _smokingYears,
        onValueChanged: (val) => _smokingYears = val,
        onValidStateChanged: (isValid) => _updateButtonState(isEnabled: isValid),
      );
      case 3: return null; // Yıl interstitial: sadece balon
      case 4: return DailyCigarettesStep(
        initialValue: _dailyCigarettes,
        onValueChanged: (val) => _dailyCigarettes = val,
        onValidStateChanged: (isValid) => _updateButtonState(isEnabled: isValid),
      );
      case 5: return CigarettesInterstitialStep(
        smokingYears: _smokingYears,
        dailyCigarettes: _dailyCigarettes,
        onValidStateChanged: (isValid) => _updateButtonState(isEnabled: isValid),
      );
      case 6: return PacketPriceStep(
        initialValue: _packetPrice,
        dailyCigarettes: _dailyCigarettes,
        onValueChanged: (val) => _packetPrice = val,
      );
      case 7: return MoneyInterstitialStep(
        dailyCigarettes: _dailyCigarettes,
        packetPrice: _packetPrice,
        onValidStateChanged: (isValid) => _updateButtonState(isEnabled: isValid),
      );
      case 8: return TryingCountStep(
        initialValue: _tryingCount,
        onValueChanged: (val) {
          _tryingCount = val;
          _updateButtonState(isEnabled: true);
        },
        onValidStateChanged: (isValid) => _updateButtonState(isEnabled: isValid),
      );
      case 9: return ReasonsStep(
        initialValues: _selectedReasons,
        onValuesChanged: (val) {
          _selectedReasons = val;
          _updateButtonState(isEnabled: val.isNotEmpty);
        },
        onValidStateChanged: (isValid) => _updateButtonState(isEnabled: isValid),
      );
      case 10: return TriggerMomentsStep(
        initialValue: _triggerMoment,
        onValueChanged: (val) {
          _triggerMoment = val;
          _updateButtonState(isEnabled: true);
        },
        onValidStateChanged: (isValid) => _updateButtonState(isEnabled: isValid),
      );
      case 11: return FinalLegalStep(
        key: _legalStepKey,
        onValidStateChanged: (isValid) => _updateButtonState(
          isEnabled: isValid,
        ),
      );
      case 12: return SummaryStep(
        dailyCigarettes: _dailyCigarettes,
        smokingYears: _smokingYears,
        packetPrice: _packetPrice,
        onNameChanged: (name) {
          _userName = name;
          _updateButtonState(isEnabled: name.trim().isNotEmpty);
        },
        onValidStateChanged: (isValid) => _updateButtonState(
          isEnabled: isValid,
        ),
      );
      default: return null;
    }
  }

  // ═══════════════════════════════════════════
  //  UI YAPISI
  // ═══════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final config = _getStepConfig(_currentPage);
    final contentWidget = _getContentWidget(_currentPage);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // ── KATMAN 1: İÇERİK (kayıp gelen kartlar) ──
                      if (contentWidget != null && _showContent)
                        Positioned(
                          top: config.mascotPosition == MascotPosition.center
                              ? _mascotSize + 120 // Ciğerito + balon altı
                              : _mascotSize + 70,  // Sol üst maskot + balon altı
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: SlideTransition(
                            position: _contentOffset,
                            child: SingleChildScrollView(
                              padding: AppSpacing.pageHorizontal,
                              child: contentWidget,
                            ),
                          ),
                        ),

                      // ── KATMAN 2: CİĞERİTO (pozisyon değiştiren) ──
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                        top: _mascotTop,
                        left: _mascotCentered
                            ? (screenWidth - _mascotSize) / 2
                            : _mascotLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                          width: _mascotSize,
                          height: _mascotSize,
                          child: SvgPicture.asset(
                            AssetConstants.cigeritoDefault,
                            width: _mascotSize,
                            height: _mascotSize,
                          ),
                        ),
                      ),

                      // ── KATMAN 3: KONUŞMA BALONU (küçülüp büyüyen) ──
                      if (_showBubble)
                        _buildBubbleLayer(config, screenWidth),
                    ],
                  );
                },
              ),
            ),
            _buildFixedFooter(),
          ],
        ),
      ),
    );
  }

  /// Konuşma balonunun konumlandırma ve animasyon katmanı
  Widget _buildBubbleLayer(OnboardingStepConfig config, double screenWidth) {
    // Ciğerito merkezdeyse: balon altında
    if (config.mascotPosition == MascotPosition.center) {
      return Positioned(
        top: _mascotTop + _mascotSize + 16,
        left: 24,
        right: 24,
        child: ScaleTransition(
          scale: _bubbleScale,
          alignment: Alignment.topCenter, // Ciğerito'ya doğru küçülür
          child: SpeechBubble(
            key: ValueKey('bubble_$_currentPage'),
            text: config.bubbleText,
            arrowDirection: config.arrowDirection,
            startTyping: _startTyping,
          ),
        ),
      );
    }

    // Ciğerito sol üstteyse: balon sağında
    return Positioned(
      top: _mascotTop,
      left: _mascotLeft + _mascotSize + 12,
      right: 24,
      child: ScaleTransition(
        scale: _bubbleScale,
        alignment: const Alignment(-1.0, -0.6), // Ciğerito'nun ortasına doğru küçülür
        child: SpeechBubble(
          key: ValueKey('bubble_$_currentPage'),
          text: config.bubbleText,
          arrowDirection: config.arrowDirection,
          startTyping: _startTyping,
        ),
      ),
    );
  }

  // --- Header UI ---
  Widget _buildHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: _currentPage > 0 && _phase == _TransitionPhase.idle
                ? _previousPage
                : null,
          ),
          Expanded(
            child: LunoProgressBar(value: (_currentPage + 1) / _totalSteps),
          ),
          const SizedBox(width: 16),
          Text(
            "${_currentPage + 1}/$_totalSteps",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // --- Footer UI ---
  Widget _buildFixedFooter() {
    final config = _getStepConfig(_currentPage);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.p24, 0, AppSpacing.p24, AppSpacing.p32,
      ),
      child: LunoButton(
        text: config.buttonLabel,
        icon: _currentPage == _totalSteps - 1
            ? Icons.check
            : Icons.arrow_forward,
        onPressed: (_isButtonEnabled || _currentPage == 11) && _phase == _TransitionPhase.idle
            ? _nextPage
            : () {}, // Legal ekranındıysa her zaman tıklanabilir ki hatayı tetikleyelim
      ),
    );
  }
}
