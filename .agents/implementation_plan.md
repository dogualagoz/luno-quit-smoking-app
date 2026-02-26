# Luno — Sigara Bırakma Farkındalık Uygulaması

Hâlâ sigara içen ama bırakmak isteyen kullanıcılar için tasarlanmış bir farkındalık ve davranış yönlendirme uygulaması. Klasik quit app'lerden farklı olarak, pozitif motivasyon yerine **yüzleştirme** odaklı bir deneyim sunuyor. Tatlı ama hafif iğneleyici bir tonu var.

**Maskot:** Ciğerito 🫁 (tatlı ama yaralı akciğer — sevimli, hafif alaycı)

---

## Proje Özeti

| Başlık           | Değer                                          |
| ---------------- | ---------------------------------------------- |
| Proje Adı        | **Luno**                                       |
| Maskot           | Cigerito                                       |
| Framework        | Flutter (cross-platform: iOS + Android)        |
| Backend          | Firebase (Firestore, Auth, Analytics)          |
| State Management | Riverpod                                       |
| Routing          | GoRouter                                       |
| Mimari           | Feature-first + Lightweight Clean Architecture |
| Veri Katmanı     | Repository Pattern                             |
| Font             | Nunito (Google Fonts)                          |
| Tema             | Pastel pembe/yeşil, light/dark desteği         |

---

## MVP Kapsamı

### ✅ MVP'de Olacaklar

