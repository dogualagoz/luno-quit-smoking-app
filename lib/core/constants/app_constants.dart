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

  /// Sigara içilen yıl başına iyileşme süresi katsayısı (yıl cinsinden)
  static const double recoveryFactor = 0.75;

  /// Bir yıldaki gün sayısı
  static const int daysPerYear = 365;

  /// Bir aydaki ortalama gün sayısı
  static const int daysPerMonth = 30;
}
