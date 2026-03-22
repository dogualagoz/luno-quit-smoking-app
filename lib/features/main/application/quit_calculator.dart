import 'dart:math';

import 'package:luno_quit_smoking_app/core/constants/app_constants.dart';
import 'package:luno_quit_smoking_app/core/constants/damage_model.dart';
import 'package:luno_quit_smoking_app/features/history/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/models/user_profile.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';

/// Kullanıcının sigara geçmişine dayalı hasar istatistiklerini hesaplar.
///
/// Tüm hesaplamalar bilimsel kaynaklara dayanır:
///   • ACS — "Benefits of Quitting Smoking Over Time"
///   • U.S. Surgeon General — "Smoking Cessation" (2020)
///   • CDC — "Health Effects of Cigarette Smoking"
class QuitCalculator {
  const QuitCalculator._();

  /// Kullanıcının bugüne kadar sigaraya verdiği toplam bedeli hesaplar.
  /// [atTime] parametresi verilirse, o anki saate göre canlı hesaplama yapar.
  static QuitStats calculate(UserProfile profile, {DateTime? atTime, List<DailyLog> logs = const []}) {
    final now = atTime ?? DateTime.now();

    final damage = _calculateDamageMetrics(profile, logs, now);
    final burnRate = _calculateBurnRate(profile);
    final organs = _calculateOrganDamages(profile);
    final totalDamageScore = _calculateTotalDamageScore(organs);

    // İyileşme: en uzun iyileşme süresine sahip organı baz al
    final maxRecoveryDays = organs.fold<int>(
      0,
      (prev, organ) => max(prev, organ.recoveryDays),
    );
    final recoveryYears = maxRecoveryDays ~/ AppBusinessRules.daysPerYear;
    final remainingAfterYears = maxRecoveryDays % AppBusinessRules.daysPerYear;
    final recoveryMonths = remainingAfterYears ~/ AppBusinessRules.daysPerMonth;
    final recoveryDays = remainingAfterYears % AppBusinessRules.daysPerMonth;

    return QuitStats(
      rawMoney: damage.rawMoney,
      moneyLabel: "Harcanan Para",
      moneyValue: damage.formattedMoney,
      moneyDecimal: ",${damage.moneyDecimalPart}",
      moneySubtext:
          "₺${(burnRate * 60).toStringAsFixed(1)}/dk yanıyor", // Dakika hızına çevir
      moneyAction: "ne alabilirdin? — dokun",
      timeLabel: "Kaybedilen Zaman",
      timeValue: damage.daysLost.toString(),
      timeSubtext: "Şu an da sayaç işliyor...",
      timeDigits: damage.timeDigits,
      countLabel: "İçilen Sigara",
      countValue: _formatWithThousandSeparator(
        damage.totalSmoked.toInt().toString(),
      ),
      countSubtext:
          "${damage.distanceKm.toStringAsFixed(1)} km — Everest'e tırmanabilirdin",
      recoveryLabel: "İyileşme Süresi",
      recoveryYears: recoveryYears,
      recoveryMonths: recoveryMonths,
      recoveryDays: recoveryDays,
      recoverySubtext: "içmeye devam ettikçe artıyor",
      recoveryAction: "🌱 bırakırsan ne olur? — dokun",
      organDamages: organs,
      totalDamageScore: totalDamageScore,
      progress: totalDamageScore,
      type: QuitStatType.loss,
      isEstimatedToday: damage.isEstimatedToday,
    );
  }

  /// Saniye başına kayıp hızlarını hesaplar (Para, Zaman, Sigara)
  static _LossRates calculateRates(UserProfile profile) {
    final pricePerCigarette = profile.packPrice / profile.cigarettesPerPack;
    final dailyCost = profile.dailyCigarettes * pricePerCigarette;
    final dailyTimeLost =
        profile.dailyCigarettes * AppBusinessRules.minutesLostPerCigarette;

    return _LossRates(
      moneyPerSecond: dailyCost / 86400,
      minutesPerSecond: dailyTimeLost / 86400,
      cigarettesPerSecond: profile.dailyCigarettes / 86400,
    );
  }

  // ─── Organ Hasar Hesaplaması ──────────────────────────────────────────────
  //
  // Her organ için:
  //   hasar = min(1.0, (yıl / maxDamageYears) × baseDamagePerYear × yıl × çarpan)
  //
  // Günlük 20+ sigara içenler: heavySmokerMultiplier uygulanır.
  // Kaynak: CDC — "Health Effects" tablosundaki risk katlanma oranları.
  // ──────────────────────────────────────────────────────────────────────────

