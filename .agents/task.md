# Luno — Görev Listesi

> **Strateji:** Önce Ana Sayfa (Dashboard) ve Ayarlar'ı front+back tamamen bitir,
> sonra diğer sayfalara geç. Hızlı çalışan ürün öncelikli.

## Faz 0 — Setup ✅

- [x] Klasör yapısını oluştur (`core/`, `features/`, `services/`)
- [x] Gerekli paketleri `pubspec.yaml`'a ekle (ihtiyaç oldukça)
- [x] `core/theme/app_colors.dart` — Renk token'ları
- [x] `core/theme/app_text_styles.dart` — Tipografi ölçeği
- [x] `core/theme/app_spacing.dart` — Spacing sabitleri
- [x] `core/theme/app_radius.dart` — Radius sabitleri
- [x] `core/theme/app_theme.dart` — ThemeData (light + dark + shadows)
- [x] `main.dart` — Entry point
- [x] `app.dart` — MaterialApp + tema bağlantısı
- [x] `go_router` paketi eklendi
- [x] `core/router/app_router.dart` — GoRouter yapılandırması
- [x] Bottom Navigation Shell (`core/widgets/main_shell.dart`)
- [x] Router'ı `app.dart`'a bağla

## Faz 1 — Paylaşılan Widget'lar ✅

- [x] `core/widgets/luno_card.dart` — Standart kart widget
- [x] `core/widgets/stat_card.dart` — İstatistik kartı
- [x] `core/widgets/speech_bubble.dart` — Konuşma balonu
- [x] `core/widgets/stat_grid.dart` — İstatistik grid bileşeni
- [x] `core/widgets/recovery_progress.dart` — Toparlanma progress bar
- [x] `core/widgets/luno_progress_bar.dart` — Genel amaçlı progress bar
- [x] `core/widgets/quote_card.dart` — Alıntı/mesaj kartı
- [x] `core/widgets/swipeable_damage_cards.dart` — Kaydırılabilir hasar kartları
- [ ] `core/widgets/luno_button.dart` — CTA butonları
- [ ] `core/widgets/cigerito_mascot.dart` — Maskot widget

## Faz 2 — Ana Sayfa (Main Screen) — Front

- [x] `features/main/presentation/main_screen.dart` — Ana ekran iskeleti
- [x] `features/main/presentation/widgets/main_header.dart` — Üst başlık
- [ ] Ana Sayfa — summary bar (statik/mock)
- [ ] Ana Sayfa — mascot section + speech bubble
- [ ] Ana Sayfa — provider bağlantısı (gerçek data)

## Faz 3 — Hasar Raporu (Damage) — Front ✅

- [x] `features/damage/presentation/damage_screen.dart` — Hasar ekranı
- [x] `features/damage/widgets/damage_card.dart` — Organ hasar kartı
- [x] `features/damage/widgets/damage_header.dart` — Üst başlık
- [x] `features/damage/widgets/total_damage_card.dart` — Genel hasar kartı
- [x] `core/constants/damage_model.dart` — Hasar veri modeli + sabitler

## Faz 4 — Ayarlar (Settings) — Front ✅

- [x] `features/settings/presentation/pages/settings_page.dart` — Ayarlar ekranı
- [x] `features/settings/presentation/widgets/settings_header.dart`
- [x] `features/settings/presentation/widgets/profile_card.dart`
- [x] `features/settings/presentation/widgets/settings_menu_tile.dart`
- [x] `features/settings/presentation/widgets/settings_slider.dart`
- [x] `features/settings/presentation/widgets/settings_toggle_tile.dart`

## Faz 5 — Veri Katmanı & Onboarding (Sıradaki 🎯)

- [ ] `core/constants/app_constants.dart` — Anahtar string sabitleri (SharedPrefs key'leri)
- [ ] `services/local_storage/shared_prefs_service.dart` — Local storage altyapısı
- [ ] `features/onboarding/data/models/user_profile.dart` — UserProfile modeli
- [ ] `features/onboarding/data/onboarding_repository.dart` — Repository
- [ ] `features/onboarding/application/onboarding_provider.dart` — Provider
- [ ] `features/onboarding/presentation/onboarding_screen.dart` — UI (sorular akışı)
- [ ] Router guard — onboarding tamamlandı mı kontrolü

## Faz 6 — Provider Bağlantıları

- [ ] Dashboard provider → SharedPrefs'ten UserProfile oku
- [ ] Hasar provider → UserProfile'dan organ hasarlarını hesapla
- [ ] Settings provider + repository
- [ ] Ayarlar — profil bilgileri düzenleme (kaydet/oku)
- [ ] Ayarlar — tema geçişi (light/dark)

## Faz 7 — Polish & Firebase

- [ ] Firebase initialization + Anonymous Auth
- [ ] Firebase Analytics event'leri (`onboarding_completed`, `damage_report_viewed`, vb.)
- [ ] Animasyonlar ve micro-interactions
- [ ] Error handling iyileştirmesi
- [ ] Coming soon placeholder ekranları (İyileşme, Kriz, Geçmiş)

## Post-MVP

- [ ] Geçmiş & Kayıt ekranı
- [ ] İyileşme Yolculuğu ekranı
- [ ] Kriz Modu ekranı
- [ ] Push Notifications
- [ ] Gerçek Authentication (email/Google)
- [ ] AI özellikleri
- [ ] Ödeme sistemi
