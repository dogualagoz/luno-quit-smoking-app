// ─────────────────────────────────────────────────────────────────────────────
// Organ Hasar Modeli — Bilimsel Kaynaklara Dayalı
// Kaynaklar:
//   • U.S. Surgeon General — "The Health Consequences of Smoking" (2014)
//   • CDC — "Health Effects of Cigarette Smoking"
//   • American Cancer Society — "Harmful Chemicals in Tobacco Products"
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Tek bir organın hasar verisini temsil eder.
class OrganDamageModel {
  /// Organın adı (UI'da gösterilir)
  final String title;

  /// Hasarın açıklaması (dinamik olarak hesaplanır)
  final String description;

  /// Ciğerito'nun sarkastik yorumu
  final String quote;

  /// 0.0 – 1.0 arası hesaplanmış hasar seviyesi
  final double damage;

  /// Kart ikonu
  final IconData icon;

  /// Gradient renkleri
  final List<Color> colors;

  /// Bıraktıktan sonra tam iyileşme süresi (gün)
  /// Kaynak: U.S. Surgeon General (2014)
  final int recoveryDays;

  /// Bilimsel kaynak referansı
  final String source;

  const OrganDamageModel({
    required this.title,
    required this.description,
    required this.quote,
    required this.damage,
    required this.icon,
    required this.colors,
    required this.recoveryDays,
    required this.source,
  });

  /// Hasar yüzdesini değiştirerek yeni bir kopya oluşturur.
  OrganDamageModel copyWith({
    String? description,
    double? damage,
    String? quote,
  }) {
    return OrganDamageModel(
      title: title,
      description: description ?? this.description,
      quote: quote ?? this.quote,
      damage: damage ?? this.damage,
      icon: icon,
      colors: colors,
      recoveryDays: recoveryDays,
      source: source,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Organ Şablonları — Hasar Hesaplamasında Kullanılan Sabitler
//
// Her organın hasar seviyesi, kullanıcının sigara geçmişine (yıl × günlük adet)
// göre QuitCalculator tarafından hesaplanır. Buradaki damage değerleri
// varsayılan (placeholder) değerlerdir.
//
// maxDamageYears: Bu yıl sayısını aşan kullanıcılarda hasar %100'e yaklaşır.
// baseDamagePerYear: Her yıl için baz hasar oranı.
// dailyCigaretteMultiplier: Günlük adet arttıkça hasarı çarpan katsayı.
//
// Kaynaklar:
//   • Akciğer: 10+ yıl kullanımda KOAH riski %50+  (Surgeon General, 2014)
//   • Kalp: 15+ yıl kullanımda koroner risk 2-4x   (ACS)
//   • Damar: 10+ yıl kullanımda ateroskleroz riski  (CDC)
//   • Beyin: 15+ yıl kullanımda inme riski 2-4x     (Surgeon General)
//   • Ağız: 10+ yıl kullanımda kanser riski 10x     (ACS)
//   • Mide: 15+ yıl kullanımda ülser ve kanser riski (CDC)
// ─────────────────────────────────────────────────────────────────────────────

/// Organ bazlı hasar hesaplama sabitleri
class OrganDamageConfig {
  final String title;
  final IconData icon;
  final List<Color> colors;
  final String quote;

  /// Bu yıl sayısından sonra hasar maksimuma ulaşır
  final int maxDamageYears;

  /// Yıl başına baz hasar oranı (0.0 – 1.0)
  final double baseDamagePerYear;

  /// Günlük 20+ adet içenlerde hasar çarpanı
  final double heavySmokerMultiplier;

  /// Bıraktıktan sonra tam iyileşme süresi (gün)
  final int recoveryDays;

  /// Bilimsel kaynak
  final String source;

  const OrganDamageConfig({
    required this.title,
    required this.icon,
    required this.colors,
    required this.quote,
    required this.maxDamageYears,
    required this.baseDamagePerYear,
    required this.heavySmokerMultiplier,
    required this.recoveryDays,
    required this.source,
  });
}

/// Bilimsel kaynaklara dayalı organ hasar konfigürasyonları.
const List<OrganDamageConfig> organDamageConfigs = [
  OrganDamageConfig(
    title: "Akciğerler",
    icon: Icons.air_rounded,
    colors: [Color(0xFFE8A0BF), Color(0xFFD4789E)],
    quote: "Merdiven çıkarken nefes nefese kalman tesadüf değil.",
    maxDamageYears: 15,
    baseDamagePerYear: 0.055, // %5.5/yıl
    heavySmokerMultiplier: 1.4,
    recoveryDays: 3650, // 10 yıl (Surgeon General)
    source: "U.S. Surgeon General (2014), CDC",
  ),
  OrganDamageConfig(
    title: "Kalp",
    icon: Icons.favorite_rounded,
    colors: [Color(0xFFE57373), Color(0xFFEF5350)],
    quote: "Kalbin seni seviyor ama bu tempoya daha ne kadar dayanır?",
    maxDamageYears: 20,
    baseDamagePerYear: 0.04, // %4/yıl
    heavySmokerMultiplier: 1.3,
    recoveryDays: 5475, // 15 yıl (ACS)
    source: "ACS, WHO",
  ),
  OrganDamageConfig(
    title: "Kan Dolaşımı",
    icon: Icons.bloodtype_rounded,
    colors: [Color(0xFFF0C987), Color(0xFFDBB06E)],
    quote: "Damarların giderek sertleşiyor, her sigara bir çivi daha.",
    maxDamageYears: 15,
    baseDamagePerYear: 0.045, // %4.5/yıl
    heavySmokerMultiplier: 1.3,
    recoveryDays: 1825, // 5 yıl (Surgeon General)
    source: "Surgeon General (2014), CDC",
  ),
  OrganDamageConfig(
    title: "Beyin",
    icon: Icons.psychology_rounded,
    colors: [Color(0xFFB8C5E8), Color(0xFF8FA4D4)],
    quote: "Her nefeste beynine daha az oksijen gidiyor.",
    maxDamageYears: 20,
    baseDamagePerYear: 0.03, // %3/yıl
    heavySmokerMultiplier: 1.5,
    recoveryDays: 1825, // 5 yıl (ACS)
    source: "ACS, Surgeon General",
  ),
  OrganDamageConfig(
    title: "Ağız & Boğaz",
    icon: Icons.record_voice_over_rounded,
    colors: [Color(0xFFC4A8E8), Color(0xFFA87FD4)],
    quote: "Ses tellerin her dumanda biraz daha kalınlaşıyor.",
    maxDamageYears: 15,
    baseDamagePerYear: 0.05, // %5/yıl
    heavySmokerMultiplier: 1.4,
    recoveryDays: 3650, // 10 yıl (ACS)
    source: "ACS — Cancer Facts & Figures",
  ),
  OrganDamageConfig(
    title: "Mide & Sindirim",
    icon: Icons.local_dining_rounded,
    colors: [Color(0xFFA8D8B9), Color(0xFF7BC49A)],
    quote: "Miden dumanla dolunca yemek bile zor oluyor.",
    maxDamageYears: 20,
    baseDamagePerYear: 0.03, // %3/yıl
    heavySmokerMultiplier: 1.2,
    recoveryDays: 3650, // 10 yıl (CDC)
    source: "CDC — Health Effects of Smoking",
  ),
];