  /// Kullanıcının profilindeki verilere göre organ bazlı hasar hesaplar.
  static List<OrganDamageModel> _calculateOrganDamages(UserProfile profile) {
    final years = profile.smokingYears;
    final daily = profile.dailyCigarettes;

    return organDamageConfigs.map((config) {
      // Yıl bazlı baz hasar (0.0 – 1.0)
      // Logaritmik/Saturasyon hasar eğrisi:
      // İlk yıllar hasar hızlı artar, sonra yavaşlar.
      // y = 1 - e^(-x/k) mantığına benzer bir clamping.
      final yearFactor = years / config.maxDamageYears;
      var damageScore = 1.0 - exp(-yearFactor * config.baseDamagePerYear * 5);

      // Ağır içiciler için ek yük (logaritmik)
      if (daily >= AppBusinessRules.defaultCigarettesPerPack) {
        damageScore *= config.heavySmokerMultiplier;
      }

      var damage = damageScore.clamp(0.0, 0.98);

      // Hafif içiciler için düşürme (günlük 10 altı)
      if (daily < 10) {
        damage *= 0.7;
      }

      damage = damage.clamp(0.0, 0.95); // Maksimum %95

      // Açıklama metnini hasara göre dinamik oluştur
      final damagePercent = (damage * 100).toInt();
      final description = _generateDamageDescription(
        config.title,
        damagePercent,
      );

      return OrganDamageModel(
        title: config.title,
        description: description,
        quote: config.quote,
        damage: damage,
        icon: config.icon,
        colors: config.colors,
        recoveryDays: config.recoveryDays,
        source: config.source,
      );
    }).toList();
  }

  /// Organ ve hasar yüzdesine göre açıklama metni üretir.
  static String _generateDamageDescription(String organ, int percent) {
    if (percent < 15) return "Henüz ciddi hasar yok, ama risk artıyor.";
    if (percent < 35) return "Erken dönem hasar belirtileri — %$percent risk.";
    if (percent < 60) return "Orta seviye hasar — %$percent etkilenmiş.";
    if (percent < 80) return "Yüksek hasar — %$percent kapasitede kayıp.";
    return "Kritik seviye — %$percent ciddi risk altında.";
  }

  /// Tüm organların ağırlıklı ortalamasıyla genel hasar skoru hesaplar.
  static double _calculateTotalDamageScore(List<OrganDamageModel> organs) {
    if (organs.isEmpty) return 0.0;

    // Akciğer ve kalp daha yüksek ağırlıklı
    const weights = {
      "Akciğerler": 1.5,
      "Kalp": 1.3,
      "Kan Dolaşımı": 1.0,
      "Beyin": 1.0,
      "Ağız & Boğaz": 0.8,
      "Mide & Sindirim": 0.8,
    };

    double weightedSum = 0;
    double totalWeight = 0;

    for (final organ in organs) {
      final weight = weights[organ.title] ?? 1.0;
      weightedSum += organ.damage * weight;
      totalWeight += weight;
    }

    return (weightedSum / totalWeight).clamp(0.0, 1.0);
  }

  // ─── Finansal Hesaplamalar ────────────────────────────────────────────────

