# 🔬 Cigerito — Kapsamlı Uygulama İnceleme Raporu

> **Tarih:** 10 Nisan 2026 | **104 Dart dosyası incelendi**  
> TestFlight + App Store hedefi ile hazırlanmıştır.

---

## 📑 İçindekiler
1. [UI/UX & Tasarım Sorunları](#1-uiux--tasarım-sorunları)
2. [Fonksiyonellik Sorunları](#2-fonksiyonellik-sorunları)
3. [Veri Doğruluğu Sorunları](#3-veri-doğruluğu-sorunları)
4. [Mantıksal Çelişkiler](#4-mantıksal-çelişkiler)
5. [Kullanıcı Bağlılığı & Özellik Önerileri (Feature Adviser)](#5-kullanıcı-bağlılığı--özellik-önerileri)
6. [Lokalizasyon & Çoklu Dil Desteği](#6-lokalizasyon--çoklu-dil-desteği)
7. [App Store Gereksinimleri](#7-app-store-gereksinimleri)
8. [Öncelikli Aksiyon Planı](#8-öncelikli-aksiyon-planı)

---

## 1. UI/UX & Tasarım Sorunları

### 1.1 🔴 Dark Mode Desteği Kırık — Onboarding & Auth Ekranları

> [!CAUTION]
> Onboarding ve Auth ekranları dark mode'u desteklemiyor. Sabit `AppColors.lightBackground` kullanılıyor.

| Dosya | Satır | Sorun |
|---|---|---|
| [onboarding_screen.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/onboarding/presentation/onboarding_screen.dart#L102) | 102 | `backgroundColor: AppColors.lightBackground` |
| [auth_selection_screen.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/auth/presentation/auth_selection_screen.dart#L34) | 34 | `backgroundColor: AppColors.lightBackground` |
| [onboarding_screen.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/onboarding/presentation/onboarding_screen.dart#L208-L222) | 208-222 | Header ikonları sabit `AppColors.lightForeground` |

**Çözüm:** `Theme.of(context).scaffoldBackgroundColor` ve `Theme.of(context).colorScheme.onSurface` kullan.

---

### 1.2 🟡 Hata Ekranları Kullanıcı Dostu Değil

Raw hata mesajları gösteriliyor. Kullanıcı `Error: Instance of 'FirebaseException'` gibi anlamsız metinler görüyor.

| Dosya | Satır | Mevcut Kod |
|---|---|---|
| [main_screen.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/main/presentation/main_screen.dart#L134) | 134 | `Text('Hata: $err')` |
| [damage_screen.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/damage/presentation/damage_screen.dart#L133) | 133 | `Text('Error: $err')` (İngilizce!) |
| [history_screen.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/history/presentation/pages/history_screen.dart#L167) | 167 | `Text("Hata oluştu: $err")` |

**Çözüm:** Maskotlu ("Ciğerito üzgün" SVG) + açıklayıcı mesaj + "Tekrar Dene" butonu olan bir `LunoErrorWidget` oluştur.

---

### 1.3 🟡 Maskot Kullanım Fırsatları

Maskot şu an sadece ana sayfa, damage ve crisis ekranlarında var. Şu noktalarda da kullanılabilir:

| Nerede | Nasıl | Etki |
|---|---|---|
| **Hata ekranları** | Üzgün maskot + "Bir şeyler ters gitti" | Kullanıcıyı rahatlatır |
| **Boş history ekranı** | Meraklı maskot + "İlk kaydını bekliyorum" | Aksiyona yönlendirir |
| **Craving tamamlandı** | Mutlu/gururlu maskot + konfeti animasyonu | Başarı hissi verir |
| **Settings profil kartı** | Küçük maskot avatarı | Marka tutarlılığı |
| **Splash screen** | Animasyonlu maskot giriş | İlk izlenim (😎 **App Store için önemli**) |
| **Push notification (ileride)** | Maskotlu bildirim | Geri dönüş oranı artar |

---

### 1.4 🟡 Splash Screen Eksik

> [!IMPORTANT]
> Splash screen/launch screen sadece iOS'un varsayılan beyaz `LaunchScreen.storyboard`'u. TestFlight'ta ilk izlenim zayıf olacak.

**Çözüm:** `LaunchScreen.storyboard` içine maskot + gradient background ekle. Veya `flutter_native_splash` paketi kullan.

---

### 1.5 🟢 Animasyon Eksiklikleri

- **Stat kartları:** Sayılar aniden ortaya çıkıyor. `AnimatedSwitcher` veya `CountUp` animasyonu ile yumuşak geçiş eklenebilir.
- **Craving kaydı tamamlandığında:** `CongratulationsStep` basit bir metin. Konfeti veya yıldız animasyonu eklenebilir.
- **Bottom sheet açılış:** "Sigara İçtim" bottom sheet'i standart açılıyor. Slide-up + fade animasyonu önerilir.

---

## 2. Fonksiyonellik Sorunları

### 2.1 🔴 Auth Ekranındaki TOS/Privacy Linkleri Çalışmıyor

[auth_selection_screen.dart L162-186](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/auth/presentation/auth_selection_screen.dart#L162-L186):
```dart
InkWell(
  onTap: () {}, // ← BOŞ!
  child: Text('Kullanım Koşulları'),
),
InkWell(
  onTap: () {}, // ← BOŞ!
  child: Text('Gizlilik Politikası'),
),
```

TestFlight'ta sorun olmaz ama App Store review'ında **kesin RED** sebebi.

---

### 2.2 🟡 Push Notifications Toggle Çalışmıyor

[settings_page.dart L147-153](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/settings/presentation/pages/settings_page.dart#L146-L153):
```dart
SettingsToggleTile(
  title: "Hatırlatıcılar",
  value: true,              // ← Sabit true
  onChanged: (val) {
    // TODO: Push Notifications On/Off
  },
)
```

Toggle görünür ama hiçbir şey yapmıyor. **Çözüm:** Ya toggle'ı kaldır ya da fonksiyonel yap.

---

### 2.3 🟡 Ciğerito Özelleştirme Sayfası Boş

[cigerito_customization_page.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/settings/presentation/pages/cigerito_customization_page.dart) — 941 byte. Bu muhtemelen placeholder bir sayfa. Ayarlardan erişiliyor ama içeriği yoksa kullanıcıyı hayal kırıklığına uğratır.

**Çözüm:** Sayfayı kaldır veya "Yakında" etiketi ekle.

---

### 2.4 🟡 Location Step Tamamlanmamış

[location_step.dart L53](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/history/presentation/widgets/craving_steps/location_step.dart#L53):
```dart
// TODO: Implement location service
```

Craving akışında konum adımı var ama GPS servisi bağlı değil.

---

### 2.5 🟢 Share Link Geçersiz

[settings_page.dart L181](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/settings/presentation/pages/settings_page.dart#L181): `https://luno-app.com` — Bu URL muhtemelen canlı değil.

---

## 3. Veri Doğruluğu Sorunları

### 3.1 🔴 "Düne Göre" Karşılaştırma Yanlış Çalışıyor — KULLANICININ BİLDİRDİĞİ SORUN

> [!CAUTION]
> Kullanıcı: *"Bugün 7 sigara içtiğimi girdim, dün uygulamayı kullanmadım. Bana 'düne göre 7 sigara fazla içtin' diyor halbuki ben uygulamayı kullanmamıştım."*

**Sorunun kaynağı:** [today_summary_card.dart L72-85](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/history/presentation/widgets/today_summary_card.dart#L72-L85)

```dart
// Dünün karşılaştırma verilerini hesaplar
final yesterdayDate = DateTime.now().subtract(const Duration(days: 1));
final yesterdayLogs = widget.logs.where((log) {
  return log.date.year == yesterdayDate.year &&
      log.date.month == yesterdayDate.month &&
      log.date.day == yesterdayDate.day;
}).toList();
final int yesterdaySmoked = yesterdayLogs
    .where((log) => _getLogType(log) == 'slip')
    .fold(0, (sum, log) => sum + (log.smokeCount as int));
```

**Mantık hatası:** Dün log girilmemişse `yesterdaySmoked = 0` oluyor. Sonuç: `_getComparisonData` fonksiyonu "7 sigara **fazla** içtin" diyor çünkü `0` ile `7` kıyaslıyor.

**Doğru mantık:**
1. Dün log yoksa → karşılaştırma gösterme veya "Dünkü verin yok" yaz
2. Ya da "log girilmeyen günler" ile "log girilen günler" arasında ayrım yap

---

### 3.2 🔴 Log Girilmeyen Günler Baseline Olarak Hesaplanıyor

[quit_calculator.dart L253-259](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/main/application/quit_calculator.dart#L253-L259):
```dart
} else {
  // Log girilmemiş güne onboarding'deki günlük ortalamasını yaz
  liveSmoked += profile.dailyCigarettes;
}
```

Log girilmeyen günlerde `profile.dailyCigarettes` ekleniyor. Eğer kullanıcı uygulamayı 3 gün açmadıysa, 3 gün × 20 sigara = 60 sigara ekleniyor. Bu doğru bir varsayım olabilir ama kullanıcıya **hiçbir yerde bildirilmiyor**.

**Önerilen çözüm:**
- Dashboard'da "tahmini" ikonu/etiketi göster (zaten `isEstimatedToday` var ama UI'da kullanılmıyor)
- "Son 3 gündür veri girmedin. Bu süre tahmini hesaplandı" uyarısı ekle

---

### 3.3 🟡 Haftalık Ortalama Hesaplaması Çelişkili

[average_summary_card.dart L33-47](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/history/presentation/widgets/average_summary_card.dart#L33-L47):

```dart
final double currentAvg = currentWeekLogs.isEmpty
    ? 0
    : currentTotal / currentWeekLogs.length;
```

Bu hesaplama **log sayısına** bölüyor, **gün sayısına** değil. Eğer 7 gün içinde sadece 1 gün log girildiyse ve o gün 10 sigara içildiyse: ortalama = 10/1 = **10 sigara/gün** çıkıyor. Halbuki 7 güne bölünse ortalaması 10/7 = **1.4** olurdu.

**Tutarsızlık:** Kullanıcıya "sigara/gün" birimi gösterilirken aslında "sigara/log" hesaplanıyor.

---

### 3.4 🟡 Bugün İçilen Sayı İnterpolasyon ile Artıyor

[quit_calculator.dart L242-247](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/main/application/quit_calculator.dart#L242-L247):
```dart
final msSinceLastLog = now.difference(lastLogTodayTime).inMilliseconds;
if (msSinceLastLog > 0) {
  liveSmoked += (rates.cigarettesPerSecond / 1000) * msSinceLastLog;
}
```

Kullanıcı sabah 1 sigara girdiyse, akşama kadar sayaç otomatik olarak artıyor. Kullanıcı "Bugün 3 sigara içtim" derken dashboard "5.7" gösterebilir. Bu **kafa karıştırıcı**.

---

### 3.5 🟡 `statsProvider` Her 100ms'de Rebuild Yapıyor

[stats_provider.dart L40](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/main/application/stats_provider.dart#L40):
```dart
return Stream.periodic(const Duration(milliseconds: 100), (_) {
  return QuitCalculator.calculate(userProfile, logs: logs);
});
```

**Saniyede 10 kez** tüm istatistikler yeniden hesaplanıyor. Bu:
- Canlı sayaç efekti için gerekli (UX)
- Ama gereksiz CPU yükü (orqan hasarı, finansal hesaplar değişmiyor)

**Öneri:** Sayaç animasyonunu `Timer` ile yaparken ağır hesaplamaları (organs, recovery) sadece log değiştiğinde tetikle.

---

## 4. Mantıksal Çelişkiler

### 4.1 🔴 Uygulama İlk Açıldığında Zorla CravingScreen'e Yönlendirme

[main_screen.dart L36-59](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/main/presentation/main_screen.dart#L36-L59):

```dart
// Bugün log yoksa otomatik olarak CravingScreen'e yönlendir
if (!hasLogForToday) {
  context.push(AppRouter.craving);
}
```

**Sorun:** Kullanıcı uygulamayı ilk kez açtığında veya günün herhangi bir saatinde ilk açtığında doğrudan "İçtin mi? İçmedin mi?" sorusuyla karşılaşıyor. Bu:
- Sabah 7'de uygulamayı açan biri için anlamsız ("Daha yeni uyandım, ne içmesi?")
- Agresif ve itici bir UX
- Kullanıcının dashboard'u bile görmeden soru sorulması

**Önerilen çözüm:**
- Zorla yönlendirme yerine dashboard'da soft bir "Bugünkü kaydını gir" banner'ı göster
- Ya da belirli bir saatten sonra (öğleden sonra gibi) göster
- Veya ilk açılışta değil, ikinci açılışta sor

---

### 4.2 🟡 Crisis Screen İle CravingScreen Akışı Çelişiyor

Uygulamada iki farklı "sigara isteği" akışı var:

1. **Crisis Screen (Nav bar → Kriz):** Nefes egzersizi → Başarı → CravingScreen'e yönlendir
2. **CravingScreen (FAB butonu veya otomatik):** Direkt "İçtin mi?" sorusu

**Çelişki:** Crisis Screen başarı sonrası CravingScreen'e gönderiyor ama CravingScreen'in ilk sorusu "Sigara içtin mi?" — kullanıcı az önce "direndim" dedi!

[crisis_screen.dart L521-528](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/crisis/presentation/crisis_screen.dart#L521-L528):
```dart
onPressed: () {
  context.push(AppRouter.craving); // ← Krizi atlattıktan sonra "İçtin mi?" ekranına gidiyor
}
```

**Önerilen çözüm:**  CravingScreen'e parametre geç → `hasSmoked: false` ile direkt craving akışını başlat (ilk soruyu atla)

---

### 4.3 🟡 Damage Screen ve Main Screen'deki Organ Kartları Aynı Veriyi Tekrarlıyor

Ana sayfada `SwipeableDamageCards` var, Damage sekmesinde de aynı organ kartları listeleniyor. Kullanıcı aynı bilgiyi iki yerde görüyor.

**Önerilen çözüm:**
- Ana sayfadaki kartları "özet" olarak tut (sadece en çok hasarlı 2-3 organ)
- Damage ekranını detaylı interaktif ekran yap (iyileşme timeline, ne yapılabilir önerileri)

---

### 4.4 🟡 "Hazırlık Seviyesi" Metriği Kullanıcı İçin Anlaşılmaz

`prepSubtext: "Bırakmaya %45 hazırsın"` — Bu ne anlama geliyor? Kullanıcı sigara bırakmamış, azaltmaya çalışıyor. "Hazırlık seviyesi" kavramı somut değil.

Hesaplama formülü gizli ve kullanıcıya açıklanmıyor. Kullanıcı "%45" gördüğünde "bu nasıl artıyor?" diye soracak.

---

### 4.5 🟢 Anonim Giriş Veri Güvenliği

Anonim giriş yapan kullanıcılar `context.go('/')` ile Firebase auth olmadan ana sayfaya giriyor. `HistoryRepository.syncLogsFromFirestore()` kullanıcı null ise sessizce pass geçiyor — bu doğru. Ama Firestore'a yazma denemesi yapılıyor (`addDailyLog`):
```dart
final user = _auth.currentUser;
if (user != null) { ... } // Anonim'de null, Firestore yazılmıyor
```

Bu mantıken çalışıyor ama kullanıcıya **"Verileriniz sadece bu cihazda"** uyarısı yeterince belirgin değil.

---

## 5. Kullanıcı Bağlılığı & Özellik Önerileri

> Feature Adviser analizi — Uygulamanın günlük kullanımını artırmaya odaklı öneriler

### 5.1 🏆 Günlük Check-in Sistemi ← EN ÖNCELİKLİ

**Mevcut durum:** Uygulama zorla CravingScreen açıyor ama bu agresif.

**Öneri: Yumuşak Günlük Check-in Akışı**
- Uygulama açılınca dashboard'da bir "Günlük Check-in" kartı göster
- Kartın içinde: "Bugün nasıl geçti?" + 3 hızlı seçenek:
  - 🟢 "Temiz gün" (dokunca direkt kaydet)
  - 🟡 "Birkaç sigara" (sayı sor, hızlı kaydet)
  - 🔴 "Zor bir gündü" (detaylı form aç)
- **Check-in yapıldıktan sonra** kart kaybolur, dashboard temiz kalır
- **Tahmini efor:** Orta (2-3 gün)

---

### 5.2 🏆 Streak (Seri) Sistemi

**Motivasyon:** "14 gündür her gün kayıt girdin!" veya "5 gündür 0 sigara!"
- Main header'da veya maskotun yanında seri göstergesi
- Seri kırılınca maskot üzgün olsun
- **Tahmini efor:** Düşük (1 gün)

---

### 5.3 🟡 Başarı Rozetleri (Achievements)

| Rozet | Koşul |
|---|---|
| 🌱 "İlk Adım" | İlk log girişi |
| 💪 "Kriz Avcısı" | 10 kriz direnildi |
| 📉 "Azaltıcı" | Haftalık ortalama düştü |
| 🔥 "7 Gün Serisi" | 7 gün üst üste check-in |
| 🏔️ "Everest Yolcusu" | İçilen sigara mesafesi X km |
| 💰 "Tasarrufçu" | Haftada Y TL tasarruf |

- Settings veya ayrı bir "Başarılar" sekmesinde gösterilebilir
- **Tahmini efor:** Orta (2-3 gün)

---

### 5.4 🟡 Günlük/Haftalık Hedef Belirleme

**Mevcut:** Kullanıcının hedefi yok, sadece mevcut durumu görüyor.  
**Öneri:** "Bu hafta günde en fazla X sigara" hedefi koyabilsin. Başarırsa rozet + maskot tebrik etsin.

- **Tahmini efor:** Orta (2 gün)

---

### 5.5 🟡 Bildirim Sistemi (Push Notifications)

Toggle zaten settings'te var ama çalışmıyor. Önerilen bildirimler:
- **Sabah:** "Günaydın! Bugün hedefe ulaşabilirsin."
- **Akşam (kayıt yoksa):** "Bugün nasıl geçti? Kaydını girmeyi unutma."
- **Seri devam ediyorsa:** "3 gündür harikasın! Devam et."
- **Kriz saati:** Kullanıcının en çok sigara içtiği saatte hatırlatıcı

- **Tahmini efor:** Yüksek (3-4 gün, `flutter_local_notifications` + zamanlama)

---

### 5.6 🟢 Motivasyon Alıntıları Çeşitlendirme

Ana sayfadaki `QuoteCard` sabit bir metin gösteriyor. Günlük değişen alıntılar veya kullanıcı durumuna göre dinamik mesajlar daha etkili olur.

- **Tahmini efor:** Düşük (birkaç saat)

---

### 5.7 🟢 Haftalık Özet Raporu

Her pazar akşamı bir "Haftalık Rapor" kartı göster:
- Bu hafta kaç sigara içtin
- Geçen haftayla karşılaştırma
- Ne kadar para biriktirdin/harcadın
- Kaç krize direndin

- **Tahmini efor:** Orta (1-2 gün)

---

## 6. Lokalizasyon & Çoklu Dil Desteği

### 6.1 Mevcut Durum Analizi

> [!WARNING]
> Uygulama şu an **%100 hardcoded Türkçe**. `l10n.yaml` dosyası yok, `.arb` dosyaları yok. Flutter'ın resmi lokalizasyon sistemi (`gen-l10n`) kullanılmıyor.

**Mevcut yapılandırma** — [app.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/app.dart#L22-L30):
```dart
// ✅ Flutter delegasyonları doğru eklenmiş
localizationsDelegates: const [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
// ⚠️ Sadece tr_TR destekleniyor
supportedLocales: const [Locale('tr', 'TR')],
locale: const Locale('tr', 'TR'),
```

`flutter_localizations` bağımlılığı `pubspec.yaml`'da mevcut (✅), ama sadece Material/Cupertino widget'larının Türkçe çevirisi için kullanılıyor (tarih seçici, dialog butonları vb.). Uygulama metinleri hala hardcoded.

---

### 6.2 Hardcoded String Envanteri

Uygulama genelinde **65+ UI string satırı** tespit edildi. Kategorilere göre:

| Kategori | Örnek Stringler | Dosya Sayısı |
|---|---|---|
| **Ana ekran etiketleri** | `"Harcanan Para"`, `"İçilen Sigara"`, `"Kaybedilen Zaman"`, `"Hazırlık Seviyesi"` | 3 |
| **Navigasyon** | `"Ana Sayfa"`, `"Zararlar"`, `"Kriz"`, `"Geçmiş"`, `"Ayarlar"` | 1 |
| **Motivasyon cümleleri** | 10 adet hardcoded Türkçe cümle (`_motivationalQuotes`) | 1 |
| **Organ isimleri** | `"Akciğerler"`, `"Kalp"`, `"Beyin"`, `"Ağız & Boğaz"` vb. | 1 |
| **Onboarding** | `"Kaç yıldır sigara içiyorsunuz?"`, `"Günde kaç sigara?"` vb. | 8 |
| **Craving akışı** | `"Sigara İçtin mi?"`, `"Nasıl hissediyorsun?"`, `"Ne yapıyordun?"` | 6 |
| **Birimler** | `"sigara/gün"`, `"dakika"`, `"₺"`, `"km"` | 5+ |
| **Hata/Durum mesajları** | `"Henüz Kayıt Yok"`, `"Hata oluştu"`, `"Dünle aynı"` | 3 |
| **Settings** | `"Profil"`, `"Hatırlatıcılar"`, `"Karanlık Mod"`, `"Bilgilerin"` | 2 |
| **Legal/Disclaimer** | Sorumluluk reddi, TOS, Gizlilik Politikası metinleri | 3 |

---

### 6.3 Para Birimi ve Sayı Formatı

> [!IMPORTANT]
> Para birimi (`₺`) ve sayı formatı (`.` binlik ayırıcı, `,` ondalık) kodda sabit yazılmış.

| Dosya | Satır | Durum |
|---|---|---|
| [quit_calculator.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/main/application/quit_calculator.dart#L64) | 64 | `"₺${(burnRate * 60)...}/dk yanıyor"` — ₺ sabit |
| [quit_calculator.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/main/application/quit_calculator.dart#L326-L331) | 326-331 | Binlik ayırıcı `.` sabit (TR formatı) |
| [today_summary_card.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/history/presentation/widgets/today_summary_card.dart#L139) | 139 | `unit: "₺"` sabit |
| [packet_price_step.dart](file:///Users/dogualagoz/YAZILIM/Flutter/flutter_projeler/luno_quit_smoking_app/lib/features/onboarding/presentation/widgets/packet_price_step.dart#L31) | 31 | `locale: 'tr_TR'` sabit |

Farklı ülkelerde `$`, `€`, `£` ve farklı binlik ayırıcılar kullanılıyor. `NumberFormat` ve `intl` paketi ile locale-aware formatlama yapılmalı.

---

### 6.4 🟡 App Store Etkisi

> [!NOTE]
> **TestFlight için:** Tek dil yeterli, engel değil.  
> **App Store için:** Sadece Türkçe desteklemek App Store'da `tr` locale'indeki kullanıcılara ulaşmanı sınırlar. İngilizce eklenmesi erişimi büyük ölçüde artırır.

- App Store Connect'te uygulama dilini `Turkish` olarak seçebilirsin (V1.0 için yeterli)
- İngilizce metadata (title, description, keywords) eklemek ek gelir sağlar
- App Store arama algoritmasında birden fazla dil destekleyen uygulamalar daha iyi sıralanır

---

### 6.5 Lokalizasyon Geçiş Planı (Aşamalı)

#### Aşama 1 — Altyapı Kurulumu (1 gün)
1. `l10n.yaml` dosyası oluştur
2. `lib/l10n/app_tr.arb` → Tüm Türkçe stringleri buraya taşı
3. `lib/l10n/app_en.arb` → İngilizce çevirileri ekle
4. `app.dart`'ta `AppLocalizations` delegasyonunu ekle
5. `supportedLocales`'a `Locale('en', 'US')` ekle

#### Aşama 2 — String Taşıma (2-3 gün)
1. **Navigasyon etiketleri** → `main_shell.dart`
2. **Stat kartı etiketleri** → `quit_calculator.dart`, `stats_provider.dart`, `stat_grid.dart`
3. **Craving/Slip akışı** → `craving_steps/` klasörü (8 dosya)
4. **Settings** → `settings_page.dart`, `about_page.dart`
5. **Onboarding** → 10 adım dosyası
6. **Crisis Screen** → Motivasyon sözleri listesi

#### Aşama 3 — Birim ve Para Formatı (1 gün)
1. Para birimi → Kullanıcı profiline `currencyCode` alanı ekle (onboarding'de sor)
2. `NumberFormat.currency(locale: ...)` ile formatlama
3. Tarih formatları → `DateFormat` ile locale-aware

---

## 7. App Store Gereksinimleri

### 7.1 🔴 `PrivacyInfo.xcprivacy` Dosyası Eksik
Firebase SDK'ları kullanan uygulamalar için iOS 17+ zorunlu. **TestFlight'ta uyarı, App Store'da RED.**

### 7.2 🔴 Gizlilik Politikası Web URL'si Gerekli
Uygulama içinde var ama App Store Connect'e girilecek bir **web URL'si** lazım.

### 7.3 🟡 Splash Screen / App İkonu
- Splash screen varsayılan beyaz
- App ikonu `flutter_launcher_icons` ile ayarlanmış (✅)

### 7.4 🟡 Hesap Silme Fonksiyonu
`deleteAccount()` var ✅ — Apple zorunluluğu karşılanmış. Ancak:
- Hesap silindiğinde Hive (local) verileri silinmiyor. Sadece Firebase Auth hesabı siliniyor.
- Firestore'daki kullanıcı dokümanı da silinmiyor.

**App Store gerekliliği:** "Tüm kullanıcı verileri silinmelidir."

---

## 8. Öncelikli Aksiyon Planı

### ⚡ TestFlight İçin Zorunlu (Hemen)
| # | Görev | Efor |
|---|---|---|
| 1 | Dark mode kırık ekranları düzelt (Onboarding, Auth) | 30 dk |
| 2 | Hata ekranlarını kullanıcı dostu yap | 1 saat |
| 3 | Auth ekranı TOS/Privacy linklerini bağla | 15 dk |
| 4 | Notifications toggle'ı kaldır veya "Yakında" etiketle | 10 dk |
| 5 | Ciğerito Özelleştirme boş sayfayı kaldır / "Yakında" etiketle | 10 dk |
| 6 | "Düne göre karşılaştırma" mantığını düzelt (log yoksa gösterme) | 1 saat |

### 🟡 App Store İçin Zorunlu (Yayın Öncesi)
| # | Görev | Efor |
|---|---|---|
| 7 | `PrivacyInfo.xcprivacy` oluştur | 30 dk |
| 8 | Gizlilik Politikası web URL'si yayınla | 1 saat |
| 9 | Hesap silme sırasında Hive + Firestore verilerini temizle | 2 saat |
| 10 | Splash screen ekle (maskotlu) | 1-2 saat |

### 🟢 Kullanıcı Bağlılığı & Lokalizasyon (V1.1)
| # | Görev | Efor |
|---|---|---|
| 11 | Zorla CravingScreen'i kaldır → Soft check-in kartı yap | 2-3 saat |
| 12 | Crisis → Craving akışını düzelt (parametre geç) | 1 saat |
| 13 | Streak sistemi ekle | 1 gün |
| 14 | Başarı rozetleri | 2-3 gün |
| 15 | Push notifications | 3-4 gün |
| 16 | Haftalık ortalama hesaplamasını düzelt (gün sayısına böl) | 1 saat |
| 17 | Sayaç interpolasyonu için "tahmini" etiketi göster | 30 dk |
| 18 | Lokalizasyon altyapısı kur (`l10n.yaml` + `.arb` dosyaları) | 1 gün |
| 19 | Tüm hardcoded stringleri ARB dosyalarına taşı (65+ string) | 2-3 gün |
| 20 | Para birimi ve sayı formatını locale-aware yap | 1 gün |
| 21 | İngilizce çevirilerini ekle (`app_en.arb`) | 1 gün |

---

> [!TIP]
> **Sıralama önerisi:** Önce TestFlight tablosunu tamamla → TestFlight yayınla → Test ederken App Store tablosunu çöz → V1.1 özelliklerini plana al.
> 
> **Lokalizasyon notu:** V1.0'da tek dil (Türkçe) yeterli. Ama **Aşama 1 (altyapı kurulumu)**'nu erken yapmak sonraki string eklemelerini kolaylaştırır. Yeni eklenen her string doğrudan ARB dosyasına yazılır.
