class ErrorTranslator {
  ErrorTranslator._();

  static String translate(dynamic error) {
    final String errorStr = error.toString().toLowerCase();

    // Firebase Auth Hataları
    if (errorStr.contains('user-not-found') || errorStr.contains('invalid-credential')) {
      return "E-posta adresi veya şifre hatalı.";
    }
    if (errorStr.contains('wrong-password')) {
      return "Şifre yanlış, lütfen tekrar deneyin.";
    }
    if (errorStr.contains('email-already-in-use')) {
      return "Bu e-posta adresi zaten kullanımda.";
    }
    if (errorStr.contains('invalid-email')) {
      return "Geçersiz bir e-posta adresi girdiniz.";
    }
    if (errorStr.contains('weak-password')) {
      return "Şifreniz çok zayıf. En az 6 karakter kullanın.";
    }
    if (errorStr.contains('network-request-failed')) {
      return "İnternet bağlantınızı kontrol edin.";
    }
    if (errorStr.contains('too-many-requests')) {
      return "Çok fazla deneme yaptınız. Lütfen sonra tekrar deneyin.";
    }
    if (errorStr.contains('operation-not-allowed')) {
      return "Giriş yöntemi şu an aktif değil.";
    }
    if (errorStr.contains('user-disabled')) {
      return "Bu kullanıcı hesabı askıya alınmış.";
    }

    // Genel Hatalar
    return "Bir hata oluştu. Lütfen tekrar deneyin.";
  }
}
