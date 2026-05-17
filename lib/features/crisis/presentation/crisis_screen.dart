import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/core/constants/app_constants.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/crisis/application/crisis_controller.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';

const Map<BreathPhase, String> _breathPhaseLabels = {
  BreathPhase.breathIn: "Nefes Al",
  BreathPhase.hold: "Tut",
  BreathPhase.breathOut: "Yavaşça Ver",
};

/// Three-phase crisis flow:
/// 1. idle — mascot + stats + "I'm having a craving" CTA
/// 2. breathing — 4-7-8 animation driven by [CrisisController]
/// 3. success — congratulations + redirect to craving log
class CrisisScreen extends ConsumerStatefulWidget {
  const CrisisScreen({super.key});

  @override
  ConsumerState<CrisisScreen> createState() => _CrisisScreenState();
}

class _CrisisScreenState extends ConsumerState<CrisisScreen>
    with TickerProviderStateMixin {
  late final AnimationController _breathAnimController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathAnimController = AnimationController(
      vsync: this,
      duration: Duration(seconds: AppBusinessRules.breathingInhaleSeconds),
    );
    _breathScale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathAnimController.dispose();
    super.dispose();
  }

  void _syncAnimationToPhase(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.breathIn:
        _breathAnimController.forward();
      case BreathPhase.hold:
        _breathAnimController.stop();
      case BreathPhase.breathOut:
        _breathAnimController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Drive the scale animation off the controller's BreathPhase transitions.
    ref.listen<BreathPhase>(
      crisisControllerProvider.select((s) => s.breath),
      (prev, next) => _syncAnimationToPhase(next),
    );
    ref.listen<CrisisPhase>(
      crisisControllerProvider.select((s) => s.phase),
      (prev, next) {
        if (next == CrisisPhase.idle) _breathAnimController.reset();
      },
    );

    final state = ref.watch(crisisControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: switch (state.phase) {
          CrisisPhase.breathing => _buildBreathingMode(context, state),
          CrisisPhase.success => _buildSuccessMode(context, state),
          CrisisPhase.idle => _buildIdleMode(context, state),
        },
      ),
    );
  }

  // ─────────────────────── IDLE ───────────────────────
  Widget _buildIdleMode(BuildContext context, CrisisState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logsState = ref.watch(historyLogsProvider);
    final primary = context.primary;
    final successColor =
        context.chartSuccess;

    int totalCravings = 0;
    int weekCravings = 0;
    int totalSlips = 0;
    final now = DateTime.now();

    logsState.whenData((logs) {
      for (final log in logs) {
        if (log.type == 'craving') {
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
            SvgPicture.asset(AssetConstants.cigeritoDefault, height: 120),
            const SizedBox(height: AppSpacing.p16),
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
                state.quote,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.p32),
            SizedBox(
              width: double.infinity,
              child: LunoButton(
                text: "Sigara İsteği Geldi!",
                icon: Icons.bolt,
                onPressed: () =>
                    ref.read(crisisControllerProvider.notifier).startBreathing(),
              ),
            ),
            const SizedBox(height: AppSpacing.p12),
            Text(
              "Düğmeye bas, birlikte bu anı atlatacağız.\nOrtalama kriz süresi: 3-5 dakika",
              textAlign: TextAlign.center,
              style: AppTextStyles.caption
                  .copyWith(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: AppSpacing.p32),
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
                      _buildStatItem(totalCravings.toString(), "Atlanan kriz",
                          successColor, context),
                      _buildStatItem(
                          weekCravings.toString(), "Bu hafta", primary, context),
                      _buildStatItem(
                        "%$successRate",
                        "Başarı oranı",
                        isDark
                            ? AppColors.darkChartWarning
                            : AppColors.lightChartWarning,
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

  Widget _buildStatItem(
      String value, String label, Color color, BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.statValue.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.micro
                .copyWith(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─────────────────────── BREATHING ───────────────────────
  Widget _buildBreathingMode(BuildContext context, CrisisState state) {
    final primary = context.primary;
    final phaseLabel = _breathPhaseLabels[state.breath]!;
    final totalPhaseDuration = breathPhaseSeconds(state.breath);
    final progress = 1.0 - (state.phaseSecondsLeft / totalPhaseDuration);

    final minutes = state.totalElapsedSeconds ~/ 60;
    final seconds = state.totalElapsedSeconds % 60;
    final timeStr =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    final controller = ref.read(crisisControllerProvider.notifier);

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: controller.reset,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              Text(
                "${state.completedCycles + 1}/${AppBusinessRules.breathingTargetCycles}",
                style: AppTextStyles.bodySemibold
                    .copyWith(color: Theme.of(context).hintColor),
              ),
            ],
          ),
          const Spacer(),
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
                    border: Border.all(
                        color: primary.withValues(alpha: 0.4), width: 3),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.phaseSecondsLeft.toString(),
                          style: AppTextStyles.largeNumber
                              .copyWith(color: primary),
                        ),
                        Text(
                          phaseLabel,
                          style: AppTextStyles.bodySemibold
                              .copyWith(color: primary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.p16),
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.p16),
            padding: const EdgeInsets.all(AppSpacing.p20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              state.quote,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: controller.completeBreathing,
            child: Text(
              "Egzersizi Atla →",
              style: AppTextStyles.caption
                  .copyWith(color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
        ],
      ),
    );
  }

  // ─────────────────────── SUCCESS ───────────────────────
  Widget _buildSuccessMode(BuildContext context, CrisisState state) {
    final successColor = context.chartSuccess;

    final minutes = state.totalElapsedSeconds ~/ 60;
    final seconds = state.totalElapsedSeconds % 60;
    final timeStr =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    final controller = ref.read(crisisControllerProvider.notifier);

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            style: AppTextStyles.body
                .copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: AppSpacing.p40),
          SizedBox(
            width: double.infinity,
            child: LunoButton(
              text: "Krizi Kaydet",
              icon: Icons.shield_outlined,
              onPressed: () {
                context.push(AppRouter.craving, extra: false);
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) controller.reset();
                });
              },
            ),
          ),
          const SizedBox(height: AppSpacing.p16),
          TextButton(
            onPressed: controller.reset,
            child: Text(
              "Kaydetmeden Geç",
              style: AppTextStyles.bodySemibold
                  .copyWith(color: Theme.of(context).hintColor),
            ),
          ),
        ],
      ),
    );
  }
}
