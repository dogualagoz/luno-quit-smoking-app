import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanım Koşulları (TOS)'),
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
              "Luno Uygulaması Kullanım Koşulları",
              style: AppTextStyles.cardHeader,
            ),
            const SizedBox(height: AppSpacing.p16),
            Text(
              """
Son Güncelleme: 1 Ocak 2026

1. Kabul Edilme
Luno uygulamasını ("Uygulama") kullanarak, işbu Kullanım Koşullarını ("Koşullar") kabul etmiş olursunuz. Eğer bu koşulları kabul etmiyorsanız, Uygulamayı kullanmamalısınız.

2. Hizmetin Doğası
Luno, sigarayı bırakma sürecinize yardımcı olmak amacıyla tasarlanmış bir motivasyon ve takip aracıdır. Uygulama tıbbi teşhis, tavsiye veya tedavi sunmaz. Tıbbi durumlar için nitelikli bir sağlık uzmanına başvurmanız gerekmektedir.

3. Kullanıcı Hesabı
- Uygulamayı kullanmak için oluşturduğunuz hesabın güvenliğinden siz sorumlusunuz.
- Verileriniz cihazınızda veya kendi rızanızla bulut ortamında (Firebase) saklanabilir.

4. Sorumluluk Reddi
Luno geliştiricileri, uygulamanın kullanımından kaynaklanabilecek doğrudan veya dolaylı hiçbir zarardan sorumlu tutulamaz.

5. Değişiklikler
Luno, işbu Koşulları önceden haber vermeksizin dilediği zaman değiştirme hakkını saklı tutar.

İletişim: Geri bildirim ve destek için Uygulama içerisindeki iletişim araçlarını kullanabilirsiniz.
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
