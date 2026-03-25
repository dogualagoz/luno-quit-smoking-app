import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/features/auth/application/auth_service.dart';
import '../../data/auth_repository.dart';

// UI'ın 'Loading', 'Error' veya 'Data' durumlarını otomatik yöneten sağlayıcı (Provider)
final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(() {
  return AuthController();
});

// AuthController: UI ile AuthRepository arasındaki köprüdür
class AuthController extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    // Uygulama başladığında mevcut kullanıcıyı döner (Oturum açık mı kontrolü)
    return ref.read(authRepositoryProvider).currentUser;
  }

  // Google ile giriş işlemini tetikler ve UI durumunu günceller
  Future<void> signInWithGoogle() async {
    final service = ref.read(authServiceProvider);

    // UI'ı 'yükleniyor' (AsyncLoading) durumuna sokar
    state = const AsyncLoading();

    // İşlemi dener; başarılıysa kullanıcıyı, hata alırsa hatayı state'e yazar
    state = await AsyncValue.guard(() => service.signInWithGoogle());
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    final service = ref.read(authServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => service.signInWithEmailAndPassword(email, password),
    );
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    final service = ref.read(authServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => service.signUpWithEmailAndPassword(email, password),
    );
  }

  // Oturumu kapatır ve UI durumunu günceller
  Future<void> signOut() async {
    final service = ref.read(authServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => service.signOut().then((_) => null));
  }

  // Hesabı kalıcı olarak siler ve UI durumunu günceller
  Future<void> deleteAccount() async {
    final service = ref.read(authServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => service.deleteAccount().then((_) => null));
  }
}
