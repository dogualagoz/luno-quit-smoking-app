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
  static const int minuesLostPerCigarette = 11;
}