  /// Finansal hasar, zaman kaybı ve mesafe metriklerini hesaplar.
  static _DamageMetrics _calculateDamageMetrics(
    UserProfile profile,
    List<DailyLog> logs,
    DateTime now,
  ) {
    // 1. Geçmiş Yılların Zararı (SmokingYears bazlı)
    final historicalSmoked =
        profile.smokingYears *
        AppBusinessRules.daysPerYear *
        profile.dailyCigarettes;

    // 2. Uygulama Kullanıldığından Beri Canlı Zarar (Hybrid)
    final rates = calculateRates(profile);

    final createdDate = DateTime(profile.createdAt.year, profile.createdAt.month, profile.createdAt.day);
    final todayStr = DateTime(now.year, now.month, now.day);
    
    // Geçmiş logları tarihlere göre grupla
    final Map<DateTime, int> loggedSmokesByDate = {};
    DateTime? lastLogTodayTime;

    for (var log in logs) {
      if (log.type == 'slip' && log.hasSmoked) {
        final d = DateTime(log.date.year, log.date.month, log.date.day);
        if (!d.isBefore(createdDate)) {
          loggedSmokesByDate[d] = (loggedSmokesByDate[d] ?? 0) + log.smokeCount;
          
          if (d.year == todayStr.year && d.month == todayStr.month && d.day == todayStr.day) {
            if (lastLogTodayTime == null || log.date.isAfter(lastLogTodayTime!)) {
              lastLogTodayTime = log.date;
            }
          }
        }
      }
    }
    
    double liveSmoked = 0.0;
    bool isEstimatedToday = true;

    // Kayıt oluşturulan günden bugüne kadar döngü
    for (DateTime d = createdDate; !d.isAfter(todayStr); d = DateTime(d.year, d.month, d.day + 1)) {
      final bool hasLog = loggedSmokesByDate.containsKey(d);
      
      if (d.year == todayStr.year && d.month == todayStr.month && d.day == todayStr.day) {
        if (hasLog) {
          liveSmoked += loggedSmokesByDate[d]!;
          if (lastLogTodayTime != null) {
            final msSinceLastLog = now.difference(lastLogTodayTime!).inMilliseconds;
            if (msSinceLastLog > 0) {
              liveSmoked += (rates.cigarettesPerSecond / 1000) * msSinceLastLog;
            }
          }
          isEstimatedToday = false;
        } else {
          final msToday = now.difference(todayStr).inMilliseconds;
          liveSmoked += (rates.cigarettesPerSecond / 1000) * msToday;
        }
      } else {
        if (hasLog) {
          liveSmoked += loggedSmokesByDate[d]!;
        } else {
          liveSmoked += profile.dailyCigarettes;
        }
      }
    }

    final totalSmoked = historicalSmoked + liveSmoked;

    final pricePerCigarette = profile.packPrice / profile.cigarettesPerPack;
    final totalSpent = totalSmoked * pricePerCigarette;

    // Para formatlama
    final moneyValue = totalSpent.floor();
    final moneyDecimalPart = ((totalSpent - moneyValue) * 100)
        .toInt()
        .toString()
        .padLeft(2, '0');

    // Zaman kaybı
    final totalMinsLost =
        totalSmoked * AppBusinessRules.minutesLostPerCigarette;
    final totalSecondsLost =
        totalMinsLost * 60; // Saniye cinsinden toplam kayıp

    final daysLost = totalMinsLost ~/ AppBusinessRules.minutesPerDay;
    final remainingMins = totalMinsLost % AppBusinessRules.minutesPerDay;
    final hours = (remainingMins ~/ AppBusinessRules.minutesPerHour).toInt();
    final mins = (remainingMins % AppBusinessRules.minutesPerHour).toInt();
    final secs = (totalSecondsLost % 60).toInt();

    // Sayaç rakamları: [gün1, gün2, saat1, saat2, dk1, dk2, sn1, sn2]
    final timeDigits = [
      ...daysLost.toString().padLeft(2, '0').split(''),
      ...hours.toString().padLeft(2, '0').split(''),
      ...mins.toString().padLeft(2, '0').split(''),
      ...secs.toString().padLeft(2, '0').split(''),
    ];

    // Mesafe kıyaslaması
    final distanceKm =
        (totalSmoked * AppBusinessRules.cigaretteLengthMeters) /
        AppBusinessRules.metersPerKilometer;

    return _DamageMetrics(
      totalSmoked: totalSmoked,
      rawMoney: totalSpent,
      formattedMoney: _formatWithThousandSeparator(moneyValue.toString()),
      moneyDecimalPart: moneyDecimalPart,
      daysLost: daysLost,
      timeDigits: timeDigits,
      distanceKm: distanceKm,
      isEstimatedToday: isEstimatedToday,
    );
  }

  /// Dakika başına yanma hızını (₺/sn) hesaplar.
  static double _calculateBurnRate(UserProfile profile) {
    final pricePerCigarette = profile.packPrice / profile.cigarettesPerPack;
    // Saniye hızı döndür, calculate metodunda dk'ya çevrilecek
    return (profile.dailyCigarettes * pricePerCigarette) / 86400;
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
  final double totalSmoked;
  final double rawMoney;
  final String formattedMoney;
  final String moneyDecimalPart;
  final int daysLost;
  final List<String> timeDigits;
  final double distanceKm;
  final bool isEstimatedToday;

  const _DamageMetrics({
    required this.totalSmoked,
    required this.rawMoney,
    required this.formattedMoney,
    required this.moneyDecimalPart,
    required this.daysLost,
    required this.timeDigits,
    required this.distanceKm,
    required this.isEstimatedToday,
  });
}

/// Saniye başına kayıp hızlarını taşıyan sınıf
class _LossRates {
  final double moneyPerSecond;
  final double minutesPerSecond;
  final double cigarettesPerSecond;

  const _LossRates({
    required this.moneyPerSecond,
    required this.minutesPerSecond,
    required this.cigarettesPerSecond,
  });
}
