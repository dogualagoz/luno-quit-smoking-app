import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:luno_quit_smoking_app/services/local_storage/hive_service.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import '../../../core/services/analytics_service.dart';
import 'models/user_profile.dart';

// Bu repository'i uygulamanın her yerinden çağırmak için bir provider oluşturuyoruz
final onboardingRepositoryProvider = Provider((ref) {
  final analytics = ref.watch(analyticsServiceProvider);
  return OnboardingRepository(analytics);
});

// Kullanıcı profilini reaktif olarak takip eden provider
final userProfileProvider = StateProvider<UserProfile?>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return repo.getProfile();
});

class OnboardingRepository {
  final AnalyticsService _analytics;
  OnboardingRepository(this._analytics);

  Box<UserProfile> get _box => HiveService.getUserBox();

  // Kullanıcı profilini kaydeder
  Future<void> saveProfile(UserProfile profile) async {
    await _box.put(HiveService.userProfileKey, profile);

    // Analytics: Profil oluşturulduğunda kullanıcı özelliklerini set et ve olayı logla
    await _analytics.setUserProfile(
      dailyCigarettes: profile.dailyCigarettes,
      packPrice: profile.packPrice,
      yearsSmoking: profile.smokingYears,
    );
    await _analytics.logOnboardingComplete();
  }

  // Kullanıcı profilini getirir (yoksa null döner)
  UserProfile? getProfile() {
    return _box.get(HiveService.userProfileKey);
  }

  //Profil var mı kontrolü (Onboarding bitti mi ?)
  bool isProfileCreated() {
    return _box.containsKey(HiveService.userProfileKey);
  }

  //Profili sil (Test amaçlı veya hesabı sıfırlamak için)
  Future<void> deleteProfile() async {
    await _box.delete(HiveService.userProfileKey);
  }
}
