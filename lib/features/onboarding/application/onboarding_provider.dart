import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/constants/app_constants.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import 'package:luno_quit_smoking_app/core/services/sync_service.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/models/user_profile.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<void>>((ref) {
      return OnboardingNotifier(ref);
    });

class OnboardingNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  OnboardingNotifier(this._ref) : super(const AsyncValue.data(null));

  OnboardingRepository get _repository =>
      _ref.read(onboardingRepositoryProvider);

  /// Persists the user-collected onboarding data to Hive and marks the
  /// profile as completed. If a Firebase user is already signed in, the
  /// profile is pushed to Firestore as well; otherwise the next successful
  /// sign-in will sync it via [SyncService].
  Future<void> finalizeOnboarding({
    required String nickname,
    required int dailyCigarettes,
    required int smokingYears,
    required double packPrice,
    int cigarettesPerPack = AppBusinessRules.defaultCigarettesPerPack,
    String? tryingToQuitCount,
    List<String> quitReasons = const [],
    String? triggerMoment,
    DateTime? quitDate,
  }) async {
    state = const AsyncValue.loading();

    try {
      final user = _ref.read(firebaseAuthProvider).currentUser;

      final profile = UserProfile(
        nickname: nickname,
        dailyCigarettes: dailyCigarettes,
        smokingYears: smokingYears,
        packPrice: packPrice,
        cigarettesPerPack: cigarettesPerPack,
        tryingToQuitCount: tryingToQuitCount,
        quitReasons: quitReasons,
        triggerMoment: triggerMoment,
        quitDate: quitDate,
        createdAt: DateTime.now(),
        userId: user?.uid,
        email: user?.email,
        onboardingCompleted: true,
      );

      await _repository.saveProfile(profile);
      _ref.invalidate(userProfileProvider);

      if (user != null) {
        await _ref.read(syncServiceProvider).syncUserProfile(user);
      }

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
