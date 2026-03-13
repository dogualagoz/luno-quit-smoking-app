import 'package:luno_quit_smoking_app/core/constants/app_constants.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/models/user_profile.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';

/// Kullanıcının sigara geçmişine dayalı hasar istatistiklerini hesaplar.
///
/// Bu sınıf, kullanıcının onboarding'de girdiği verileri (günlük sigara,
/// paket fiyatı, içme süresi vb.) kullanarak toplam harcama, kaybedilen
/// zaman, mesafe kıyaslaması ve iyileşme süresi gibi metrikleri üretir.
class QuitCalculator {
  const QuitCalculator._();

  /// Kullanıcının bugüne kadar sigaraya verdiği toplam bedeli hesaplar.
  static QuitStats calculate(UserProfile profile) {
    final damage = _calculateDamageMetrics(profile);
    final recovery = _calculateRecoveryDuration(profile);
    final burnRate = _calculateBurnRate(profile);

    return QuitStats(
      moneyLabel: "Harcanan Para",
      moneyValue: "₺ ${damage.formattedMoney}",
      moneyDecimal: ",${damage.moneyDecimalPart}",
      moneySubtext: "₺${burnRate.toStringAsFixed(1)}/dk yanıyor",
      moneyAction: "ne alabilirdin? — dokun",
      timeLabel: "Kaybedilen Zaman",
      timeValue: damage.daysLost.toString(),
      timeSubtext: "Şu an da sayaç işliyor... ⌛",
      timeDigits: damage.timeDigits,
      countLabel: "İçilen Sigara",
      countValue: _formatWithThousandSeparator(damage.totalSmoked.toString()),
      countSubtext:
          "${damage.distanceKm.toStringAsFixed(1)} km — Everest'e tırmanabilirdin",
      recoveryLabel: "İyileşme Süresi",
      recoveryYears: recovery.years,
      recoveryMonths: recovery.months,
      recoveryDays: recovery.days,
      recoverySubtext: "içmeye devam ettikçe artıyor",
      recoveryAction: "🌱 bırakırsan ne olur? — dokun",
      progress: 0.23,
      type: QuitStatType.loss,
    );
  }

  /// [calculate] ile aynı mantığı kullanır.
  static QuitStats calculateLifetimeDamage(UserProfile profile) =>
      calculate(profile);

  // — Private Hesaplama Yardımcıları —

  /// Finansal hasar, zaman kaybı ve mesafe metriklerini hesaplar.
  static _DamageMetrics _calculateDamageMetrics(UserProfile profile) {
    final totalSmoked =
        profile.smokingYears *
        AppBusinessRules.daysPerYear *
        profile.dailyCigarettes;

    final pricePerCigarette = profile.packPrice / profile.cigarettesPerPack;
    final totalSpent = totalSmoked * pricePerCigarette;

    // Para formatlama
    final moneyStr = totalSpent.toStringAsFixed(2);
    final moneyParts = moneyStr.split('.');

    // Zaman kaybı
    final totalMinsLost =
        totalSmoked * AppBusinessRules.minutesLostPerCigarette;
    final daysLost = totalMinsLost ~/ AppBusinessRules.minutesPerDay;
    final remainingMins = totalMinsLost % AppBusinessRules.minutesPerDay;
    final hours = remainingMins ~/ AppBusinessRules.minutesPerHour;
    final mins = remainingMins % AppBusinessRules.minutesPerHour;

    // Sayaç rakamları: [gün1, gün2, saat1, saat2, dk1, dk2, sn1, sn2]
    final timeDigits = [
      ...daysLost.toString().padLeft(2, '0').split(''),
      ...hours.toString().padLeft(2, '0').split(''),
      ...mins.toString().padLeft(2, '0').split(''),
      ...'00'.split(''), // Saniye — canlı sayaçta güncellenecek
    ];

    // Mesafe kıyaslaması
    final distanceKm =
        (totalSmoked * AppBusinessRules.cigaretteLengthMeters) /
        AppBusinessRules.metersPerKilometer;

    return _DamageMetrics(
      totalSmoked: totalSmoked,
      formattedMoney: _formatWithThousandSeparator(moneyParts[0]),
      moneyDecimalPart: moneyParts[1],
      daysLost: daysLost,
      timeDigits: timeDigits,
      distanceKm: distanceKm,
    );
  }

  /// Dakika başına yanma hızını (₺/dk) hesaplar.
  static double _calculateBurnRate(UserProfile profile) {
    final pricePerCigarette = profile.packPrice / profile.cigarettesPerPack;
    return (profile.dailyCigarettes * pricePerCigarette) /
        AppBusinessRules.minutesPerDay;
  }

  /// Sigarayı bıraktığında vücudun tam iyileşme süresini hesaplar.
  static _RecoveryDuration _calculateRecoveryDuration(UserProfile profile) {
    final totalRecoveryDays =
        profile.smokingYears *
        AppBusinessRules.daysPerYear *
        AppBusinessRules.recoveryFactor;
    final years = totalRecoveryDays ~/ AppBusinessRules.daysPerYear;
    final remainingDays = totalRecoveryDays % AppBusinessRules.daysPerYear;
    final months = remainingDays ~/ AppBusinessRules.daysPerMonth;
    final days = (remainingDays % AppBusinessRules.daysPerMonth).floor();

    return _RecoveryDuration(years: years, months: months, days: days);
  }

  /// Binlik ayırıcı ekler (Örn: 292075 → 292.075)
  static String _formatWithThousandSeparator(String value) {
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}

/// Hasar hesaplama sonuçlarını taşıyan veri sınıfı.
class _DamageMetrics {
  final int totalSmoked;
  final String formattedMoney;
  final String moneyDecimalPart;
  final int daysLost;
  final List<String> timeDigits;
  final double distanceKm;

  const _DamageMetrics({
    required this.totalSmoked,
    required this.formattedMoney,
    required this.moneyDecimalPart,
    required this.daysLost,
    required this.timeDigits,
    required this.distanceKm,
  });
}

/// İyileşme süresi sonuçlarını taşıyan veri sınıfı.
class _RecoveryDuration {
  final int years;
  final int months;
  final int days;

  const _RecoveryDuration({
    required this.years,
    required this.months,
    required this.days,
  });
}
