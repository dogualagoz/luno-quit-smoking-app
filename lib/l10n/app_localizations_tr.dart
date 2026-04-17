// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Cigerito Sigarayı Bırakma Uygulaması';

  @override
  String get welcomeMessage =>
      'Cigerito Sigarayı Bırakma Uygulamasına Hoş Geldiniz! Dumansız bir yolculuğa birlikte çıkalım.';

  @override
  String get getStarted => 'Hadi Başlayalım';

  @override
  String get trackProgress =>
      'İlerlemeni takip et ve ne kadar yol kat ettiğini gör.';

  @override
  String get setGoals =>
      'Hedeflerini belirle ve sigarayı bırakmak için motive kal.';

  @override
  String get supportCommunity => 'Sigarayı bırakan topluluğumuza sen de katıl.';

  @override
  String get tipsAndResources =>
      'Sigarayı bırakmana yardımcı olacak ipuçlarına ve kaynaklara eriş.';

  @override
  String get congratulations =>
      'Daha sağlıklı bir hayata doğru ilk adımı attığın için tebrikler!';

  @override
  String get daysWithoutSmoking => 'Sigarasız geçen günler';

  @override
  String get moneySaved => 'Tasarruf edilen para';

  @override
  String get healthBenefits => 'Sağlık faydaları';

  @override
  String get quitDate => 'Sigarayı Bırakma Tarihi';

  @override
  String get reminders => 'Hatırlatıcılar';

  @override
  String get successStories => 'Başarı Hikayeleri';

  @override
  String get shareYourStory =>
      'Hikayeni paylaş ve sigarayı bırakmak isteyen diğer insanlara ilham ver.';

  @override
  String get contactSupport => 'Destek Ekibiyle İletişime Geç';

  @override
  String get needHelp =>
      'Yardıma mı ihtiyacın var? Destek için ekibimizle iletişime geç.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get confirmLogout => 'Çıkış yapmak istediğine emin misin?';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get error => 'Hata';

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti. Lütfen tekrar dene.';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get damage => 'Zararlar';

  @override
  String get crisis => 'Kriz';

  @override
  String get history => 'Geçmiş';

  @override
  String get settingsHeaderTitle => 'Ayarlar ⚙️';

  @override
  String get settingsHeaderSubtitle => 'Kişiselleştir, düzenle, kendini tanı.';

  @override
  String get toolsAndAppearance => 'Araçlar & Görünüm';

  @override
  String get dailyAverage => 'Günlük ortalama';

  @override
  String get packPrice => 'Paket fiyatı';

  @override
  String get goalZeroReminder => 'Hedef sıfır, unutma.';

  @override
  String get customizationComingSoon => 'Ciğerito Özelleştirme (Yakında)';

  @override
  String get shareApp => 'Uygulamayı Paylaş';

  @override
  String get suggestFeedback => 'Öneri Yap & Bildir';

  @override
  String get errorScreenTest => 'Hata Ekranı Testi (Geliştirici)';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutSubtitle =>
      'Kaynaklar, sorumluluk reddi ve uygulama bilgileri';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get deleteAccountTitle => 'Hesabı Kalıcı Olarak Sil?';

  @override
  String get deleteAccountContent =>
      'Tüm verilerin ve hesabın kalıcı olarak silinecektir. Bu işlem geri alınamaz. Onaylıyor musun?';

  @override
  String get deleteAccount => 'Hesabı Sil';

  @override
  String get securityRetryMessage =>
      'Güvenlik için lütfen çıkış yapıp tekrar giriş yaptıktan sonra hesabı silmeyi deneyin.';

  @override
  String get smokingInfo => 'Sigara Bilgilerin';

  @override
  String get logoutConfirmTitle => 'Çıkış yap?';

  @override
  String get onboardingIntroSpeech =>
      'Hoş geldin! Ben Ciğerito. Sigarayı tamamen bırakmana yardımcı olmak için buradayım.';

  @override
  String get onboardingIntroTitle => 'Başarabilirsin';

  @override
  String get onboardingIntroSubtitle =>
      'Birlikte planlayacağız, birlikte savaşacağız ve sonunda sen kazanacaksın. Hazır mısın?';

  @override
  String get onboardingDailyCigarettesQuestion => 'Günde kaç sigara içiyorsun?';

  @override
  String get onboardingDailyCigarettesUnit => 'adet / gün';

  @override
  String get onboardingPacketPriceQuestion => 'Bir paket sigara kaç TL?';

  @override
  String get onboardingMonthlyExpenseLabel => 'Aylık harcaman:';

  @override
  String get onboardingMonthlyExpenseHint =>
      'Bu parayla her ay güzel bir restoranda yemek yiyebilirdin.';

  @override
  String get onboardingCigarettesTableauTitle => 'Acı Tableau';

  @override
  String get onboardingCigarettesTotalCigarettes => 'Toplam Sigara';

  @override
  String get onboardingCigarettesTowerHeight => 'Oluşan Kule Boyu';

  @override
  String onboardingCigarettesCount(Object count) {
    return '$count adet';
  }

  @override
  String get onboardingMoneyGainTitle => 'Bıraktığında Kazancın';

  @override
  String get onboardingMoneyGainInOneMonth => '1 Ayda';

  @override
  String get onboardingMoneyGainInSixMonths => '6 Ayda';

  @override
  String get onboardingMoneyGainInOneYear => '1 Yılda';

  @override
  String get onboardingMoneyGainInFiveYears => '5 Yılda';

  @override
  String get reasonsHealth => 'Sağlık';

  @override
  String get reasonsEconomy => 'Ekonomi';

  @override
  String get reasonsFamily => 'Aile';

  @override
  String get reasonsBeauty => 'Güzellik';

  @override
  String get reasonsFreedom => 'Özgürlük';

  @override
  String get reasonsSmell => 'Koku';

  @override
  String get reasonsFitness => 'Zindelik';

  @override
  String get reasonsLongerLife => 'Daha uzun ömür';

  @override
  String get triggerMorningCoffee => 'Sabah kahvesi';

  @override
  String get triggerStressfulMoments => 'Stresli anlar';

  @override
  String get triggerAfterMeal => 'Yemek sonrası';

  @override
  String get triggerWithAlcohol => 'Alkol ile';

  @override
  String get triggerBoredom => 'Can sıkıntısı';

  @override
  String get triggerBreakTime => 'Mola anları';

  @override
  String get triggerNightTime => 'Gece vakti';

  @override
  String get triggerOther => 'Diğer';

  @override
  String get tryingFirstTimeTitle => 'İlk denemem';

  @override
  String get tryingFirstTimeDesc => 'Bu sefer gerçekten kararlıyım';

  @override
  String get tryingSecondTimeTitle => '2-3 kez denedim';

  @override
  String get tryingSecondTimeDesc => 'Daha önce savaştım, tecrübeliyim';

  @override
  String get tryingManyTimesTitle => 'Çok kez denedim';

  @override
  String get tryingManyTimesDesc => 'Defalarca denedim ama pes etmiyorum';

  @override
  String get tryingNeverCountedTitle => 'Hiç saymadım';

  @override
  String get tryingNeverCountedDesc => 'Bırakma döngüsünde kayboldum';

  @override
  String onboardingYearsInterstitialBubble(Object years) {
    return '$years yıl içmişsin ha? Merak etme, birlikte bırakmamız $years gün bile sürmeyecek!';
  }

  @override
  String get legalIntroSpeech =>
      'Burada kimse seni yargılamaz.\n\nBu yolculuk senin iradenle ve doğru verilerle şekillenecek. Lütfen sorulara dürüst yanıt ver ki sana en iyi şekilde yardımcı olabileyim.';

  @override
  String get legalFinalMedicalTitle => 'Tıbbi Tavsiye Değildir';

  @override
  String get legalFinalMedicalDescription =>
      'Bu uygulama tıbbi bir cihaz veya tedavi yöntemi değildir. Sigara bırakma sürecinde mutlaka bir sağlık profesyoneline danışın.';

  @override
  String get legalFinalPrivacyTitle => 'Veri Gizliliği';

  @override
  String get legalFinalPrivacyDescription =>
      'Tüm verilerin yalnızca cihazında saklanır. Kişisel sağlık bilgilerini üçüncü taraflarla paylaşmayız.';

  @override
  String get legalFinalPurposeTitle => 'Amaç';

  @override
  String get legalFinalPurposeDescription =>
      'Bu uygulama sigara içmeyi teşvik etmez. Amacı farkındalık yaratmak ve bırakma sürecinizi desteklemektir.';

  @override
  String get authSelectionOnboardingComplete => 'Onboarding tamamlandı!';

  @override
  String authSelectionGreeting(Object userName) {
    return 'Harika $userName! Artık seninle bu yolculuğa çıkmaya hazırım. Nasıl devam etmek istersin?';
  }

  @override
  String get authContinueWithApple => 'Apple ile devam et';

  @override
  String get authContinueWithGoogle => 'Google ile devam et';

  @override
  String get authContinueWithEmail => 'E-posta ile devam et';

  @override
  String get authContinueAnonymously => 'Anonim olarak devam et';

  @override
  String get authAnonymousInfo =>
      'Anonim girişte verilerin yalnızca bu cihazda saklanır. Hesap oluşturursan cihazlar arası senkron yapabilirsin.';

  @override
  String get authTermsNoticePrefix => 'Devam ederek ';

  @override
  String get authTermsNoticeTerms => 'Kullanım Koşulları';

  @override
  String get authTermsNoticeAnd => ' ve ';

  @override
  String get authTermsNoticePrivacy => 'Gizlilik Politikası';

  @override
  String get authTermsNoticeSuffix => '\'nı kabul edersin.';

  @override
  String get emailLoginSpeech =>
      'E-posta ile giriş yap, verilerini her yerden takip et!';

  @override
  String get emailLoginTitle => 'Giriş Yap';

  @override
  String get emailLoginSubtitle => 'E-posta ve şifreni gir';

  @override
  String get emailLoginEmailLabel => 'E-posta';

  @override
  String get emailLoginEmailHint => 'ornek@mail.com';

  @override
  String get emailLoginPasswordLabel => 'Şifre';

  @override
  String get emailLoginPasswordHint => '••••••••';

  @override
  String get emailLoginForgotPassword => 'Şifremi unuttum';

  @override
  String get emailLoginButton => 'Giriş Yap';

  @override
  String get emailLoginNoAccount => 'Hesabın yok mu? ';

  @override
  String get emailLoginSignUp => 'Kayıt ol';

  @override
  String get emailLoginOrFast => 'veya hızlı giriş';

  @override
  String get emailRegisterSpeech => 'Yeni hesap oluştur, ben seni unutmam!';

  @override
  String get emailRegisterTitle => 'Hesap Oluştur';

  @override
  String get emailRegisterSubtitle => 'Hemen ücretsiz hesabını oluştur';

  @override
  String get emailRegisterEmailLabel => 'E-posta';

  @override
  String get emailRegisterEmailHint => 'ornek@mail.com';

  @override
  String get emailRegisterPasswordLabel => 'Şifre';

  @override
  String get emailRegisterPasswordHint => '••••••••';

  @override
  String get emailRegisterButton => 'Hesap Oluştur';

  @override
  String get emailRegisterAlreadyHaveAccount => 'Zaten hesabın var mı? ';

  @override
  String get emailRegisterLogin => 'Giriş yap';

  @override
  String get emailRegisterOrFast => 'veya hızlı giriş';

  @override
  String get mainCigarettesDetailsTitle => 'Sigara Miktarı';

  @override
  String get mainCigarettesDetailsSubtitle => 'Bunları Geçecek Kadar Uzun:';

  @override
  String mainError(Object error) {
    return 'Hata: $error';
  }

  @override
  String get mainTotalCigarettes => 'İçilen Toplam Adet';

  @override
  String mainDistance(Object distance) {
    return 'Uç uca: $distance';
  }

  @override
  String mainHeight(Object height) {
    return '${height}m Yükseklik';
  }

  @override
  String get mainMoneyDetailsTitle => 'Maliyet Analizi';

  @override
  String get mainMoneyDetailsSubtitle => 'Bunları Alabilirdin:';

  @override
  String get mainMoneyDetailsProjections => 'Gelecek Projeksiyonu';

  @override
  String get mainTotalSpent => 'Toplam Harcanan';

  @override
  String get mainBurningText => 'Saniye saniye yanıyor...';

  @override
  String get mainRecoveryDetailsTitle => 'Bırakmaya Hazırlık';

  @override
  String get mainRecoveryDetailsSubtitle => 'Hazırlık Seviyeni Ne Artırır?';

  @override
  String get mainRecoveryScoreLabel => 'Bırakmaya Hazırlık Skorun';

  @override
  String get welcomeScreenWelcome => 'Cigerito\'ya\nHoş Geldin';

  @override
  String get welcomeScreenSubtitle =>
      'Sigarasız, sağlıklı ve özgür bir hayata\nadım atmaya hazır mısın?';

  @override
  String get welcomeScreenStart => 'Başlayalım';

  @override
  String get welcomeScreenAlreadyMember => 'Zaten üye misin? ';

  @override
  String get welcomeScreenLogin => 'O zaman giriş yap';

  @override
  String get smokingYearsQuestion => 'Ne kadar süredir sigara içiyorsun?';

  @override
  String get smokingYearsUnit => 'yıl';

  @override
  String get smokingYearsOneYear => '1 yıl';

  @override
  String get smokingYearsMaxYear => '40 yıl';

  @override
  String smokingYearsSelected(Object year) {
    return '$year yıl';
  }

  @override
  String get summarySmoked => 'sigara içtin';

  @override
  String get summarySpent => 'harcadın';

  @override
  String get summaryDaysLost => 'gün kaybettin';

  @override
  String get summaryMinutesStolen => 'dk ömür çalındı';

  @override
  String summaryCarBuy(Object money) {
    return '$money ile sıfırdan bir araba alabilirdin.';
  }

  @override
  String get summaryNameHint => 'Adın veya takma adın...';

  @override
  String get timeDetailsTitle => 'Zaman Analizi';

  @override
  String get timeDetailsSubtitle => 'Bunun Yerine Ne Yapabilirdin?';

  @override
  String get timeDetailsTotalLost => 'Toplam Kayıp';

  @override
  String get timeDetailsDaysShort => 'g ';

  @override
  String get timeDetailsHoursShort => 's ';

  @override
  String get timeDetailsMinsShort => 'd';

  @override
  String get timeDetailsHoursConst => 'saat';

  @override
  String get timeDetailsEquivBookTitle => 'Kitap Okuma';

  @override
  String get timeDetailsEquivBookUnit => 'kitap';

  @override
  String get timeDetailsEquivMovieTitle => 'Film İzleme';

  @override
  String get timeDetailsEquivMovieUnit => 'film';

  @override
  String get timeDetailsEquivLanguageTitle => 'Yeni Dil Öğrenme';

  @override
  String get timeDetailsEquivLanguageUnit => 'dil (Temel)';

  @override
  String get recoveryFactorLimitTitle => 'Günlük Limit Uyumu';

  @override
  String get recoveryFactorLimitDesc =>
      'Belirlediğin günlük sigara limitinin altında kaldığın her an skorun artar.';

  @override
  String get recoveryFactorCrisisTitle => 'Kriz Yönetimi';

  @override
  String get recoveryFactorCrisisDesc =>
      'Canın sigara istediğinde içmek yerine \"Kriz\" butonunu kullanman iradeni güçlendirir.';

  @override
  String get recoveryFactorTrackingTitle => 'Düzenli Takip';

  @override
  String get recoveryFactorTrackingDesc =>
      'Uygulamayı her gün kullanman ve verilerini girmen kararlılığını gösterir.';

  @override
  String get recoveryFactorTimeTitle => 'Zaman Kazanımı';

  @override
  String get recoveryFactorTimeDesc =>
      'Sigara içmeyerek kazandığın her dakika seni özgürlüğe yaklaştırır.';

  @override
  String get cigarettesEquivStatueTitle => 'Özgürlük Anıtı';

  @override
  String get cigarettesEquivEiffelTitle => 'Eyfel Kulesi';

  @override
  String get cigarettesEquivBurjTitle => 'Burj Khalifa';

  @override
  String get cigarettesEquivEverestTitle => 'Everest Dağı';

  @override
  String get cigarettesDetailsTimes => 'kez';

  @override
  String get moneyEquivCoffeeTitle => 'Kahve';

  @override
  String get moneyEquivCinemaTitle => 'Sinema Bileti';

  @override
  String get moneyEquivConsoleTitle => 'Oyun Konsolu';

  @override
  String get moneyEquivPhoneTitle => 'Kaliteli Telefon';

  @override
  String get moneyDetailsCount => 'adet';

  @override
  String get moneyDetailsProjection1Week => '1 Hafta Sonra';

  @override
  String get moneyDetailsProjection1Month => '1 Ay Sonra';

  @override
  String get moneyDetailsProjection1Year => '1 Yıl Sonra';

  @override
  String get crisisQuote1 =>
      'Bu istek 3-5 dakikada geçecek. Sen daha zor şeyleri aştın.';

  @override
  String get crisisQuote2 =>
      'Her direndiğin kriz, ciğerlerini iyileştiren bir zafer.';

  @override
  String get crisisQuote3 => 'Nefes al, bırak gitsin. Duman değil, temiz hava.';

  @override
  String get crisisQuote4 =>
      'Bir sigara 7 dakika ömründen çalıyor. Ama bu kriz 5 dakikada geçecek.';

  @override
  String get crisisQuote5 => 'Bugüne kadar direndin, şimdi de direneceksin.';

  @override
  String get crisisQuote6 =>
      'Beynin seni kandırıyor. İstek değil, alışkanlığın sesini duyuyorsun.';

  @override
  String get crisisQuote7 => 'Bu anı atlatırsan, yarın daha güçlü uyanacaksın.';

  @override
  String get crisisQuote8 =>
      'Sigara bir çözüm değil. Sadece 5 dakikalık bir erteleme.';

  @override
  String get crisisQuote9 =>
      'Krizler azalacak. Her biri bir öncekinden daha kısa sürecek.';

  @override
  String get crisisQuote10 => 'Bu an geçici. Ama sağlığın kalıcı.';

  @override
  String get crisisBreathIn => 'Nefes Al';

  @override
  String get crisisBreathHold => 'Tut';

  @override
  String get crisisBreathOut => 'Yavaşça Ver';

  @override
  String get crisisModeTitle => 'Kriz Modu ⚡';

  @override
  String get crisisButtonText => 'Sigara İsteği Geldi!';

  @override
  String get crisisButtonSubtext =>
      'Düğmeye bas, birlikte bu anı atlatacağız.\nOrtalama kriz süresi: 3-5 dakika';

  @override
  String get crisisStatsTitle => 'Kriz İstatistiklerin';

  @override
  String get crisisStatSkipped => 'Atlanan kriz';

  @override
  String get crisisStatThisWeek => 'Bu hafta';

  @override
  String get crisisStatSuccessRate => 'Başarı oranı';

  @override
  String get crisisSkipExercise => 'Egzersizi Atla →';

  @override
  String get crisisSuccessTitle => 'Harika, Direndin! 💪';

  @override
  String crisisSuccessDescription(Object timeStr) {
    return '$timeStr boyunca nefes egzersizi yaptın ve bu krizi atlattın.\nŞimdi bu anı kaydet — veriler seni güçlendirecek.';
  }

  @override
  String get crisisSaveButton => 'Krizi Kaydet';

  @override
  String get crisisPassButton => 'Kaydetmeden Geç';

  @override
  String get damageHeaderTitle => 'Hasar Raporu';

  @override
  String get damageHeaderSubtitle =>
      'Kötü haberlerim var. İyi haberlerim de var ama önce kötüleri dinle.';

  @override
  String get damageSpeechBubble =>
      'Acı gerçeklerle yüzleşme vakti. Hazır mısın? Ben değilim.';

  @override
  String get damageDisclaimer =>
      'Bu veriler ortalama değerlere dayanır. Gerçek hasar kişiye göre değişebilir.';

  @override
  String get damageSources => 'Kaynaklar: ACS, WHO, U.S. Surgeon General, CDC';

  @override
  String damageTotalSubtitle(Object years) {
    return '$years yıla yayılmış toplam hasar';
  }

  @override
  String get damageTotalScore => 'Genel Hasar Skoru';

  @override
  String get statMoneyLabel => 'Harcanan Para';

  @override
  String statMoneySubtext(Object rate) {
    return '₺$rate/dk yanıyor';
  }

  @override
  String get statMoneyAction => 'ne alabilirdin? — dokun';

  @override
  String get statTimeLabel => 'Kaybedilen Zaman';

  @override
  String get statTimeSubtext => 'Şu an da sayaç işliyor...';

  @override
  String get statTimeNotStarted => 'Henüz başlamadın';

  @override
  String get statCountLabel => 'İçilen Sigara';

  @override
  String statCountSubtext(Object distance) {
    return '$distance km — Everest\'e tırmanabilirdin';
  }

  @override
  String get statCountNotStarted => 'Henüz ölçülmedi';

  @override
  String get statPrepLabel => 'Hazırlık Seviyesi';

  @override
  String statPrepSubtext(Object percent) {
    return 'Bırakmaya %$percent hazırsın';
  }

  @override
  String get statPrepAction => 'Bırakmaya hazır mısın? — dokun';

  @override
  String get damageOrganLungs => 'Akciğerler';

  @override
  String get damageOrganHeart => 'Kalp';

  @override
  String get damageOrganBlood => 'Kan Dolaşımı';

  @override
  String get damageOrganBrain => 'Beyin';

  @override
  String get damageOrganMouth => 'Ağız & Boğaz';

  @override
  String get damageOrganStomach => 'Mide & Sindirim';

  @override
  String get damageDesc0 => 'Henüz ciddi hasar yok, ama risk artıyor.';

  @override
  String damageDesc1(Object percent) {
    return 'Erken dönem hasar belirtileri — %$percent risk.';
  }

  @override
  String damageDesc2(Object percent) {
    return 'Orta seviye hasar — %$percent etkilenmiş.';
  }

  @override
  String damageDesc3(Object percent) {
    return 'Yüksek hasar — %$percent kapasitede kayıp.';
  }

  @override
  String damageDesc4(Object percent) {
    return 'Kritik seviye — %$percent ciddi risk altında.';
  }

  @override
  String get damageOrganLungsQuote =>
      'Merdiven çıkarken nefes nefese kalman tesadüf değil.';

  @override
  String get damageOrganHeartQuote =>
      'Kalbin seni seviyor ama bu tempoya daha ne kadar dayanır?';

  @override
  String get damageOrganBloodQuote =>
      'Damarların giderek sertleşiyor, her sigara bir çivi daha.';

  @override
  String get damageOrganBrainQuote =>
      'Her nefeste beynine daha az oksijen gidiyor.';

  @override
  String get damageOrganMouthQuote =>
      'Ses tellerin her dumanda biraz daha kalınlaşıyor.';

  @override
  String get damageOrganStomachQuote =>
      'Miden dumanla dolunca yemek bile zor oluyor.';

  @override
  String get diaryHistoryNoLogTitle => 'Henüz Kayıt Yok';

  @override
  String get diaryHistoryNoLogDesc =>
      'Sürecini başlatmak ve nasıl ilerlediğini görmek için ilk dürüst kaydını gir.';

  @override
  String get diaryHistoryTitle => 'Günlüğüm 📖';

  @override
  String get diaryHistorySubtitle =>
      'Atılan her adım, yazılan her satır daha temiz bir geleceğe.';

  @override
  String get diaryHistoryToday => 'Bugün';

  @override
  String get diaryHistoryYesterday => 'Dün';

  @override
  String get diaryHistoryFilterWeek => 'H';

  @override
  String get diaryHistoryFilterMonth => 'A';

  @override
  String get diaryHistoryFilterYear => 'Y';

  @override
  String get diaryHistoryPages => 'Sayfalar';

  @override
  String get diaryHistoryStats => 'İstatistikler';

  @override
  String get diaryHistoryCigarettesPerDay => 'sigara/gün';

  @override
  String get diaryHistoryAvgWeek => 'Bu hafta boyunca ortalama';

  @override
  String get diaryHistoryAvgMonth => 'Bu ay boyunca ortalama';

  @override
  String get diaryHistoryAvgYear => 'Bu yıl boyunca ortalama';

  @override
  String get diarySummaryTitle => 'Bugünün Özeti';

  @override
  String get diarySummaryUnitCigarette => 'sigara';

  @override
  String get diarySummaryUnitCurrency => 'TL';

  @override
  String get diarySummaryUnitMinute => 'dakika';

  @override
  String get diarySummaryBadgeLoss => 'Kayıp';

  @override
  String get diarySummaryBadgeClean => 'Temiz';

  @override
  String diarySummaryResisted(Object count) {
    return '$count krize direndin';
  }

  @override
  String get diarySummaryCostTitle => 'Bugünkü Maliyet';

  @override
  String get diarySummaryBadgeFinancial => 'Finansal';

  @override
  String get diarySummaryCostDesc => 'Yanan para miktarı';

  @override
  String get diarySummaryTimeTitle => 'Kaybedilen Zaman';

  @override
  String get diarySummaryBadgeTime => 'Zaman';

  @override
  String get diarySummaryTimeDesc => 'Hayatından çalınan süre';

  @override
  String get diarySummaryButtonSlip => 'Sigara İçtim';

  @override
  String get diarySummaryMessageSlip =>
      'Zararın neresinden dönersen kârdır. Kaydettiğin sürece ilerliyorsun.';

  @override
  String get diarySummaryMessageClean =>
      'Tertemiz! Bugün duman yok, hedefe bir adım daha yakınsın.';

  @override
  String get diarySummaryCompareSame => 'Dünle aynı';

  @override
  String diarySummaryCompareCurrencyBetter(Object amount) {
    return 'düne göre $amount TL kardasın';
  }

  @override
  String diarySummaryCompareCurrencyWorse(Object amount) {
    return 'düne göre $amount TL fazla harcadın';
  }

  @override
  String diarySummaryCompareTimeBetter(Object amount) {
    return 'düne göre $amount dakika kazandın';
  }

  @override
  String diarySummaryCompareTimeWorse(Object amount) {
    return 'düne göre $amount dakika kaybettin';
  }

  @override
  String diarySummaryCompareCountBetter(Object amount, Object unit) {
    return 'düne göre $amount $unit az içtin';
  }

  @override
  String diarySummaryCompareCountWorse(Object amount, Object unit) {
    return 'düne göre $amount $unit fazla içtin';
  }

  @override
  String get diaryQuickAddTitle => 'Bi\' sigara yandı...';

  @override
  String get diaryQuickAddDesc =>
      'Neden içtiğine dair not düşmek ister misin? Yoksa sadece sayıyı mı ekleyelim?';

  @override
  String get diaryQuickAddButtonSkip => 'Boş ver, sadece 1 sigara ekle';

  @override
  String get diaryQuickAddButtonNote => 'Neden içtiğini paylaş';

  @override
  String get diaryChartTooltipMeasure => 'sigara ölçümü';

  @override
  String get diaryChartTooltipClean => 'Oley! Temiz gün 🌱';

  @override
  String get diaryChartTooltipWarning => 'Dikkatli ol! ⚠️';

  @override
  String get diaryChartTooltipControl => 'Kontrol sende 👍';

  @override
  String get diaryChartTooltipUnit => 'adet';

  @override
  String get diaryCardStatusCravingResisted => 'Kriz Atlatıldı';

  @override
  String diaryCardStatusCount(Object count) {
    return '$count adet';
  }

  @override
  String diaryCardIntensity(Object intensity) {
    return 'Şiddet: $intensity/10';
  }

  @override
  String get diaryCardBadgeResisted => 'Direnç';

  @override
  String get diaryCardDetailLocation => 'Konum';

  @override
  String get diaryCardDetailMood => 'Duygu Durumu';

  @override
  String get diaryCardDetailActivity => 'Aktivite';

  @override
  String get diaryCardDetailCompanion => 'Kiminleydi';

  @override
  String get diaryLogSave => 'Kaydet';

  @override
  String get diaryLogContinue => 'Devam Et';

  @override
  String get diaryChartDays => 'Pzt,Sal,Çar,Per,Cum,Cmt,Paz';

  @override
  String get diaryChartMonths =>
      'Oca,Şub,Mar,Nis,May,Haz,Tem,Ağu,Eyl,Eki,Kas,Ara';

  @override
  String get diaryStepCondLabel => 'KOŞULLAR';

  @override
  String get diaryStepCondTitle => 'O sırada ne yapıyordun?';

  @override
  String get diaryStepCondOther => 'Hangi aktivite? Lütfen yazın:';

  @override
  String get diaryStepCondOtherHint => 'Yemek sonrası, kahve yanı vs...';

  @override
  String get diaryStepCongratTitle => 'Harikasın!';

  @override
  String get diaryStepCongratDesc =>
      'Bugünü de dumansız kapatmayı başardın. Ciğerlerin sana teşekkür ediyor! 🫁✨';

  @override
  String get diaryStepCongratAction => 'Dumansız Gün Kaydedilecek';

  @override
  String get diaryStepTimeLabel => 'ZAMAN';

  @override
  String get diaryStepTimeTitle => 'Ne zamandı?';

  @override
  String get diaryStepTimeAction =>
      'Şu anı kaydetmek için direkt devam edebilirsin.';

  @override
  String get diaryStepIntensityLabel => 'İSTEK ŞİDDETİ';

  @override
  String get diaryStepIntensityTitle =>
      'Sigara içme isteğin ne kadar güçlüydü?';

  @override
  String get diaryStepIntensityMin => 'Hiç';

  @override
  String get diaryStepIntensityMax => 'Çıldırtıcı!';

  @override
  String get diaryStepLocationLabel => 'KONUM';

  @override
  String get diaryStepLocationTitle => 'Neredeydin?';

  @override
  String get diaryStepLocationHome => 'Ev';

  @override
  String get diaryStepLocationWork => 'İş';

  @override
  String get diaryStepLocationOutside => 'Dışarıda';

  @override
  String get diaryStepLocationCar => 'Araçta';

  @override
  String get diaryStepLocationCafe => 'Kafe/Restoran';

  @override
  String get diaryStepLocationServiceComingSoon =>
      'Konum hizmeti yakında eklenecek!';

  @override
  String get diaryStepLocationFind => 'Konumumu Bul';

  @override
  String get diaryStepLocationManual => 'Veya manuel gir:';

  @override
  String get diaryStepLocationHint => 'Konum adı yazın...';

  @override
  String get diaryStepNotesLabel => 'NOTLAR';

  @override
  String get diaryStepNotesTitle => 'Neler olduğunu anlatmak ister misin?';

  @override
  String get diaryStepNotesHint =>
      'O anki hislerini, tetikleyicileri buraya yazabilirsin...';

  @override
  String get diaryStepCompanionLabel => 'SOSYAL DURUM';

  @override
  String get diaryStepCompanionTitle => 'Kiminleydin?';

  @override
  String get diaryStepCompanionDesc =>
      'En çok kime duman çarptı? Sadece bir tane seçelim.';

  @override
  String get diaryStepMoodLabel => 'DUYGU DURUMU';

  @override
  String get diaryStepMoodTitle => 'Nasıl hissediyordun?';

  @override
  String get diaryStepMoodOther => 'Hangi duygu? Lütfen yazın:';

  @override
  String get diaryStepMoodOtherHint => 'Endişeli, Heyecanlı vs...';

  @override
  String get diaryStepAmountLabel => 'MİKTAR';

  @override
  String get diaryStepAmountTitle => 'Kaç tane içtin?';

  @override
  String get diaryStepAmountUnit => 'sigara';

  @override
  String get diaryStepCheckTitle => 'Bugün nasıl geçti?';

  @override
  String get diaryStepCheckDesc =>
      'Ciğerito senin için not alıyor. Bugün hiç sigara içtin mi?';

  @override
  String get diaryStepCheckNoTitle => 'Hayır,\nİçmedim!';

  @override
  String get diaryStepCheckNoSubtitle => 'Krizi yendim';

  @override
  String get diaryStepCheckYesTitle => 'Evet,\nİçtim';

  @override
  String get diaryStepCheckYesSubtitle => 'Kaçamak yaptım';

  @override
  String get diaryStepStatusLabel => 'SONUÇ';

  @override
  String get diaryStepStatusTitle => 'Sigara içip içmediğini belirt lütfen';

  @override
  String get diaryStepStatusYesTitle => 'Evet, maalesef içtim';

  @override
  String get diaryStepStatusYesSubtitle => 'Yenilgi değil, bir geri bildirim.';

  @override
  String get diaryStepStatusNoTitle => 'Hayır, direndim!';

  @override
  String get diaryStepStatusNoSubtitle => 'Harikasın, bir zafer daha!';

  @override
  String get settingsThemeDark => 'Koyu Tema';

  @override
  String get settingsReminders => 'Hatırlatıcılar';

  @override
  String get aboutDisclaimerTitle => 'Sorumluluk Reddi';

  @override
  String get aboutDisclaimerText =>
      'Bu uygulama tıbbi tavsiye niteliğinde değildir. Sunulan veriler bilimsel kaynaklara dayanmakla birlikte, kişisel sağlık durumunuz için bir sağlık uzmanına danışınız. Uygulama, sigara bırakma sürecinize destek olmayı amaçlar; tedavi veya teşhis sunmaz.';

  @override
  String get aboutSourcesTitle => 'Bilimsel Kaynaklar';

  @override
  String get aboutTosTitle => 'Kullanım Koşulları (TOS)';

  @override
  String get aboutPrivacyTitle => 'Gizlilik Politikası';

  @override
  String get aboutTimelineTitle => 'İyileşme Zaman Çizelgesi';

  @override
  String get aboutSourcePrefix => 'Kaynak: ';

  @override
  String get aboutDurationMinutes => 'dakika';

  @override
  String get aboutDurationHours => 'saat';

  @override
  String get aboutDurationDays => 'gün';

  @override
  String get aboutDurationMonths => 'ay';

  @override
  String get aboutDurationYears => 'yıl';

  @override
  String get settingsTosText =>
      'Son Güncelleme: 1 Ocak 2026\n\n1. Kabul Edilme\nLuno uygulamasını (\"Uygulama\") kullanarak, işbu Kullanım Koşullarını (\"Koşullar\") kabul etmiş olursunuz. Eğer bu koşulları kabul etmiyorsanız, Uygulamayı kullanmamalısınız.\n\n2. Hizmetin Doğası\nLuno, sigarayı bırakma sürecinize yardımcı olmak amacıyla tasarlanmış bir motivasyon ve takip aracıdır. Uygulama tıbbi teşhis, tavsiye veya tedavi sunmaz. Tıbbi durumlar için nitelikli bir sağlık uzmanına başvurmanız gerekmektedir.\n\n3. Kullanıcı Hesabı\n- Uygulamayı kullanmak için oluşturduğunuz hesabın güvenliğinden siz sorumlusunuz.\n- Verileriniz cihazınızda veya kendi rızanızla bulut ortamında (Firebase) saklanabilir.\n\n4. Sorumluluk Reddi\nLuno geliştiricileri, uygulamanın kullanımından kaynaklanabilecek doğrudan veya dolaylı hiçbir zarardan sorumlu tutulamaz.\n\n5. Değişiklikler\nLuno, işbu Koşulları önceden haber vermeksizin dilediği zaman değiştirme hakkını saklı tutar.\n\nİletişim: Geri bildirim ve destek için Uygulama içerisindeki iletişim araçlarını kullanabilirsiniz.';

  @override
  String get settingsPrivacyText =>
      'Son Güncelleme: 1 Ocak 2026\n\nLuno olarak gizliliğinize büyük önem veriyoruz. Bu politika, sizin hakkınızdaki bilgilerin nasıl toplandığını, kullanıldığını ve korunduğunu açıklar.\n\n1. Toplanan Bilgiler\n- Kişisel Bilgiler: Tarafınızdan gönüllü olarak sağlanan e-posta adresi ve giriş bilgileri.\n- Uygulama Verileri: Günlük içilen sigara adedi, yaş, sigara fiyatı gibi profil bilgileri ile History sayfasında tutulan log(kayıt) bilgileriniz (craving/slip).\n\n2. Bilgilerin Kullanımı\n- İçeriklerin kişiselleştirilmesi (örn: harcadığınız paradan tasarruf hesaplanması).\n- Uygulama deneyiminin iyileştirilmesi.\n\n3. Verilerin Depolanması ve Güvenliği\n- Verileriniz, uygulamanın çalışabilmesi için cihazınızda(Hive) saklanabildiği gibi bulut altyapısında(Google Firebase) da şifreli olarak depolanabilir. \n- Firebase üzerinden gerçekleşen tüm iletişim SSL ile korunur.\n\n4. 3. Taraf Paylaşımı\nLuno, bilgilerinizi açık rızanız dışında 3. taraflarla paylaşmaz veya satmaz.\n\n5. Haklarınız\nDilediğiniz zaman hesabınızın ve verilerinizin silinmesini talep edebilirsiniz.\n\nBize Ulaşın: Gizlilik ile ilgili tüm sorularınız için alagozdogu@gmail.com adresinden bizimle iletişime geçebilirsiniz.';

  @override
  String get recoveryProgressTitle => 'Toparlanma İlerlemesi';

  @override
  String get settingsCustomization => 'Ciğerito Özelleştirme';

  @override
  String get errorSimulation => 'Hata Ekranı Simülasyonu';
}
