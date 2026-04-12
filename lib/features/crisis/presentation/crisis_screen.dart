import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';

/// Kriz ekranı — 3 aşamalı:
/// 1. Bekleme (idle): Maskot + istatistikler + "Kriz Geldi" butonu
/// 2. Nefes Egzersizi: 4-7-8 soluma animasyonu + zamanlayıcı + motivasyon
/// 3. Başarı: Tebrik + kriz kaydı anketi (CravingScreen'e yönlendirme)

// Motivasyon sözleri
const List<String> _motivationalQuotes = [
  "Bu istek 3-5 dakikada geçecek. Sen daha zor şeyleri aştın.",
  "Her direndiğin kriz, ciğerlerini iyileştiren bir zafer.",
  "Nefes al, bırak gitsin. Duman değil, temiz hava.",
  "Bir sigara 7 dakika ömründen çalıyor. Ama bu kriz 5 dakikada geçecek.",
  "Bugüne kadar direndin, şimdi de direneceksin.",
  "Beynin seni kandırıyor. İstek değil, alışkanlığın sesini duyuyorsun.",
  "Bu anı atlatırsan, yarın daha güçlü uyanacaksın.",
  "Sigara bir çözüm değil. Sadece 5 dakikalık bir erteleme.",
  "Krizler azalacak. Her biri bir öncekinden daha kısa sürecek.",
  "Bu an geçici. Ama sağlığın kalıcı.",
];

// 4-7-8 Nefes tekniği fazları
enum BreathPhase { breathIn, hold, breathOut }

const _breathPhaseDurations = {
  BreathPhase.breathIn: 4,
  BreathPhase.hold: 7,
  BreathPhase.breathOut: 8,
};

const _breathPhaseLabels = {
  BreathPhase.breathIn: "Nefes Al",
  BreathPhase.hold: "Tut",
  BreathPhase.breathOut: "Yavaşça Ver",
};

class CrisisScreen extends ConsumerStatefulWidget {
  const CrisisScreen({super.key});

  @override
  ConsumerState<CrisisScreen> createState() => _CrisisScreenState();
}

