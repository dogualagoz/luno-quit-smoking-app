# Luno — Görev Listesi

## Faz 0 — Setup

- [x] Klasör yapısını oluştur (`core/`, `features/`, `services/`)
- [x] Gerekli paketleri [pubspec.yaml](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/pubspec.yaml)'a ekle
- [x] `core/theme/app_colors.dart` — Renk token'ları
- [x] `core/theme/app_text_styles.dart` — Tipografi ölçeği
- [x] `core/theme/app_spacing.dart` — Spacing + radius sabitleri
- [x] `core/theme/app_theme.dart` — ThemeData (light + dark)
- [x] `main.dart` — Entry point
- [x] `app.dart` — MaterialApp + ProviderScope + GoRouter
- [x] `core/router/app_router.dart` — GoRouter yapılandırması
- [x] Bottom Navigation Shell (6 tab, MVP'de olmayanlar "yakında")
- [ ] `core/constants/app_constants.dart` — Sabit değerler

## Faz 1 — Foundation (Temel Bileşenler)

- [x] `core/widgets/luno_card.dart` — Standart kart widget
- [ ] `core/widgets/luno_button.dart` — CTA butonları (primary, success, disabled)
- [x] `core/widgets/stat_card.dart` — İstatistik kartı
- [x] `core/widgets/stat_grid.dart` — İstatistik gridi
- [x] `core/widgets/speech_bubble.dart` — Konuşma balonu
- [ ] `core/widgets/cigerito_mascot.dart` — Maskot widget (modlar)
- [ ] Firebase initialization setup
- [ ] `services/firebase/firebase_auth_service.dart` — Anonymous Auth
- [ ] `services/local_storage/shared_prefs_service.dart` — Local storage
- [ ] `core/providers/firebase_providers.dart` — Global provider'lar

## Faz 2 — MVP Ekranları

- [ ] Onboarding akışı UI
- [ ] Onboarding veri kayıt mantığı (provider + repository)
- [ ] `features/onboarding/data/models/user_profile.dart` — Model
- [x] `features/main/presentation/widgets/main_header.dart` — Sayfa başlığı
- [x] Dashboard ekranı — summary bar
- [x] Dashboard ekranı — stat grid (para, sigara, zaman, zarar)
- [x] Dashboard ekranı — mascot section + speech bubble
- [x] Dashboard ekranı — recovery progress bar
- [x] Dashboard ekranı — motivasyon kartı (quote card)
- [ ] Dashboard provider + repository
- [ ] Hasar Raporu — genel hasar skoru
- [ ] Hasar Raporu — organ kartları (akciğer, kalp, beyin, cilt vb.)
- [ ] Hasar Raporu — provider + repository
- [ ] `features/damage/data/models/damage_constants.dart` — Hasar sabitleri
- [ ] Ayarlar ekranı — profil bilgileri
- [ ] Ayarlar ekranı — tema geçişi (light/dark)
- [ ] Ayarlar provider + repository

## Faz 3 — Polish

- [ ] Animasyonlar ve micro-interactions
- [ ] Firebase Analytics event'leri
- [ ] Error handling iyileştirmesi
- [x] Coming soon placeholder ekranları (İyileşme, Kriz, Geçmiş)
- [ ] Final derleme + test

## Post-MVP

- [ ] Geçmiş & Kayıt ekranı
- [ ] İyileşme Yolculuğu ekranı
- [ ] Kriz Modu ekranı
- [ ] Push Notifications altyapısı
- [ ] Gerçek Authentication (email/Google)
- [ ] AI özellikleri
- [ ] Ödeme sistemi
