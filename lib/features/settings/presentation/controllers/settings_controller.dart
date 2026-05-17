import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/services/sync_service.dart';
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
  final Ref _ref;

  SettingsController(this._ref) : super(SettingsState()) {
    _init();
  }

  OnboardingRepository get _repository =>
      _ref.read(onboardingRepositoryProvider);

  void _init() {
    state = SettingsState(profile: _repository.getProfile());
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
    _ref.invalidate(userProfileProvider);

    final user = _ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      await _ref.read(syncServiceProvider).syncUserProfile(user);
    }

    state = state.copyWith(isDirty: false);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController(ref);
});
