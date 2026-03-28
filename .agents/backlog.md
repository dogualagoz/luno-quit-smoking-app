# Luno Project Backlog 📋

Bu dosya, uygulamanın yayına (TestFlight/App Store) hazır hale gelmesi için gereken eksikleri ve yeni eklenecek özellikleri takip etmek amacıyla oluşturulmuştur.

---

## 🛠️ Teknik Borç & İyileştirmeler (Polish)

- [x] **Onboarding Responsiveness:** iPhone SE gibi küçük ekranlı cihazlar için tüm onboarding adımlarının (`DailyCigarettesStep`, `SmokingYearsStep` vb.) `SingleChildScrollView` ile sarmalanması ve `Spacer()`ların güvenli hale getirilmesi.
- [ ] **Gelişmiş Hata Yönetimi:** Boş `catch` bloklarının temizlenmesi ve kullanıcıya (Snackbar veya Dialog ile) anlamlı hata mesajlarının gösterilmesi.
- [ ] **Yasal Sayfalar:** Ayarlar sayfasındaki "Kullanım Koşulları" ve "Gizlilik Politikası" linklerinin gerçek web sayfalarına veya uygulama içi metinlere bağlanması.

---

## 🚀 Eksik MVP Özellikleri

- [x] **Firebase Analytics:** `firebase_analytics` paketinin eklenmesi ve kritik olayların (Onboarding bitişi, sayfa geçişleri, kriz butonu tıklaması) izlenmesi.
- [x] **Firebase Crashlytics:** Uygulama çökme raporlarının gerçek zamanlı takibi için kurulumun yapılması.
    - [ ] *Not:* iOS dSYM dosyalarının otomatik yüklenmesi için Xcode script ayarı yapılacak.
- [ ] **Apple Sign-in:** iOS platformu için zorunlu olan Apple ile giriş özelliğinin tam fonksiyonel hale getirilmesi.
- [ ] **Dinamik Konuşma Balonları:** Ciğerito'nun sadece statik değil, kullanıcının verilerine göre (örn. "3 gündir içmiyorsun, harikasın!" veya "Bugün biraz fazla mı kaçırdık?") dinamik mesajlar vermesi.
- [ ] **Onboarding Animasyonları:** Onboarding sürecinde Ciğerito'nun Duolingo tarzı, sürece tepki veren canlı animasyonlarla (Lottie veya Rive) zenginleştirilmesi.
- [ ] **Haptics & Sound Effects:** Buton tıklamaları, başarı durumları ve kriz anları için dokunsal geri bildirim (titreşim) ve hafif ses efektlerinin eklenmesi.

---

## 🗑️ Kapsam Dışı (Dropped)

- [x] ~~**Ayrı Recovery Progress Ekranı:**~~ Kullanıcı isteği üzerine iptal edildi, dashboard üzerinden takip edilecek.
