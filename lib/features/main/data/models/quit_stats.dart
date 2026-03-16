import 'package:luno_quit_smoking_app/core/constants/damage_model.dart';

/// İstatistiklerin tipini belirler:
/// [success] -> Bıraktıktan sonraki kazanımlar
/// [loss] -> Bırakmadan önceki veya devam eden zararlar
enum QuitStatType { success, loss }

class QuitStats {
  // — Para Kartı —
  final String moneyLabel; // "Harcanan Para"
  final String moneyValue; // "₺ 68.438"
  final String moneyDecimal; // ",21"
  final String moneySubtext; // "₺0.0/dk yanıyor"
  final String moneyAction; // "ne alabilirdin? — dokun"

  // — Zaman Kartı —
  final String timeLabel; // "Kaybedilen Zaman"
  final String timeValue; // "89" (gün)
  final String timeSubtext; // "Şu an da sayaç işliyor... ⌛"
  final List<String> timeDigits; // ["8","9","0","0","0","0","2","4"]

  // — Sigara Kartı —
  final String countLabel; // "İçilen Sigara"
  final String countValue; // "18.250"
  final String countSubtext; // "1.5 km — Everest'e tırmanabilirdin"

  // — İyileşme Süresi Kartı —
  final String recoveryLabel; // "İyileşme Süresi"
  final int recoveryYears; // 3
  final int recoveryMonths; // 8
  final int recoveryDays; // 30
  final String recoverySubtext; // "içmeye devam ettikçe artıyor"
  final String recoveryAction; // "🌱 bırakırsan ne olur? — dokun"

  // — Organ Hasar Verileri —
  final List<OrganDamageModel> organDamages;

  // — Genel Hasar Skoru (0.0 – 1.0) —
  final double totalDamageScore;

  final double progress; // 0.0 - 1.0
  final QuitStatType type; // success or loss

  QuitStats({
    required this.moneyLabel,
    required this.moneyValue,
    this.moneyDecimal = "",
    required this.moneySubtext,
    required this.moneyAction,
    required this.timeLabel,
    required this.timeValue,
    required this.timeSubtext,
    required this.timeDigits,
    required this.countLabel,
    required this.countValue,
    required this.countSubtext,
    required this.recoveryLabel,
    required this.recoveryYears,
    required this.recoveryMonths,
    required this.recoveryDays,
    required this.recoverySubtext,
    required this.recoveryAction,
    this.organDamages = const [],
    this.totalDamageScore = 0.0,
    required this.progress,
    required this.type,
  });
}
