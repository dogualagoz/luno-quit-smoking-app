import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../../onboarding/data/onboarding_repository.dart';
import '../../onboarding/data/firestore_repository.dart';
import '../../../services/local_storage/hive_service.dart';

/// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(authRepositoryProvider),
    ref.watch(onboardingRepositoryProvider),
    ref.watch(firestoreRepositoryProvider),
    ref,
  );
});

class AuthService {
  final AuthRepository _authRepository;
  final OnboardingRepository _onboardingRepository;
  final FirestoreRepository _firestoreRepository;
  final Ref _ref;

  AuthService(
    this._authRepository,
    this._onboardingRepository,
    this._firestoreRepository,
    this._ref,
  );

  /// Google ile giriş yapar ve gerekirse verileri senkronize eder.
  Future<User?> signInWithGoogle() async {
    // 1. Firebase oturumu aç
    final credential = await _authRepository.signInWithGoogle();

    if (credential != null && credential.user != null) {
      await _handleUserSync(credential.user!);
      return credential.user;
    }
    return null;
  }

  /// Apple ile giriş yapar ve verileri senkronize eder.
  Future<User?> signInWithApple() async {
    final credential = await _authRepository.signInWithApple();
    if (credential != null && credential.user != null) {
      await _handleUserSync(credential.user!);
      return credential.user;
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authRepository.signInWithEmailAndPassword(
      email,
      password,
    );
    if (credential.user != null) {
      await _handleUserSync(credential.user!);
      return credential.user;
    }
    return null;
  }

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authRepository.signUpWithEmailAndPassword(
      email,
      password,
    );
    if (credential.user != null) {
      await _handleUserSync(credential.user!);
      return credential.user;
    }
    return credential.user;
  }

  /// [User Sync Logic]: Cihazdaki (Hive) veriler ile Buluttaki (Firestore) verileri eşitler.
  Future<void> _handleUserSync(User user) async {
    final userId = user.uid;

    // 1. Bulutta bu kullanıcıya ait bir profil var mı bak?
    final cloudProfile = await _firestoreRepository.fetchProfile(userId);

    if (cloudProfile != null) {
      // BULUTTA VERİ VAR → Bulut profili her zaman öncelikli (hesabın gerçek sahibi)
      // Önce tüm yerel veriyi temizle, sonra bulut verisini yaz
      await HiveService.clearAllData();
      await _onboardingRepository.saveProfile(cloudProfile);
    } else {
      // BULUTTA VERİ YOK → Yeni hesap veya ilk senkronizasyon
      final localProfile = _onboardingRepository.getProfile();

      if (localProfile != null) {
        // GÜVENLİK KONTROLÜ: Yerel profil başka bir kullanıcıya mı ait?
        final isOwnData = localProfile.userId == null || localProfile.userId == userId;

        if (isOwnData) {
          // Sahipsiz veri veya aynı kullanıcının verisi → sahiplen ve Firestore'a yaz
          final profileToSync = localProfile.copyWith(
            userId: userId,
            email: user.email,
          );
          await _onboardingRepository.saveProfile(profileToSync);
          await _firestoreRepository.saveProfile(profileToSync);
        } else {
          // BAŞKA KULLANICININ VERİSİ → Tüm yerel veriyi temizle
          // Router onboarding'e yönlendirecek (hasProfile artık false)
          await HiveService.clearAllData();
        }
      }
    }

    // UI'ın güncel profili görmesi için provider'ı yenile
    _ref.invalidate(userProfileProvider);
  }

  /// Oturumu kapatır ve cihazdaki tüm yerel verileri temizler.
  Future<void> signOut() async {
    // 1. Firebase ve Google oturumunu kapat
    await _authRepository.signOut();
    // 2. Tüm yerel verileri sil (profil + günlük loglar)
    // Bu sayede başka bir hesapla girince eski kullanıcının verileri görünmez.
    await HiveService.clearAllData();
  }

  /// Hesabı tamamen siler, yerel ve bulut verileri dahil temizler.
  Future<void> deleteAccount() async {
    final user = _authRepository.currentUser;
    if (user != null) {
      // 1. Önce tüm yerel verileri temizle (profil + günlük loglar)
      await HiveService.clearAllData();

      // 2. Firebase ve Google Auth kimliğini (hesabı) tamamen sil
      await _authRepository.deleteAccount();
    }
  }
}
