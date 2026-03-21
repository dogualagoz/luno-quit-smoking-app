# Luno — Görev Listesi

## Faz 0 — Setup (Tamamlandı ✅)
- [x] Klasör yapısı, Tema, AppRouter

## Faz 1 — Foundation (Tamamlandı ✅)
- [x] Paylaşılan Widget'lar, Firebase Init, Repository Katmanı

## Faz 2 — MVP Ekranları (Tamamlandı ✅)
- [x] Onboarding, Dashboard, Hasar Raporu, Ayarlar

## Faz 3 — Polish & Core Extensions (Devam Ediyor ⏳)
- [ ] Animasyonlar ve micro-interactions
- [ ] Firebase Analytics event'leri
- [ ] Error handling iyileştirmesi
- [ ] Final derleme + test

## Faz 4 — Geçmiş & Günlük Check-in Akışı (Yeni Hedef 🚀)
- [x] **1. Veri Modelleme ve Repository:**
  - [x] `DailyLog` modelinin tanımlanması (tarih, miktar, ruh hali, kriz, notlar).
  - [x] Hive entegrasyonu (local DB kurulumu `daily_logs` box).
  - [x] Firestore entegrasyonu (uzak DB senkronizasyonu).
  - [x] Riverpod `dailyLogsProvider`'ın yazılması.
- [ ] **2. Günlük Check-in UI (Uygulama Açılışı):**
  - [x] Açılışta (bugün kayıt yoksa) tetiklenecek akışın hazırlanması.
  - [ ] "Kaç tane içtin?" (+/- butonları) adımının yapılması.
  - [ ] "Nerede içtin?" (Lokasyon/Durum seçimi) adımının yapılması.
  - [ ] "Nasıl hissettin?" (Ruh hali seçimi) adımının yapılması.
  - [x] Kaydet animasyonu ve veritabanı yazma işlemi.
- [x] **3. Geçmiş Sayfası (History Screen):**
  - [x] Sayfa iskeleti ve beyaz temiz kart tasarımının oluşturulması.
  - [x] `fl_chart` paketi ile Haftalık/Aylık Sütun Grafiği (Bar Chart) kodlanması.
  - [x] Günlük Log listesinin tasarımdaki gibi kartlar şeklinde (ikon, miktar, kısa not, kriz sayısı) dökülmesi.
  - [x] Liste elemanına bastığında detayları açılan (Expandable) "Daha Fazla" görünümü.
- [ ] **4. Test ve Entegrasyon:**
  - [ ] Girilen check-in verisinin aynı anda Dashboard ve Grafik'e yansıması kontrolü.
  - [x] Renk ve ikonların temaya uyumu.

## Post-MVP
- [ ] Kriz Modu ekranı
- [ ] Push Notifications altyapısı
- [ ] Gerçek Authentication (email/Google)
- [ ] AI özellikleri
- [ ] Ödeme sistemi
