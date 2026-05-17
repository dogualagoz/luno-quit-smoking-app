import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/sync_service.dart';
import '../../../services/local_storage/hive_service.dart';
import '../../onboarding/data/onboarding_repository.dart';
import '../data/auth_repository.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(authRepositoryProvider),
    ref.watch(syncServiceProvider),
    ref,
  );
});

/// Owns the post-authentication handshake.
///
/// On sign-in: reconciles local Hive data with the user's Firestore records
/// via [SyncService] — no destructive overwrites; the newer side wins.
/// On sign-out / account deletion: local data is wiped intentionally.
class AuthService {
  final AuthRepository _authRepository;
  final SyncService _syncService;
  final Ref _ref;

  AuthService(this._authRepository, this._syncService, this._ref);

  Future<User?> signInWithGoogle() async {
    final credential = await _authRepository.signInWithGoogle();
    final user = credential?.user;
    if (user != null) {
      await _handleUserSync(user);
    }
    return user;
  }

  Future<User?> signInWithApple() async {
    final credential = await _authRepository.signInWithApple();
    final user = credential?.user;
    if (user != null) {
      await _handleUserSync(user);
    }
    return user;
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authRepository.signInWithEmailAndPassword(
      email,
      password,
    );
    final user = credential.user;
    if (user != null) {
      await _handleUserSync(user);
    }
    return user;
  }

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authRepository.signUpWithEmailAndPassword(
      email,
      password,
    );
    final user = credential.user;
    if (user != null) {
      await _handleUserSync(user);
    }
    return user;
  }

  Future<void> _handleUserSync(User user) async {
    await _syncService.syncUserProfile(user);
    await _syncService.syncDailyLogs(user);
    _ref.invalidate(userProfileProvider);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    await HiveService.clearAllData();
    _ref.invalidate(userProfileProvider);
  }

  Future<void> deleteAccount() async {
    if (_authRepository.currentUser == null) return;
    await HiveService.clearAllData();
    await _authRepository.deleteAccount();
    _ref.invalidate(userProfileProvider);
  }
}
