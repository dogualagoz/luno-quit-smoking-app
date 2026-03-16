class AppMockData {
  static const String userName = 'Doğukan';
  static const String profileName = 'Duman';

  static const String registerDate = '2026-06-23';

  // Genel istatistikler
  static const String totalSpent = '95.813';
  static const String totalSmoked = '25.550';
  static const String totalLossDays = '124';
  static const String timeLostString = '12 Gün';
  static const String healthRiskPercent = '%85';

  //Sigara detayları (settings)
  static const String dailyAvgValue = '14';
  static const String packPriceValue = '75';
  static const String dailyGoalValue = '10';

  //İçerikler
  static const String lungStatus = 'Akciğerlerin Temizleniyor';
  static const double recoveryProgress = 0.6;
  static const String dailyQuote =
      'Her sigara hayatından 11 dakika çalar. Ama sen zaten zamanı dumanla harcamayı seviyorsun değil mi?';
}

class AppBusinessRules {
  /// Her sigara hayattan çaldığı dakika
  /// Kaynak: U.S. Surgeon General — "Smoking Cessation" (2020)
  static const int minutesLostPerCigarette = 11;

  /// Bir paketteki varsayılan sigara sayısı
  static const int defaultCigarettesPerPack = 20;

  /// Bir günün dakika cinsinden karşılığı
  static const int minutesPerDay = 1440;

  /// Bir saatin dakika cinsinden karşılığı
  static const int minutesPerHour = 60;

  /// Bir sigaranın metre cinsinden uzunluğu (filtre dahil)
  static const double cigaretteLengthMeters = 0.084;

  /// Metreyi kilometreye çevirmek için bölücü
  static const double metersPerKilometer = 1000;

  /// Bir yıldaki gün sayısı
  static const int daysPerYear = 365;

  /// Bir aydaki ortalama gün sayısı
  static const int daysPerMonth = 30;
}

// ─────────────────────────────────────────────────────────────────────────────
// Bilimsel İyileşme Aşamaları
// Kaynaklar:
//   • American Cancer Society — "Benefits of Quitting Smoking Over Time"
//   • U.S. Surgeon General — "Smoking Cessation" (2020)
//   • World Health Organization — Tobacco Fact Sheet
//   • NHS — "What happens when you quit smoking"
// ─────────────────────────────────────────────────────────────────────────────

/// Bırakma sonrası tek bir iyileşme aşamasını temsil eder.
class RecoveryMilestone {
  /// Bırakıştan itibaren geçmesi gereken süre
  final Duration duration;

  /// Aşamanın kısa başlığı (UI'da gösterilir)
  final String title;

  /// Aşamanın açıklaması
  final String description;

  /// Bilimsel kaynak referansı
  final String source;

  const RecoveryMilestone({
    required this.duration,
    required this.title,
    required this.description,
    required this.source,
  });
}

/// ACS + WHO + Surgeon General kaynaklarının kesişiminden alınan
/// doğrulanmış iyileşme zaman çizelgesi.
class RecoveryMilestones {
  const RecoveryMilestones._();

  static const List<RecoveryMilestone> timeline = [
    RecoveryMilestone(
      duration: Duration(minutes: 20),
      title: "Nabız Normale Döner",
      description: "Nabız ve tansiyon sigara öncesi seviyeye iner.",
      source: "ACS, WHO",
    ),
    RecoveryMilestone(
      duration: Duration(hours: 12),
      title: "Karbonmonoksit Temizlenir",
      description: "Kandaki karbonmonoksit seviyesi normale döner.",
      source: "ACS, Surgeon General",
    ),
    RecoveryMilestone(
      duration: Duration(hours: 24),
      title: "Kalp Krizi Riski Azalır",
      description: "Kalp krizi riski düşmeye başlar.",
      source: "ACS",
    ),
    RecoveryMilestone(
      duration: Duration(hours: 48),
      title: "Duyular Canlanır",
      description: "Koku ve tat alma duyuları iyileşmeye başlar.",
      source: "ACS, NHS",
    ),
    RecoveryMilestone(
      duration: Duration(hours: 72),
      title: "Nefes Rahatlar",
      description: "Bronşlar gevşer, nefes almak kolaylaşır.",
      source: "ACS",
    ),
    RecoveryMilestone(
      duration: Duration(days: 90),
      title: "Dolaşım İyileşir",
      description:
          "Kan dolaşımı iyileşir, akciğer kapasitesi %30'a kadar artar.",
      source: "Surgeon General, WHO",
    ),
    RecoveryMilestone(
      duration: Duration(days: 270),
      title: "Akciğerler Temizlenir",
      description:
          "Öksürük ve nefes darlığı azalır, kirpiksi yapılar yenilenir.",
      source: "Surgeon General",
    ),
    RecoveryMilestone(
      duration: Duration(days: 365),
      title: "Kalp Riski Yarıya İner",
      description: "Koroner kalp hastalığı riski yarıya düşer.",
      source: "ACS, WHO",
    ),
    RecoveryMilestone(
      duration: Duration(days: 1825), // 5 yıl
      title: "İnme Riski Normale Döner",
      description: "İnme riski sigara içmeyen kişi seviyesine iner.",
      source: "ACS, Surgeon General",
    ),
    RecoveryMilestone(
      duration: Duration(days: 3650), // 10 yıl
      title: "Kanser Riski Yarıya İner",
      description: "Akciğer kanseri riski yarıya düşer.",
      source: "ACS, WHO",
    ),
    RecoveryMilestone(
      duration: Duration(days: 5475), // 15 yıl
      title: "Tam İyileşme",
      description: "Kalp hastalığı riski hiç içmemiş biriyle eşitlenir.",
      source: "ACS, WHO",
    ),
  ];

  /// Son milestone'un süresi (toplam iyileşme süresi = 15 yıl)
  static const Duration fullRecoveryDuration = Duration(days: 5475);
}
