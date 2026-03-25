import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [authRepositoryProvider], uygulamanın herhangi bir yerinden (UI, Logic)
/// Auth işlemlerine tek bir noktadan erişmemizi sağlayan Riverpod sağlayıcısıdır.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Firebase Auth ve Google Sign In nesnelerini repository'ye dışarıdan veriyoruz (Dependency Injection).
  return AuthRepository(FirebaseAuth.instance, GoogleSignIn.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// [AuthRepository], Firebase ve Google Sign-In paketleriyle doğrudan konuşan "Repository" katmanıdır.
/// Sadece veri alışverişinden (Auth servislerini çağırmaktan) sorumludur.
class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._auth, this._googleSignIn);

  // --- Kullanıcı Bilgileri ---

  /// [currentUser], şu an oturumu açık olan Firebase kullanıcısını verir.
  /// Giriş yapılmamışsa null döner (User?).
  User? get currentUser => _auth.currentUser;

  /// [authStateChanges], kullanıcının giriş ya da çıkış yapma durumunu anlık olarak dinleyen bir akış (Stream) döner.
  /// Bir kullanıcı login/logout olduğunda bu Stream tetiklenir ve uygulama durumunu güncelleyebiliriz.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // --- Giriş & Kayıt Metodları ---

  /// Google ile hızlı giriş yapma metodudur.
  /// [authenticate()] metodu Google Identity sistemini tetikler.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Kullanıcıdan Google hesabı seçmesini ve kimliğini doğrulamayı ister
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();

      // Kullanıcı pencereyi kapatırsa null döner
      if (googleUser == null) return null;

      // 2. Google'dan gelen kimlik doğruluğu (idToken) bilgilerini alır
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 3. Bu bilgileri Firebase'in anlayacağı bir "Credential" (kimlik belgesi) haline getirir
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken:
            null, // Veri erişimi gerekmediği sürece (sadece girmek için) null yeterlidir
        idToken: googleAuth.idToken,
      );

      // 4. Firebase'e bu belgeyle giriş yapmasını söyler
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Hata oluşursa hatayı bir üst katmana (Controller'a) fırlatır
      rethrow;
    }
  }

  /// Klasik E-posta ve Şifre ile giriş yapma metodur.
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Yeni bir E-posta ve Şifre hesabı oluşturma metodur.
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Hem Google hem de Firebase oturumunu tamamen kapatma metodudur.
  Future<void> signOut() async {
    try {
      // Önce Google oturumu (hesap seçme durumu) sıfırlanır
      await _googleSignIn.signOut();
      // Sonra Firebase oturumu sonlandırılır
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Kullanıcının hesabını tamamen siler (App Store zorunluluğu).
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        await _googleSignIn.signOut();
      }
    } catch (e) {
      rethrow;
    }
  }
}
