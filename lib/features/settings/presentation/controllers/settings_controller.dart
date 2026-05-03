import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/onboarding/data/onboarding_repository.dart';
import '../../../../features/onboarding/data/models/user_profile.dart';

class SettingsState {
  final UserProfile? profile;
  final bool isDirty;

  SettingsState({this.profile, this.isDirty = false});

  SettingsState copyWith({UserProfile? profile, bool? isDirty}) {
    return SettingsState(
      profile: profile ?? this.profile,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  final OnboardingRepository _repository;

  SettingsController(this._repository) : super(SettingsState()) {
    _init();
  }

  void _init() {
    final profile = _repository.getProfile();
    state = SettingsState(profile: profile);
  }

  void updateDailyCigarettes(int value) {
    if (state.profile == null) return;
    state = state.copyWith(
      profile: state.profile!.copyWith(dailyCigarettes: value),
      isDirty: true,
    );
  }

  void updatePackPrice(double value) {
    if (state.profile == null) return;
    state = state.copyWith(
      profile: state.profile!.copyWith(packPrice: value),
      isDirty: true,
    );
  }

  /// Haftalık sigara azaltma hedefini günceller
  void updateWeeklySmokingGoal(int value) {
    if (state.profile == null) return;
    state = state.copyWith(
      profile: state.profile!.copyWith(weeklySmokingGoal: value),
      isDirty: true,
    );
  }

  Future<void> saveSettings() async {
    if (!state.isDirty || state.profile == null) return;
    
    await _repository.saveProfile(state.profile!);
    state = state.copyWith(isDirty: false);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return SettingsController(repository);
});
