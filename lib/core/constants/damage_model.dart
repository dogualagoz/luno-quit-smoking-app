// lib/core/constants/app_constants.dart dosyasına eklenecek kısım

import 'package:flutter/material.dart';

class OrganDamageModel {
  final String title;
  final String description;
  final String quote;
  final double damage;
  final IconData icon;
  final List<Color> colors;

  const OrganDamageModel({
    required this.title,
    required this.description,
    required this.quote,
    required this.damage,
    required this.icon,
    required this.colors,
  });
}

List<OrganDamageModel> organDamages = [
  const OrganDamageModel(
    title: "Akciğerler",
    description: "Kapasite %34 azalmış",
    quote: "Merdiven çıkarken nefes nefese kalman tesadüf değil.",
    damage: 0.72,
    icon: Icons.air_rounded,
    colors: [Color(0xFFE8A0BF), Color(0xFFD4789E)],
  ),
  const OrganDamageModel(
    title: "Kalp",
    description: "Nabız ortalaması yükselmiş",
    quote: "Kalbin seni seviyor ama bu tempoya daha ne kadar dayanır?",
    damage: 0.58,
    icon: Icons.favorite_rounded,
    colors: [Color(0xFFE57373), Color(0xFFEF5350)],
  ),
  const OrganDamageModel(
    title: "Kan Dolaşımı",
    description: "Damar sertliği artmış",
    quote: "Damarların bir 80 yaşındakinden pek de farklı değil artık.",
    damage: 0.52,
    icon: Icons.bloodtype_rounded,
    colors: [Color(0xFFE57373), Color(0xFFEF5350)],
  ),
  const OrganDamageModel(
    title: "Beyin",
    description: "Oksijen yetersizliği riski",
    quote:
        "Düşünme kapasiten düşüyor ama zaten sigara içmeye karar verdin, şaşırtmadı",
    damage: 0.35,
    icon: Icons.handyman_rounded,
    colors: [Color(0xFFB8C5E8), Color(0xFF8FA4D4)],
  ),
];
