<![CDATA[<div align="center">

<img src="screenshots/cigerito_mascot.png" width="180" alt="Ciğerito — Luno Maskot" />

# Luno 🫁

**Sigara bırakma farkındalık uygulaması**

*Tatlı ama acı gerçeklerle yüzleştiren, hafif alaycı bir sigara bırakma deneyimi.*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-State_Management-0553B1)](https://riverpod.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS_•_Android-lightgrey)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()

</div>

---

## 🤔 Luno Nedir?

Luno, hâlâ sigara içen ama bırakmak isteyen kullanıcılar için tasarlanmış bir **farkındalık ve davranış yönlendirme** uygulamasıdır.

Klasik sigara bırakma uygulamalarından farklı olarak:
- ❌ Rozet, ödül, pozitif motivasyon **yok**
- ✅ Harcanan para, verilen zarar, kaybedilen zaman gibi **acı gerçeklerle yüzleştirme** var
- 🫁 **Ciğerito** — tatlı ama yaralı akciğer maskotu, sevimli ve hafif alaycı tavırlarıyla eşlik eder

> *"Her sigara hayatından 11 dakika çalar. Ama sen zaten zamanı dumanla harcamayı seviyorsun, değil mi?"*
> — Ciğerito, senin akciğer dostun

---

## 📱 Ekran Görüntüleri

<div align="center">

| Ana Sayfa | Hasar Raporu | İyileşme | Kriz Modu | Geçmiş |
|:---------:|:------------:|:--------:|:---------:|:------:|
| <img src="screenshots/home.png" width="160"/> | <img src="screenshots/damage.png" width="160"/> | <img src="screenshots/recovery.png" width="160"/> | <img src="screenshots/crisis.png" width="160"/> | <img src="screenshots/history.png" width="160"/> |

</div>

---

## ✨ Özellikler

### 🎯 MVP (v1.0)
- **Dashboard** — Toplam sigara, harcanan para, kaybedilen zaman, zarar seviyesi
- **Hasar Raporu** — Organ bazlı hasar skoru (akciğer, kalp, beyin, cilt...)
- **Ayarlar** — Profil düzenleme, light/dark tema
- **Onboarding** — Kişiselleştirilmiş başlangıç akışı
- **Ciğerito Maskot** — Tatlı ve alaycı yorumlar, 6 farklı ruh hali

### 🔮 Sonraki Fazlar
- İyileşme Yolculuğu — Bıraktıktan sonra vücut toparlanma timeline'ı
- Kriz Modu — Sigara isteği gelince acil destek
- Geçmiş & Kayıt — Günlük sigara takibi + haftalık istatistikler
- Push Notifications — Hatırlatma ve motivasyon
- AI Özellikleri — Kişiselleştirilmiş mesajlar

---

## 🏗️ Teknik Yapı

| Katman | Teknoloji |
|--------|-----------|
| Framework | Flutter (cross-platform) |
| State Management | Riverpod |
| Routing | GoRouter |
| Backend | Firebase (Firestore, Auth, Analytics) |
| Mimari | Feature-first + Lightweight Clean Architecture |
| Veri Katmanı | Repository Pattern |
| Font | Nunito (Google Fonts) |

### Klasör Yapısı
```
lib/
├── app.dart                  # MaterialApp + GoRouter
├── main.dart                 # Entry point + Firebase init
├── core/                     # Tema, router, paylaşılan widget'lar
│   ├── theme/
│   ├── router/
│   ├── constants/
│   ├── providers/
│   └── widgets/
├── features/                 # Feature-first modüller
│   ├── onboarding/
│   ├── dashboard/
│   ├── damage/
│   └── settings/
└── services/                 # Firebase, local storage
```

---

## 🎨 Tasarım Dili

| Özellik | Değer |
|---------|-------|
| Ton | Tatlı, hafif kara mizahi, iğneleyici |
| Renk Paleti | Pastel pembe + yeşil |
| Primary | `#E8A0BF` |
| Success | `#A8D8B9` |
| Background | `#FAF8F5` |
| Tema | Light + Dark |
| UI Stili | Kart bazlı, sade, akıcı |

> Detaylı tema referansı için → [`tema.md`](tema.md)

---

## 🚀 Kurulum

```bash
# Repository'yi klonla
git clone https://github.com/your-username/luno_quit_smoking_app.git
cd luno_quit_smoking_app

# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

### Gereksinimler
- Flutter 3.x+
- Dart 3.x+
- Firebase CLI (Firebase projesi kurulumu için)

---

## 📄 Lisans

Bu proje MIT lisansı ile lisanslanmıştır.

---

<div align="center">

**Ciğerito seninle birlikte.** 🫁

*"Bırakma yolculuğun zor olabilir. Ama en azından yalnız değilsin... Ben de nefes alamıyorum."*

</div>
]]>
