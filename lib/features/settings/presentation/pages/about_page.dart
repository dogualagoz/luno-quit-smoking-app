import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/constants/app_constants.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/settings/presentation/pages/terms_of_service_page.dart';
import 'package:luno_quit_smoking_app/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';

/// Hakkında sayfası — Uygulama bilgileri, bilimsel kaynaklar ve sorumluluk reddi.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // — Sabitler —
  static const String _appVersion = "1.0.0";
  static const String _disclaimerText =
      "Bu uygulama tıbbi tavsiye niteliğinde değildir. "
      "Sunulan veriler bilimsel kaynaklara dayanmakla birlikte, "
      "kişisel sağlık durumunuz için bir sağlık uzmanına danışınız. "
      "Uygulama, sigara bırakma sürecinize destek olmayı amaçlar; "
      "tedavi veya teşhis sunmaz.";

  static const List<_SourceItem> _sources = [
    _SourceItem(
      title: "American Cancer Society (ACS)",
      description: "Benefits of Quitting Smoking Over Time",
    ),
    _SourceItem(
      title: "U.S. Surgeon General",
      description: "Smoking Cessation: A Report (2020)",
    ),
    _SourceItem(
      title: "World Health Organization (WHO)",
      description: "Tobacco Fact Sheet",
    ),
    _SourceItem(
      title: "Centers for Disease Control (CDC)",
      description: "Health Effects of Cigarette Smoking",
    ),
    _SourceItem(
      title: "National Health Service (NHS)",
      description: "What Happens When You Quit Smoking",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: AppSpacing.pageHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.p12),

                // Geri Butonu
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),

                const SizedBox(height: AppSpacing.p12),

                // Başlık
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AssetConstants.cigeritoDefault,
                        height: AppMascotSizes.large,
                      ),
                      const SizedBox(height: AppSpacing.p8),
                      Text(
                        "Cigerito",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "v$_appVersion",
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.p32),

                // Sorumluluk Reddi (Disclaimer)
                LunoCard(
                  color: AppColors.lightChartWarning.withValues(alpha: 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: AppColors.lightChartWarning,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Sorumluluk Reddi",
                            style: AppTextStyles.cardHeader.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.p12),
                      Text(
                        _disclaimerText,
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.p24),

                // Bilimsel Kaynaklar
                LunoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.science_outlined,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Bilimsel Kaynaklar",
                            style: AppTextStyles.cardHeader.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.p16),
                      ..._sources.map(
                        (source) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      source.title,
                                      style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      source.description,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: theme.hintColor.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.p24),

                // Yasal Belgeler (Legal)
                LunoCard(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const TermsOfServicePage()),
                          );
                        },
                        leading: Icon(
                          Icons.gavel_rounded,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        title: Text(
                          "Kullanım Koşulları (TOS)",
                          style: AppTextStyles.bodySemibold,
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const PrivacyPolicyPage()),
                          );
                        },
                        leading: Icon(
                          Icons.privacy_tip_outlined,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        title: Text(
                          "Gizlilik Politikası",
                          style: AppTextStyles.bodySemibold,
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.p24),

                // İyileşme Zaman Çizelgesi
                LunoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.timeline_rounded,
                            size: 20,
                            color: AppColors.lightChartSuccess,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "İyileşme Zaman Çizelgesi",
                            style: AppTextStyles.cardHeader.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.p16),
                      ...RecoveryMilestones.timeline.map(
                        (milestone) =>
                            _buildMilestoneItem(context, milestone, theme),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.p40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneItem(
    BuildContext context,
    RecoveryMilestone milestone,
    ThemeData theme,
  ) {
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zaman çizelgesi çizgisi
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.lightChartSuccess,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.lightChartSuccess.withValues(alpha: 0.2),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Süre etiketi
                Text(
                  _formatDuration(milestone.duration),
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.lightChartSuccess,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                // Başlık
                Text(
                  milestone.title,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // Açıklama
                Text(
                  milestone.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
                // Kaynak
                Text(
                  "Kaynak: ${milestone.source}",
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.4),
                    fontSize: 9,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Duration'ı okunabilir formata çevirir.
  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 60) return "${duration.inMinutes} dakika";
    if (duration.inHours < 24) return "${duration.inHours} saat";
    if (duration.inDays < 30) return "${duration.inDays} gün";
    if (duration.inDays < 365) return "${duration.inDays ~/ 30} ay";
    return "${duration.inDays ~/ 365} yıl";
  }
}

/// Kaynak listesi için veri modeli.
class _SourceItem {
  final String title;
  final String description;

  const _SourceItem({required this.title, required this.description});
}
