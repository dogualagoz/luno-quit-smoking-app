# Luno — Görev Listesi

> **Strateji:** Önce Ana Sayfa (Dashboard) ve Ayarlar'ı front+back tamamen bitir,
> sonra diğer sayfalara geç. Hızlı çalışan ürün öncelikli.

## Faz 0 — Setup

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
- [x] Bottom Navigation Shell (6 tab, aktif olmayanlar "yakında")
- [x] Router'ı `app.dart`'a bağla

## Faz 1 — Ana Sayfa (Dashboard) — Front + Back

- [x] `core/widgets/luno_card.dart` — Standart kart widget
- [x] `core/widgets/luno_button.dart` — CTA butonları
- [x] `core/widgets/stat_card.dart` — İstatistik kartı
- [ ] `core/widgets/speech_bubble.dart` — Konuşma balonu
- [ ] `core/widgets/cigerito_mascot.dart` — Maskot widget
- [ ] Onboarding akışı (sorular + veri kayıt)
- [ ] `features/dashboard/presentation/dashboard_screen.dart` — UI
- [x] Dashboard — summary bar
- [x] Dashboard — stat grid (para, sigara, zaman, zarar)
- [ ] Dashboard — mascot section + speech bubble
- [ ] Dashboard — recovery progress bar
- [ ] Dashboard provider + repository
- [ ] `services/local_storage/shared_prefs_service.dart` — Local storage
- [ ] `features/onboarding/data/models/user_profile.dart` — Model

## Faz 2 — Ayarlar — Front + Back

- [ ] `features/settings/presentation/settings_screen.dart` — UI
- [ ] Ayarlar — profil bilgileri düzenleme
- [ ] Ayarlar — tema geçişi (light/dark)
- [ ] Ayarlar — bildirim tercihleri (altyapı hazır, aktif değil)
- [ ] Ayarlar — hakkında bölümü
- [ ] Ayarlar provider + repository

## Faz 3 — Diğer Sayfalar

- [ ] Hasar Raporu ekranı (organ kartları, genel skor)
- [ ] Hasar provider + repository
- [ ] Coming soon placeholder ekranları (İyileşme, Kriz, Geçmiş)

## Faz 4 — Polish & Firebase

- [ ] Firebase initialization + Anonymous Auth
- [ ] Firebase Analytics event'leri
- [ ] Animasyonlar ve micro-interactions
- [ ] Error handling iyileştirmesi

## Post-MVP

- [ ] Geçmiş & Kayıt ekranı
- [ ] İyileşme Yolculuğu ekranı
- [ ] Kriz Modu ekranı
- [ ] Push Notifications
- [ ] Gerçek Authentication (email/Google)
- [ ] AI özellikleri
- [ ] Ödeme sistemi
