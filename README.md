<p align="center">
  <img src="screenshots/cigerito_mascot.png" width="180" alt="Ciğerito — Luno Maskot" />
</p>

<h1 align="center">Luno 🫁</h1>

<p align="center">
  <strong>Sigara bırakma farkındalık uygulaması</strong><br/>
  <em>Tatlı ama acı gerçeklerle yüzleştiren, hafif alaycı bir sigara bırakma deneyimi.</em>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter" /></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase" alt="Firebase" /></a>
  <a href="https://riverpod.dev"><img src="https://img.shields.io/badge/Riverpod-State_Management-0553B1" alt="Riverpod" /></a>
  <img src="https://img.shields.io/badge/Platform-iOS_•_Android-lightgrey" alt="Platform" />
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License" />
</p>

---

## 🤔 Luno Nedir?

Luno, hâlâ sigara içen ama bırakmak isteyen kullanıcılar için tasarlanmış bir **farkındalık ve davranış yönlendirme** uygulamasıdır.

Klasik sigara bırakma uygulamalarından farklı olarak:

- ❌ Rozet, ödül, pozitif motivasyon **yok**
- ✅ Harcanan para, verilen zarar, kaybedilen zaman gibi **acı gerçeklerle yüzleştirme** var
- 🫁 **Ciğerito** — tatlı ama yaralı akciğer maskotu, sevimli ve hafif alaycı tavırlarıyla eşlik eder

> _"Her sigara hayatından 11 dakika çalar. Ama sen zaten zamanı dumanla harcamayı seviyorsun, değil mi?"_
> — Ciğerito, senin akciğer dostun

---

## 📱 Ekran Görüntüleri

|                   Ana Sayfa                   |                  Hasar Raporu                   |                     İyileşme                      |                    Kriz Modu                    |                      Geçmiş                      |
| :-------------------------------------------: | :---------------------------------------------: | :-----------------------------------------------: | :---------------------------------------------: | :----------------------------------------------: |
| <img src="screenshots/home.png" width="160"/> | <img src="screenshots/damage.png" width="160"/> | <img src="screenshots/recovery.png" width="160"/> | <img src="screenshots/crisis.png" width="160"/> | <img src="screenshots/history.png" width="160"/> |

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

| Katman           | Teknoloji                                      |
| ---------------- | ---------------------------------------------- |
| Framework        | Flutter (cross-platform)                       |
| State Management | Riverpod                                       |
| Routing          | GoRouter                                       |
| Backend          | Firebase (Firestore, Auth, Analytics)          |
| Mimari           | Feature-first + Lightweight Clean Architecture |
| Veri Katmanı     | Repository Pattern                             |
| Font             | Nunito (Google Fonts)                          |

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

| Özellik     | Değer                                |
| ----------- | ------------------------------------ |
| Ton         | Tatlı, hafif kara mizahi, iğneleyici |
| Renk Paleti | Pastel pembe + yeşil                 |
| Primary     | `#E8A0BF`                            |
| Success     | `#A8D8B9`                            |
| Background  | `#FAF8F5`                            |
| Tema        | Light + Dark                         |
| UI Stili    | Kart bazlı, sade, akıcı              |

> Detaylı tema referansı için → [tema.md](tema.md)

---

## 🚀 Kurulum

```bash
# Repository'yi klonla
git clone https://github.com/dogualagoz/cigeretto-quit-smoking-app.git
cd cigeretto-quit-smoking-app

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

<p align="center">
  <strong>Ciğerito seninle birlikte.</strong> 🫁<br/>
  <em>"Bırakma yolculuğun zor olabilir. Ama en azından yalnız değilsin... Ben de nefes alamıyorum."</em>
</p>
