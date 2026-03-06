import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/models/user_profile.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';

// Onboarding ekranının state'ini tutacak provider
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(onboardingRepositoryProvider);
      return OnboardingNotifier(repository);
    });

class OnboardingNotifier extends StateNotifier<AsyncValue<void>> {
  final OnboardingRepository _repository;

  OnboardingNotifier(this._repository) : super(const AsyncValue.data(null));

  // Kullanıcı verilerini toplar ve Hive'a kaydeder

  Future<void> completeOnboarding({
    required String nickname,
    required int dailyCigarettes,
    required int smokingYears,
    required double packPrice,
    required int cigarettesPerPack,
    DateTime? quitDate,
  }) async {
    state = const AsyncValue.loading();

    try {
      final profile = UserProfile(
        nickname: nickname,
        dailyCigarettes: dailyCigarettes,
        smokingYears: smokingYears,
        packPrice: packPrice,
        cigarettesPerPack: cigarettesPerPack,
        quitDate: quitDate,
        createdAt: DateTime.now(),
      );

      // Repository üzerindne veriyi kaydet
      await _repository.saveProfile(profile);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Uygulama açılışında onboarding yapıldı mı kontrolü
  bool checkOnboardingStatus() {
    return _repository.isProfileCreated();
  }
}