| #   | Özellik                     | Açıklama                                                                                                  |
| --- | --------------------------- | --------------------------------------------------------------------------------------------------------- |
| 1   | **Onboarding**              | İlk kullanım soruları: günlük sigara, içme süresi, paket fiyatı, bırakma planı                            |
| 2   | **Ana Sayfa (Dashboard)**   | İçilen sigara, harcanan para, kaybedilen zaman, verilen zarar, toparlanma bar'ı, maskot + konuşma balonu  |
| 3   | **Zararlar (Hasar Raporu)** | Organ bazlı hasar skoru (akciğer, kalp, beyin, cilt vb.), genel hasar yüzdesi, iğneleyici mesajlar        |
| 4   | **Ayarlar**                 | Profil bilgileri düzenleme, tema (light/dark), bildirim tercihleri (altyapı hazır, aktif değil), hakkında |
| 5   | **Anonim Auth**             | Firebase Anonymous Authentication                                                                         |
| 6   | **Firebase Analytics**      | Temel event tracking                                                                                      |
| 7   | **Bottom Navigation**       | 6 tab yapısı (MVP'de aktif olmayanlar "yakında" etiketi ile)                                              |

### 📋 Post-MVP (Sonraki Fazlar)

| #   | Özellik                                  | Öncelik |
| --- | ---------------------------------------- | ------- |
| 1   | **Geçmiş & Kayıt**                       | Yüksek  |
| 2   | **İyileşme Yolculuğu**                   | Yüksek  |
| 3   | **Kriz Modu**                            | Yüksek  |
| 4   | **Push Notifications**                   | Orta    |
| 5   | **Gerçek Authentication** (email/Google) | Orta    |
| 6   | **AI Özellikleri**                       | Düşük   |
| 7   | **Ödeme Sistemi**                        | Düşük   |

---

## Teknik Mimari

### Mimari Yaklaşım: Feature-First + Hafif Clean Architecture

```
Feature-first: Her özellik kendi klasöründe yaşar
Clean Architecture (hafif): presentation → application → data
Repository Pattern: Tüm dış veri kaynaklarına tek kapı
```

Her feature'da 3 katman:

- **presentation/** — Ekranlar ve widget'lar
- **application/** — Riverpod provider'ları ve iş mantığı
- **data/** — Repository ve model sınıfları

> [!IMPORTANT]
> Abartılı abstraction yapmıyoruz — use case katmanı yok. Provider doğrudan repository çağırır. Okunabilirlik ve performans öncelikli.

### State Management: Riverpod

- `flutter_riverpod` + `riverpod_annotation` (code generation)
- Her feature kendi provider'larını tutar
- Global state (auth, theme) `core/` altında
- `AsyncValue` ile loading/error/data yönetimi

### Routing: GoRouter

- `go_router` paketi
- Route tanımları merkezi bir dosyada
- Bottom navigation ile `StatefulShellRoute`
- Guard: onboarding tamamlanmış mı kontrolü

### Analytics Tavsiyesi: Firebase Analytics

> [!NOTE]
> Firebase zaten kullanıyoruz, en doğal seçim **Firebase Analytics**. Paket: `firebase_analytics`.
> MVP'de track edeceğimiz olaylar:
>
> - `onboarding_completed` — onboarding bittiğinde
> - `screen_view` — her ekran geçişi (GoRouter observer ile otomatik)
> - `damage_report_viewed` — hasar raporu görüntülendiğinde
> - `settings_changed` — ayar değiştirildiğinde
>
> Karmaşık custom dashboard gerekmiyorsa Firebase Console yeterli. İlerleyen aşamada Mixpanel veya Amplitude'a geçebiliriz.

---

## Klasör Yapısı

```
lib/
├── app.dart                          # MaterialApp + GoRouter + Riverpod
├── main.dart                         # Entry point + Firebase init
│
├── core/                             # Paylaşılan altyapı
│   ├── constants/                    # Sabit değerler
│   │   ├── app_constants.dart        # Uygulama sabitleri
│   │   └── string_constants.dart     # Metin sabitleri
│   ├── theme/                        # Tema sistemi
│   │   ├── app_theme.dart            # ThemeData (light + dark)
│   │   ├── app_colors.dart           # Renk token'ları
│   │   ├── app_text_styles.dart      # Tipografi ölçeği
│   │   └── app_spacing.dart          # Spacing + radius sabitler
│   ├── router/                       # GoRouter yapılandırması
│   │   └── app_router.dart
│   ├── providers/                    # Global provider'lar
│   │   └── firebase_providers.dart
│   └── widgets/                      # Paylaşılan widget'lar
│       ├── cigerito_mascot.dart       # Maskot widget
│       ├── luno_card.dart             # Standart kart
│       ├── luno_button.dart           # CTA butonları
│       ├── stat_card.dart             # İstatistik kartı
│       └── speech_bubble.dart         # Konuşma balonu
│
├── features/                         # Feature-first modüller
│   ├── onboarding/
│   │   ├── presentation/
│   │   │   ├── onboarding_screen.dart
│   │   │   └── widgets/
│   │   ├── application/
│   │   │   └── onboarding_provider.dart
│   │   └── data/
│   │       ├── onboarding_repository.dart
│   │       └── models/
│   │           └── user_profile.dart
│   │
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   ├── dashboard_screen.dart
│   │   │   └── widgets/
│   │   │       ├── summary_bar.dart
│   │   │       ├── stat_grid.dart
│   │   │       ├── recovery_progress.dart
│   │   │       └── mascot_section.dart
│   │   ├── application/
│   │   │   └── dashboard_provider.dart
│   │   └── data/
│   │       ├── dashboard_repository.dart
│   │       └── models/
│   │           └── dashboard_stats.dart
│   │
│   ├── damage/
│   │   ├── presentation/
│   │   │   ├── damage_screen.dart
│   │   │   └── widgets/
│   │   │       ├── damage_score_card.dart
│   │   │       ├── organ_damage_card.dart
│   │   │       └── damage_progress_bar.dart
│   │   ├── application/
│   │   │   └── damage_provider.dart
│   │   └── data/
│   │       ├── damage_repository.dart
│   │       └── models/
│   │           ├── organ_damage.dart
│   │           └── damage_constants.dart
│   │
│   └── settings/
│       ├── presentation/
│       │   ├── settings_screen.dart
│       │   └── widgets/
│       ├── application/
│       │   └── settings_provider.dart
│       └── data/
│           └── settings_repository.dart
│
└── services/                         # Dış servis adaptörleri
    ├── firebase/
    │   ├── firebase_auth_service.dart
    │   └── firestore_service.dart
    └── local_storage/
        └── shared_prefs_service.dart
```

---

## Temel Veri Modeli

### UserProfile (Source of Truth — Firestore)

```
- uid: String (Firebase Auth UID)
- nickname: String (kullanıcı adı/lakap)
- dailyCigarettes: int (günlük sigara sayısı)
- smokingYears: int (kaç yıldır içiyor)
- packPrice: double (paket fiyatı ₺)
- cigarettesPerPack: int (bir pakette kaç tane)
- quitDate: DateTime? (bırakma tarihi, null ise henüz bırakmamış)
- motivation: String (bırakma motivasyonu)
- createdAt: DateTime
- updatedAt: DateTime
```

### DashboardStats (Derived — Hesaplanan)

```
- totalCigarettes: int (toplam içilen sigara)
- totalMoneySpent: double (toplam harcanan para)
- totalDaysLost: double (kaybedilen gün)
- damageLevel: String (zarar seviyesi: düşük/orta/yüksek)
- smokingDurationDays: int (kaç gündür içiyor)
- recoveryPercentage: double (toparlanma yüzdesi — bıraktıysa)
```

### OrganDamage (Derived — Hesaplanan)

```
- organName: String (akciğer, kalp, beyin vb.)
- organIcon: String (emoji veya asset)
- damagePercentage: double
- description: String (kısa açıklama)
- sarcasticMessage: String (iğneleyici mesaj)
- damageColor: Color (yüzdeye göre renk)
```

> [!NOTE]
> `DashboardStats` ve `OrganDamage` Firestore'a yazılmaz — `UserProfile`'dan runtime'da hesaplanır. Bu sayede veri tutarsızlığı riski sıfır.

---

## Geliştirme Fazları

### Faz 0 — Setup (Bu adım)

1. Klasör yapısını oluştur
2. Gerekli paketleri `pubspec.yaml`'a ekle
3. Tema dosyalarını oluştur (`app_theme.dart`, `app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart`)
4. `main.dart` ve `app.dart` temel yapısını kur
5. GoRouter temel routing'i kur
6. Bottom navigation shell'i oluştur

### Faz 1 — Foundation (Temel Bileşenler)

1. Paylaşılan widget'ları oluştur (`LunoCard`, `LunoButton`, `StatCard`, `SpeechBubble`)
2. Ciğerito maskot widget'ını oluştur
3. Firebase initialization
4. Anonymous Auth bağlantısı
5. SharedPreferences altyapısı

### Faz 2 — MVP Ekranları

1. Onboarding akışı (sorular + veri kayıt)
2. Dashboard ekranı (summary bar, stat grid, mascot section, recovery progress)
3. Hasar Raporu ekranı (organ kartları, genel skor)
4. Ayarlar ekranı (profil düzenleme, tema, hakkında)

### Faz 3 — Polish

1. Animasyonlar ve micro-interactions
2. Firebase Analytics event'leri
3. Error handling iyileştirmesi
4. Coming soon ekranları (İyileşme, Kriz, Geçmiş)

### Faz 4 — Post-MVP (Sonra)

1. Geçmiş & Kayıt
2. İyileşme Yolculuğu
3. Kriz Modu
4. Push Notifications
5. Gerçek Authentication

---

## Riskler ve Dikkat Edilecekler

| Risk                    | Etki                                          | Önlem                                                         |
| ----------------------- | --------------------------------------------- | ------------------------------------------------------------- |
| Hasar hesaplama formülü | Tıbbi doğruluk vs. kullanıcı deneyimi dengesi | Formülü sade tut, "tahmini" olduğunu vurgula, disclaimer ekle |
| Maskot asset'leri       | SVG/Lottie yoksa statik görsel gerekir        | İlk başta basit widget ile başla, sonra asset ekle            |
| Anonim auth veri kaybı  | Telefon değiştirince veri gidebilir           | Onboarding'de uyar, post-MVP'de hesap bağlama ekle            |
| Scope creep             | Post-MVP özellikleri MVP'ye sızabilir         | MVP sınırını kesin koru, "yakında" etiketiyle motive et       |
| Kara mizah tonu         | Çok iğneleyici olursa kullanıcı kaçar         | Mesajları review et, sevimli ≥ alaycı dengesi koru            |
| Firestore maliyeti      | Gereksiz read/write                           | Hesaplanan verileri Firestore'a yazma, local cache kullan     |

> [!WARNING]
> **Anonim kullanıcı riski:** Firebase anonymous auth ile kullanıcı uygulamayı silip yeniden kurduğunda verisi gider. Bunu onboarding'de şeffaf şekilde belirt ve post-MVP'de email/Google hesap bağlama mutlaka ekle.

---

## Verification Plan

### Derleme Testi

```bash
cd /Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app
flutter pub get
flutter analyze
```

### Manuel Doğrulama

Her fazın sonunda:

- `flutter run` ile bir cihazda (veya emülatörde) uygulamayı çalıştır
- Ekranları gözle kontrol et
- Bottom navigation geçişlerini test et
- Light/dark tema geçişini kontrol et
