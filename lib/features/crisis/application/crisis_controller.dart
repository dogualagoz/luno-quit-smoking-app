import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';

enum CrisisPhase { idle, breathing, success }

enum BreathPhase { breathIn, hold, breathOut }

/// Returns the duration in seconds for a given 4-7-8 breath phase.
int breathPhaseSeconds(BreathPhase phase) {
  switch (phase) {
    case BreathPhase.breathIn:
      return AppBusinessRules.breathingInhaleSeconds;
    case BreathPhase.hold:
      return AppBusinessRules.breathingHoldSeconds;
    case BreathPhase.breathOut:
      return AppBusinessRules.breathingExhaleSeconds;
  }
}

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

String _randomQuote() =>
    _motivationalQuotes[Random().nextInt(_motivationalQuotes.length)];

class CrisisState {
  final CrisisPhase phase;
  final BreathPhase breath;
  final int phaseSecondsLeft;
  final int completedCycles;
  final int totalElapsedSeconds;
  final String quote;

  const CrisisState({
    required this.phase,
    required this.breath,
    required this.phaseSecondsLeft,
    required this.completedCycles,
    required this.totalElapsedSeconds,
    required this.quote,
  });

  factory CrisisState.initial() => CrisisState(
        phase: CrisisPhase.idle,
        breath: BreathPhase.breathIn,
        phaseSecondsLeft: AppBusinessRules.breathingInhaleSeconds,
        completedCycles: 0,
        totalElapsedSeconds: 0,
        quote: _randomQuote(),
      );

  CrisisState copyWith({
    CrisisPhase? phase,
    BreathPhase? breath,
    int? phaseSecondsLeft,
    int? completedCycles,
    int? totalElapsedSeconds,
    String? quote,
  }) {
    return CrisisState(
      phase: phase ?? this.phase,
      breath: breath ?? this.breath,
      phaseSecondsLeft: phaseSecondsLeft ?? this.phaseSecondsLeft,
      completedCycles: completedCycles ?? this.completedCycles,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
      quote: quote ?? this.quote,
    );
  }
}

/// Owns the breathing-exercise state machine and the per-second timers that
/// drive it. The widget reads [state] and listens for [breath] transitions to
/// run its animation; all timing and progress logic lives here.
class CrisisController extends StateNotifier<CrisisState> {
  CrisisController() : super(CrisisState.initial());

  Timer? _breathTimer;
  Timer? _elapsedTimer;

  void startBreathing() {
    _cancelTimers();
    state = CrisisState.initial().copyWith(phase: CrisisPhase.breathing);

    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        totalElapsedSeconds: state.totalElapsedSeconds + 1,
      );
    });

    _breathTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.phaseSecondsLeft - 1;
      if (next > 0) {
        state = state.copyWith(phaseSecondsLeft: next);
      } else {
        _advancePhase();
      }
    });
  }

  void _advancePhase() {
    switch (state.breath) {
      case BreathPhase.breathIn:
        state = state.copyWith(
          breath: BreathPhase.hold,
          phaseSecondsLeft: breathPhaseSeconds(BreathPhase.hold),
        );
      case BreathPhase.hold:
        state = state.copyWith(
          breath: BreathPhase.breathOut,
          phaseSecondsLeft: breathPhaseSeconds(BreathPhase.breathOut),
        );
      case BreathPhase.breathOut:
        final cycles = state.completedCycles + 1;
        if (cycles >= AppBusinessRules.breathingTargetCycles) {
          completeBreathing();
          return;
        }
        state = state.copyWith(
          breath: BreathPhase.breathIn,
          phaseSecondsLeft: breathPhaseSeconds(BreathPhase.breathIn),
          completedCycles: cycles,
          quote: _randomQuote(),
        );
    }
  }

  void completeBreathing() {
    _cancelTimers();
    state = state.copyWith(phase: CrisisPhase.success);
  }

  void reset() {
    _cancelTimers();
    state = CrisisState.initial();
  }

  void _cancelTimers() {
    _breathTimer?.cancel();
    _elapsedTimer?.cancel();
    _breathTimer = null;
    _elapsedTimer = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}

final crisisControllerProvider =
    StateNotifierProvider.autoDispose<CrisisController, CrisisState>((ref) {
  return CrisisController();
});
