import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gizlilik Politikası'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pageHorizontal.copyWith(
          top: AppSpacing.p24,
          bottom: AppSpacing.p96,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Luno Uygulaması Gizlilik Politikası",
              style: AppTextStyles.cardHeader,
            ),
            const SizedBox(height: AppSpacing.p16),
            Text(
              """
Son Güncelleme: 1 Ocak 2026

Luno olarak gizliliğinize büyük önem veriyoruz. Bu politika, sizin hakkınızdaki bilgilerin nasıl toplandığını, kullanıldığını ve korunduğunu açıklar.

1. Toplanan Bilgiler
- Kişisel Bilgiler: Tarafınızdan gönüllü olarak sağlanan e-posta adresi ve giriş bilgileri.
- Uygulama Verileri: Günlük içilen sigara adedi, yaş, sigara fiyatı gibi profil bilgileri ile History sayfasında tutulan log(kayıt) bilgileriniz (craving/slip).

2. Bilgilerin Kullanımı
- İçeriklerin kişiselleştirilmesi (örn: harcadığınız paradan tasarruf hesaplanması).
- Uygulama deneyiminin iyileştirilmesi.

3. Verilerin Depolanması ve Güvenliği
- Verileriniz, uygulamanın çalışabilmesi için cihazınızda(Hive) saklanabildiği gibi bulut altyapısında(Google Firebase) da şifreli olarak depolanabilir. 
- Firebase üzerinden gerçekleşen tüm iletişim SSL ile korunur.

4. 3. Taraf Paylaşımı
Luno, bilgilerinizi açık rızanız dışında 3. taraflarla paylaşmaz veya satmaz.

5. Haklarınız
Dilediğiniz zaman hesabınızın ve verilerinizin silinmesini talep edebilirsiniz.

Bize Ulaşın: Gizlilik ile ilgili tüm sorularınız için alagozdogu@gmail.com adresinden bizimle iletişime geçebilirsiniz.
              """,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
