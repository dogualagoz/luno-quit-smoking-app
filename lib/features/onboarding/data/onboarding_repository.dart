import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:luno_quit_smoking_app/services/local_storage/hive_service.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import 'package:luno_quit_smoking_app/features/auth/data/auth_repository.dart';
import '../../../core/services/analytics_service.dart';
import 'models/user_profile.dart';

final onboardingRepositoryProvider = Provider((ref) {
  final analytics = ref.watch(analyticsServiceProvider);
  return OnboardingRepository(analytics);
});

/// Reads the locally stored profile. Re-evaluated when the auth state changes
/// (different user logging in) so the UI always reflects the current session.
final userProfileProvider = Provider<UserProfile?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(onboardingRepositoryProvider).getProfile();
});

class OnboardingRepository {
  final AnalyticsService _analytics;
  OnboardingRepository(this._analytics);

  Box<UserProfile> get _box => HiveService.getUserBox();

  /// Persists the profile to Hive (the source of truth). Cloud propagation is
  /// the caller's responsibility via [SyncService.syncUserProfile].
  Future<void> saveProfile(UserProfile profile) async {
    await _box.put(HiveService.userProfileKey, profile);

    await _analytics.setUserProfile(
      dailyCigarettes: profile.dailyCigarettes,
      packPrice: profile.packPrice,
      yearsSmoking: profile.smokingYears,
    );
    if (profile.onboardingCompleted) {
      await _analytics.logOnboardingComplete();
    }
  }

  UserProfile? getProfile() => _box.get(HiveService.userProfileKey);

  /// Onboarding is considered complete only when the profile explicitly
  /// flags it — a partially-filled record is not enough.
  bool isOnboardingCompleted() {
    final profile = _box.get(HiveService.userProfileKey);
    return profile?.onboardingCompleted ?? false;
  }

  Future<void> deleteProfile() async {
    await _box.delete(HiveService.userProfileKey);
  }
}
