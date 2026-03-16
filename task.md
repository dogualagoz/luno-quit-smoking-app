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
- [x] `core/router/app_router.dart` — GoRouter yapılandırması (Auth Gate dahil)
- [x] Bottom Navigation Shell (6 tab, MVP'de olmayanlar "yakında")
- [x] `core/constants/app_constants.dart` — Sabit değerler

## Faz 1 — Foundation (Temel Bileşenler)

- [x] `core/widgets/luno_card.dart` — Standart kart widget
- [x] `core/widgets/luno_button.dart` — CTA butonları (primary, success, disabled)
- [x] `core/widgets/stat_card.dart` — İstatistik kartı
- [x] `core/widgets/stat_grid.dart` — İstatistik gridi
- [x] `core/widgets/speech_bubble.dart` — Konuşma balonu
- [x] `core/widgets/cigerito_mascot.dart` — Maskot widget (modlar)
- [x] Firebase initialization setup
- [x] `features/auth/data/auth_repository.dart` — Authentication Logic
- [x] `services/local_storage/hive_service.dart` — Local storage (Hive)
- [x] `core/providers/firebase_providers.dart` — Global provider'lar (Auth, Firestore)

## Faz 2 — MVP Ekranları

- [x] Onboarding akışı UI
- [x] Onboarding veri kayıt mantığı (Hive + Firestore)
- [x] `features/onboarding/data/models/user_profile.dart` — Model
- [x] `features/main/presentation/widgets/main_header.dart` — Sayfa başlığı
- [x] Dashboard ekranı — summary bar
- [x] Dashboard ekranı — stat grid (para, sigara, zaman, zarar)
- [x] Dashboard ekranı — mascot section + speech bubble
- [x] Dashboard ekranı — recovery progress bar
- [x] Dashboard ekranı — motivasyon kartı (quote card)
- [x] Dashboard: Dummy verileri gerçek verilerle bağla (Provider + Calculator)
- [x] Hasar Raporu: Swipeable kartları gerçek hasar verilerine bağla (Dashboard ile entegre)
- [x] Hasar Raporu: Organ bazlı iyileşme sürelerini hesapla
- [x] `lib/core/constants/damage_model.dart` — Hasar sabitleri (model/data)
- [x] Ayarlar ekranı — profil bilgileri
- [x] Ayarlar ekranı — tema geçişi (light/dark)
- [x] Ayarlar provider + repository (çıkış yapma dahil)
- [x] Hakkında sayfası — disclaimer, bilimsel kaynaklar, iyileşme zaman çizelgesi

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
- [x] Gerçek Authentication (email/Google)
- [ ] AI özellikleri
- [ ] Ödeme sistemi
