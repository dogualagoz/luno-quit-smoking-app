import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // --- Onboarding Olayları ---
  Future<void> logOnboardingStarted() async {
    await _analytics.logEvent(name: 'onboarding_started');
  }

  Future<void> logOnboardingStep(int stepIndex, String stepName) async {
    await _analytics.logEvent(
      name: 'onboarding_step_view',
      parameters: {
        'step_index': stepIndex,
        'step_name': stepName,
      },
    );
  }

  Future<void> logOnboardingComplete() async {
    await _analytics.logEvent(name: 'onboarding_completed');
  }

  // --- Temel Kullanım Olayları ---
  Future<void> logSmokeLogged({int? count, String? reason}) async {
    await _analytics.logEvent(
      name: 'smoke_logged',
      parameters: {
        'count': count ?? 1,
        'has_reason': reason != null && reason.isNotEmpty,
      },
    );
  }

  Future<void> logCravingResisted({int? intensity}) async {
    await _analytics.logEvent(
      name: 'craving_logged',
      parameters: {
        'intensity': intensity ?? 0,
      },
    );
  }

  // --- Kullanıcı Özellikleri ---
  Future<void> setUserProfile({
    required int dailyCigarettes,
    required double packPrice,
    required int yearsSmoking,
  }) async {
    await _analytics.setUserProperty(
      name: 'daily_cigarettes',
      value: dailyCigarettes.toString(),
    );
    await _analytics.setUserProperty(
      name: 'pack_price',
      value: packPrice.toString(),
    );
    await _analytics.setUserProperty(
      name: 'years_smoking',
      value: yearsSmoking.toString(),
    );
  }

  // --- Ekran Takibi ---
  FirebaseAnalyticsObserver getObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }
}
