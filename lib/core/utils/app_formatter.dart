/// Uygulama genelinde kullanılan veri formatlama araçları.
/// SRP (Single Responsibility) gereği, hesaplama sınıfları formatlama yapmaz,
/// bu sınıf üzerinden formatlanmış verileri alır.
class AppFormatter {
  /// Para değerini yerel formata çevirir (₺ 1.250 gibi)
  static String formatMoney(double amount) {
    return '₺ ${amount.toStringAsFixed(0)}';
  }

  /// Dakika cinsinden süreyi daha okunabilir hale getirir.
  static String formatMinutes(int totalMinutes) {
    if (totalMinutes < 60) return '$totalMinutes dk';

    final hours = (totalMinutes / 60).floor();
    final remainingMinutes = totalMinutes % 60;

    if (hours < 24) return '$hours sa $remainingMinutes dk';

    final days = (hours / 24).floor();
    final remainingHours = hours % 24;

    return '$days gün $remainingHours sa';
  }

  /// Yüzdelik değeri %85 formatına çevirir.
  static String formatPercent(int value) {
    return '%$value';
  }
}
