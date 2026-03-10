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
- [x] `core/router/app_router.dart` — GoRouter yapılandırması (onboarding, auth, main shell rotaları)
- [x] Bottom Navigation Shell (`core/widgets/main_shell.dart`)
- [x] Router'ı `app.dart`'a bağla
- [x] `core/constants/app_constants.dart` — İş kuralları ve mock veri sabitleri

## Faz 1 — Paylaşılan Widget'lar ✅

- [x] `core/widgets/luno_card.dart` — Standart kart widget
- [x] `core/widgets/stat_card.dart` — İstatistik kartı
- [x] `core/widgets/speech_bubble.dart` — Konuşma balonu
- [x] `core/widgets/stat_grid.dart` — İstatistik grid bileşeni
- [x] `core/widgets/recovery_progress.dart` — Toparlanma progress bar
- [x] `core/widgets/luno_progress_bar.dart` — Genel amaçlı progress bar
- [x] `core/widgets/quote_card.dart` — Alıntı/mesaj kartı
- [x] `core/widgets/swipeable_damage_cards.dart` — Kaydırılabilir hasar kartları
- [x] `core/widgets/luno_button.dart` — CTA butonları
- [x] `core/widgets/cigerito_mascot.dart` — Maskot widget (MascotMode: normal/happy/proud/sad/worried/sarcastic)

## Faz 2 — Ana Sayfa (Main Screen)

- [x] `features/main/presentation/main_screen.dart` — Ana ekran iskeleti
- [x] `features/main/presentation/widgets/main_header.dart` — Üst başlık
- [x] Ana Sayfa — swipeable damage cards
- [x] Ana Sayfa — speech bubble (maskot ile birlikte)
- [x] Ana Sayfa — stat grid (mock data ile)
- [x] Ana Sayfa — recovery progress (mock data ile)
- [x] Ana Sayfa — quote card
- [ ] Ana Sayfa — Ciğerito maskot bölümü (şu an `Icons.monitor_heart` placeholder var)
- [ ] Ana Sayfa — provider bağlantısı (Hive'dan gerçek UserProfile verisi)

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

## Faz 5 — Veri Katmanı & Onboarding ✅

- [x] `services/local_storage/hive_service.dart` — Hive başlatma ve box yönetimi
- [x] `features/onboarding/data/models/user_profile.dart` — UserProfile modeli (copyWith, toJson, fromJson dahil)
- [x] `features/onboarding/data/models/user_profile.g.dart` — Hive adapter (build_runner ile üretildi)
- [x] `features/onboarding/data/onboarding_repository.dart` — Repository (save/get/delete/isCreated)
- [x] `features/onboarding/application/onboarding_provider.dart` — Provider (completeOnboarding + updateProfileAuth)
- [x] `features/onboarding/presentation/onboarding_screen.dart` — 10 adımlık onboarding akışı
- [x] Onboarding adım widget'ları (intro, legal, smokingYears, dailyCigarettes, packetPrice, tryingCount, reasons, triggerMoments, finalLegal, summary)
- [ ] Router guard — uygulama açılışında "onboarding bitti mi?" kontrolü (şu an her açılışta onboarding gösteriyor)

## Faz 5.5 — Auth Ekranları ✅

- [x] `features/auth/presentation/auth_selection_screen.dart` — Apple / Google / Email / Anonim seçim ekranı
- [x] `features/auth/presentation/email_login_screen.dart` — E-posta giriş ekranı
- [x] `features/auth/presentation/email_register_screen.dart` — Hesap oluşturma ekranı
- [x] Onboarding → Auth Selection yönlendirmesi
- [x] Auth Selection → Email Login / Register yönlendirmesi
- [ ] Auth ekranları → Ana Sayfa yönlendirmesi (şu an context.go('/') ile gidiyor, Firebase Auth sonrası düzelecek)

## Faz 6 — Firebase & Gerçek Auth 🎯 (Sıradaki)

- [ ] Firebase projesi oluştur (Firebase Console)
- [ ] FlutterFire CLI ile `firebase_options.dart` yapılandır
- [ ] `firebase_core`, `firebase_auth` paketlerini ekle
- [ ] `main.dart`'ta Firebase.initializeApp() çağrısı
- [ ] `features/auth/application/auth_provider.dart` — AuthNotifier (signInWithGoogle, signInWithApple, signInWithEmail, signInAnonymously, signOut)
- [ ] `features/auth/data/auth_repository.dart` — Firebase Auth işlemleri
- [ ] Giriş başarısında `updateProfileAuth(userId, email)` ile Hive güncelleme
- [ ] Router guard — `isProfileCreated()` && `isSignedIn()` kontrolü
- [ ] `firebase_firestore` paketi ekle
- [ ] `features/onboarding/data/firestore_sync_service.dart` — Hive → Firestore senkronizasyonu

## Faz 7 — Provider Bağlantıları (Faz 6 bittikten sonra)

- [ ] Dashboard provider → Hive'dan UserProfile oku, ana sayfaya bağla
- [ ] Hasar provider → UserProfile'dan organ hasarlarını hesapla
- [ ] Settings provider + repository — profil bilgilerini okuma/kaydetme
- [ ] Ayarlar — profil bilgileri düzenleme (packPrice, dailyCigarettes vb. güncellenebilir)
- [ ] Ayarlar — tema geçişi (light/dark)

## Faz 8 — Polish & Placeholder Ekranlar

- [ ] Coming soon ekranları — İyileşme, Kriz, Geçmiş (şu an `_PlaceholderScreen` var)
- [ ] Animasyonlar ve micro-interactions
- [ ] Error handling iyileştirmesi
- [ ] Firebase Analytics event'leri (`onboarding_completed`, `damage_report_viewed` vb.)

## Post-MVP

- [ ] Geçmiş & Kayıt ekranı (tam versiyon)
- [ ] İyileşme Yolculuğu ekranı
- [ ] Kriz Modu ekranı
- [ ] Push Notifications
- [ ] AI özellikleri (Ciğerito konuşmaları, öneri motoru)
- [ ] Ödeme sistemi