class _CrisisScreenState extends ConsumerState<CrisisScreen>
    with TickerProviderStateMixin {
  // Ekran durumu: idle, breathing, success
  String _screenState = 'idle'; // idle | breathing | success

  // Nefes egzersizi state
  BreathPhase _currentPhase = BreathPhase.breathIn;
  int _phaseSecondsLeft = 4;
  int _completedCycles = 0;
  int _totalElapsedSeconds = 0;
  Timer? _breathTimer;
  Timer? _elapsedTimer;
  String _currentQuote = '';

  // Animasyon
  late AnimationController _breathAnimController;
  late Animation<double> _breathScale;

  static const int _targetCycles = 3; // 3 tur nefes egzersizi

  @override
  void initState() {
    super.initState();
    _currentQuote = _motivationalQuotes[Random().nextInt(_motivationalQuotes.length)];

    _breathAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breathScale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathTimer?.cancel();
    _elapsedTimer?.cancel();
    _breathAnimController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _screenState = 'breathing';
      _currentPhase = BreathPhase.breathIn;
      _phaseSecondsLeft = _breathPhaseDurations[BreathPhase.breathIn]!;
      _completedCycles = 0;
      _totalElapsedSeconds = 0;
    });

    _breathAnimController.forward();

    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _totalElapsedSeconds++);
    });

    _breathTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _phaseSecondsLeft--;
        if (_phaseSecondsLeft <= 0) {
          _advancePhase();
        }
      });
    });
  }

  void _advancePhase() {
    switch (_currentPhase) {
      case BreathPhase.breathIn:
        _currentPhase = BreathPhase.hold;
        _phaseSecondsLeft = _breathPhaseDurations[BreathPhase.hold]!;
        _breathAnimController.stop();
        break;
      case BreathPhase.hold:
        _currentPhase = BreathPhase.breathOut;
        _phaseSecondsLeft = _breathPhaseDurations[BreathPhase.breathOut]!;
        _breathAnimController.reverse();
        break;
      case BreathPhase.breathOut:
        _completedCycles++;
        if (_completedCycles >= _targetCycles) {
          _onBreathingComplete();
          return;
        }
        _currentPhase = BreathPhase.breathIn;
        _phaseSecondsLeft = _breathPhaseDurations[BreathPhase.breathIn]!;
        _currentQuote = _motivationalQuotes[Random().nextInt(_motivationalQuotes.length)];
        _breathAnimController.forward();
        break;
    }
  }

  void _onBreathingComplete() {
    _breathTimer?.cancel();
    _elapsedTimer?.cancel();
    setState(() => _screenState = 'success');
  }

  void _reset() {
    _breathTimer?.cancel();
    _elapsedTimer?.cancel();
    _breathAnimController.reset();
    setState(() {
      _screenState = 'idle';
      _currentQuote = _motivationalQuotes[Random().nextInt(_motivationalQuotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: switch (_screenState) {
          'breathing' => _buildBreathingMode(context),
          'success' => _buildSuccessMode(context),
          _ => _buildIdleMode(context),
        },
      ),
    );
  }

  // ─────────────────────── IDLE ───────────────────────
  Widget _buildIdleMode(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logsState = ref.watch(historyLogsProvider);
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final successColor = isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;

    // İstatistikleri hesapla
    int totalCravings = 0;
    int weekCravings = 0;
    int totalSlips = 0;
    final now = DateTime.now();

    logsState.whenData((logs) {
      for (var log in logs) {
        final logType = _getLogType(log);
        if (logType == 'craving') {
          totalCravings++;
          if (now.difference(log.date).inDays <= 7) weekCravings++;
        } else {
          totalSlips++;
        }
      }
    });

    final successRate = (totalCravings + totalSlips) > 0
        ? ((totalCravings / (totalCravings + totalSlips)) * 100).toInt()
        : 0;

    return SingleChildScrollView(
      child: Padding(
        padding: AppSpacing.pageHorizontal,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.p24),
            Text('Kriz Modu ⚡', style: AppTextStyles.header),
            const SizedBox(height: AppSpacing.p40),

            // Maskot
            SvgPicture.asset(
              AssetConstants.cigeritoDefault,
              height: 120,
            ),
            const SizedBox(height: AppSpacing.p16),

            // Konuşma Balonu
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              padding: const EdgeInsets.all(AppSpacing.p16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _currentQuote,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.p32),

            // Kriz Geldi Butonu
            SizedBox(
              width: double.infinity,
              child: LunoButton(
                text: "Sigara İsteği Geldi!",
                icon: Icons.bolt,
                onPressed: _startBreathing,
              ),
            ),
            const SizedBox(height: AppSpacing.p12),
            Text(
              "Düğmeye bas, birlikte bu anı atlatacağız.\nOrtalama kriz süresi: 3-5 dakika",
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
            ),

            const SizedBox(height: AppSpacing.p32),

            // İstatistik Kartı
            LunoCard(
              padding: AppSpacing.cardPaddingLarge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kriz İstatistiklerin",
                    style: AppTextStyles.cardHeader.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.p20),
                  Row(
                    children: [
                      _buildStatItem(
                        totalCravings.toString(),
                        "Atlanan kriz",
                        successColor,
                        context,
                      ),
                      _buildStatItem(
                        weekCravings.toString(),
                        "Bu hafta",
                        primary,
                        context,
                      ),
                      _buildStatItem(
                        "%$successRate",
                        "Başarı oranı",
                        isDark ? AppColors.darkChartWarning : AppColors.lightChartWarning,
                        context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.p96),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color, BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.statValue.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─────────────────────── BREATHING ───────────────────────
  Widget _buildBreathingMode(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    final phaseLabel = _breathPhaseLabels[_currentPhase]!;
    final totalPhaseDuration = _breathPhaseDurations[_currentPhase]!;
    final progress = 1.0 - (_phaseSecondsLeft / totalPhaseDuration);

    final minutes = _totalElapsedSeconds ~/ 60;
    final seconds = _totalElapsedSeconds % 60;
    final timeStr = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p16),
          // Üst bar: Geri + Süre
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _reset,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: primary),
                    const SizedBox(width: 6),
                    Text(
                      timeStr,
                      style: AppTextStyles.bodySemibold.copyWith(color: primary),
                    ),
                  ],
                ),
              ),
              // Tur bilgisi
              Text(
                "${_completedCycles + 1}/$_targetCycles",
                style: AppTextStyles.bodySemibold.copyWith(color: Theme.of(context).hintColor),
              ),
            ],
          ),

          const Spacer(),

          // Nefes Animasyonu Dairesi
          AnimatedBuilder(
            animation: _breathAnimController,
            builder: (context, child) {
              return Transform.scale(
                scale: _breathScale.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primary.withValues(alpha: 0.3),
                        primary.withValues(alpha: 0.05),
                      ],
                    ),
                    border: Border.all(color: primary.withValues(alpha: 0.4), width: 3),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _phaseSecondsLeft.toString(),
                          style: AppTextStyles.largeNumber.copyWith(color: primary),
                        ),
                        Text(
                          phaseLabel,
                          style: AppTextStyles.bodySemibold.copyWith(color: primary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.p16),

          // İlerleme çubuğu
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: AppSpacing.p40),

          // Motivasyon Sözü
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.p16),
            padding: const EdgeInsets.all(AppSpacing.p20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _currentQuote,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const Spacer(),

          // Atlayabilme seçeneği
          TextButton(
            onPressed: _onBreathingComplete,
            child: Text(
              "Egzersizi Atla →",
              style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
        ],
      ),
    );
  }

  // ─────────────────────── SUCCESS ───────────────────────
  Widget _buildSuccessMode(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;

    final minutes = _totalElapsedSeconds ~/ 60;
    final seconds = _totalElapsedSeconds % 60;
    final timeStr = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Başarı ikonu
          Container(
            padding: const EdgeInsets.all(AppSpacing.p24),
            decoration: BoxDecoration(
              color: successColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.emoji_events, size: 64, color: successColor),
          ),
          const SizedBox(height: AppSpacing.p24),

          Text(
            "Harika, Direndin! 💪",
            style: AppTextStyles.header.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            "$timeStr boyunca nefes egzersizi yaptın ve bu krizi atlattın.\nŞimdi bu anı kaydet — veriler seni güçlendirecek.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: AppSpacing.p40),

          // Kriz Kaydı Butonu → CravingScreen
          SizedBox(
            width: double.infinity,
            child: LunoButton(
              text: "Krizi Kaydet",
              icon: Icons.shield_outlined,
              onPressed: () {
                context.push(AppRouter.craving);
                // Başarı ekranından çıkınca idle'a geri dön
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) _reset();
                });
              },
            ),
          ),
          const SizedBox(height: AppSpacing.p16),

          // Kayıt olmadan kapat
          TextButton(
            onPressed: _reset,
            child: Text(
              "Kaydetmeden Geç",
              style: AppTextStyles.bodySemibold.copyWith(color: Theme.of(context).hintColor),
            ),
          ),
        ],
      ),
    );
  }

  String _getLogType(dynamic log) {
    try {
      return log.type ?? 'craving';
    } catch (_) {
      return 'craving';
    }
  }
}
