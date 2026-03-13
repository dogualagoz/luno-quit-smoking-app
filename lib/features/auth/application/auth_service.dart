import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../../onboarding/data/onboarding_repository.dart';
import '../../onboarding/data/firestore_repository.dart';

/// AuthService Provider: Uygulama mantığını (business logic) yürüten servisi sağlar.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(authRepositoryProvider),
    ref.watch(onboardingRepositoryProvider),
    ref.watch(firestoreRepositoryProvider),
  );
});

class AuthService {
  final AuthRepository _authRepository;
  final OnboardingRepository _onboardingRepository;
  final FirestoreRepository _firestoreRepository;

  AuthService(
    this._authRepository,
    this._onboardingRepository,
    this._firestoreRepository,
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
      // 2. BULUTTA VERI VAR: Kullanıcı uygulamayı silip yüklemiş veya yeni bir cihazda.
      // Buluttaki veriyi alıp yerel (Hive) belleğe kaydediyoruz.
      await _onboardingRepository.saveProfile(cloudProfile);
    } else {
      // 3. BULUTTA VERI YOK: Yeni giriş yapmış bir kullanıcı.
      final localProfile = _onboardingRepository.getProfile();
      if (localProfile != null) {
        // Yereldeki (Hive) veriye Firebase UserId ve Email ekleyip buluta yedekliyoruz.
        final profileToSync = localProfile.copyWith(
          userId: userId,
          email: user.email,
        );
        await _onboardingRepository.saveProfile(
          profileToSync,
        ); // Yereli güncelle
        await _firestoreRepository.saveProfile(profileToSync); // Buluta yedekle
      }
    }
  }

  /// Oturumu kapatır ve cihazdaki yerel verileri tamamen temizler.
  Future<void> signOut() async {
    // 1. Firebase ve Google oturumunu kapat
    await _authRepository.signOut();
    // 2. ÖNEMLİ: Cihazdaki yerel onboarding verilerini sil
    // Bu sayede yeni bir hesapla girince eski veriler karışmaz.
    await _onboardingRepository.deleteProfile();
  }
}
