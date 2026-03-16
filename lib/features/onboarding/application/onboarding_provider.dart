import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/constants/app_constants.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/models/user_profile.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';

// Onboarding ekranının state'ini tutacak provider
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(onboardingRepositoryProvider);
      return OnboardingNotifier(repository, ref);
    });

class OnboardingNotifier extends StateNotifier<AsyncValue<void>> {
  final OnboardingRepository _repository;
  final Ref _ref;

  OnboardingNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  // Kullanıcı verilerini toplar ve Hive'a kaydeder

  Future<void> completeOnboarding({
    required String nickname,
    required int dailyCigarettes,
    required int smokingYears,
    required double packPrice,
    int cigarettesPerPack = AppBusinessRules.defaultCigarettesPerPack,
    String? tryingToQuitCount,
    List<String> quitReasons = const [],
    String? triggerMoment,
    DateTime? quitDate,
    String? userId,
    String? email,
  }) async {
    state = const AsyncValue.loading();

    try {
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
        userId: userId,
        email: email,
      );

      await _repository.saveProfile(profile);
      _ref.read(userProfileProvider.notifier).state = profile;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Mevcut profili Auth bilgileriyle (Firebase UID ve Email) günceller
  Future<void> updateProfileAuth({
    required String userId,
    String? email,
  }) async {
    final currentProfile = _repository.getProfile();
    if (currentProfile == null) return;
    final updatedProfile = currentProfile.copyWith(
      userId: userId,
      email: email,
    );
    await _repository.saveProfile(updatedProfile);
    _ref.read(userProfileProvider.notifier).state = updatedProfile;
  }
}
