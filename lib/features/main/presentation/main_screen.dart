import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/quote_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/stat_grid.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/main_header.dart';
import 'package:luno_quit_smoking_app/core/widgets/swipeable_damage_cards.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/today_summary_card.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/mascot_animation.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_error_widget.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import 'package:uuid/uuid.dart';

// --- Ana Dashboard Ekranı (Uygulamanın Merkezi) ---
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Sayfa oluştuktan sonra, bugün log yoksa check-in pop-up'u göster
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasLogForToday()) {
        _showCheckinPopup(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- Durum İzleme (İstatistikler ve Kullanıcı Verileri) ---
    final stats = ref.watch(statsProvider);
    final profile = ref.watch(userProfileProvider);
    final userName = profile?.nickname ?? "Kullanıcı";

    return Scaffold(
      body: SafeArea(
        // --- İçerik Yükleme Durumu Yönetimi ---
        child: stats.when(
          data: (statsData) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dinamik Başlık
                  MainHeader(
                    userName: userName,
                    subText: statsData.prepSubtext,
                  ),

                  AppSpacing.sectionGapLarge,

                  // Dinamik Maskot Bölümü
                  Center(
                    child: MascotAnimation(
                      child: SvgPicture.asset(
                        statsData.type == QuitStatType.success
                            ? AssetConstants.cigeritoDefault
                            : AssetConstants.cigeritoSad,
                        height: AppMascotSizes.xLarge,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Konuşma Balonu
                  SpeechBubble(text: statsData.prepSubtext),
                  AppSpacing.sectionGap,

                  // Organ Hasar Kartları
                  SwipeableDamageCards(organs: statsData.organDamages),
                  AppSpacing.sectionGap,

                  // --- Kullanıcı Bilgileri ve Aktivite Kayıtları Bölümü ---
                  
                  // Sağlık göstergelerini gösteren özet grid (Akciğer, Kalp vb.)
                  StatGrid(stats: statsData),
                  AppSpacing.sectionGap,

                  // Günlük sigara, maliyet ve zaman özeti (Etkileşimli Slider Kartı)
                  TodaySummaryCard(logs: ref.watch(historyLogsProvider).value ?? []),

                  AppSpacing.sectionGap,

                  // Motivasyon Kartı (Alıntı Kartı)
                  const QuoteCard(
                    quote:
                        "Her sigara hayatından 11 dakika çalar. Ama sen zaten zamanı dumanla harcamayı seviyorsun, değil mi?",
                    author: "Ciğerito, senin akciğer dostun",
                  ),

                  const SizedBox(height: AppSpacing.p96),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => LunoErrorWidget(
            onRetry: () => ref.invalidate(statsProvider),
          ),
        ),
      ),
      // --- FAB: Akıllı Kayıt Menüsü ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSmartAddSheet(context),
        backgroundColor: Colors.pink.shade200,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Bugün log var mı kontrolü
  bool _hasLogForToday() {
    final logs = ref.read(historyLogsProvider).value ?? [];
    final today = DateTime.now();
    return logs.any((log) =>
        log.date.year == today.year &&
        log.date.month == today.month &&
        log.date.day == today.day);
  }

  /// Bugün log girilmemişse otomatik açılan günlük check-in bottom sheet'i
  void _showCheckinPopup(BuildContext context) {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark
        ? theme.colorScheme.surface
        : AppColors.lightBackground;
    final successColor =
        isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final warningColor =
        isDark ? AppColors.darkChartWarning : AppColors.lightChartWarning;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.p20,
              AppSpacing.p16,
              AppSpacing.p20,
              AppSpacing.p32,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              // Tema.md shadow-sm
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.p20),

                // Başlık satırı
                Text(
                  'Bugün nasıl gidiyor?',
                  style: AppTextStyles.cardHeader.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.p8),
                Text(
                  'Ciğerito merak ediyor...',
                  style: AppTextStyles.caption.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.p24),

                // Seçenek kartları (Tema.md StatCard anatomy)
                Row(
                  children: [
                    // Temiz Gün
                    Expanded(
                      child: _CheckinOptionCard(
                        icon: Icons.shield_outlined,
                        title: 'Temiz Gün',
                        subtitle: 'İçmedim ✨',
                        color: successColor,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pop(sheetContext);
                          _saveCleanDay();
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.p12),

                    // Birkaç Dal
                    Expanded(
                      child: _CheckinOptionCard(
                        icon: Icons.smoking_rooms_outlined,
                        title: 'Birkaç Dal',
                        subtitle: 'Kaydet 📝',
                        color: primary,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(sheetContext);
                          _showQuickCountSheet(context);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.p12),

                    // Zor Gün
                    Expanded(
                      child: _CheckinOptionCard(
                        icon: Icons.thunderstorm_outlined,
                        title: 'Zor Gün',
                        subtitle: 'Detaylı ⚡',
                        color: warningColor,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(sheetContext);
                          context.push(AppRouter.craving);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.p20),

                // Alt kapatma linki
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: Text(
                      'Sonra Hatırlat',
                      style: AppTextStyles.bodySemibold.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Temiz gün kaydı oluştur
  void _saveCleanDay() {
    final log = DailyLog(
      id: const Uuid().v4(),
      date: DateTime.now(),
      cravingIntensity: 0,
      hasSmoked: false,
      smokeCount: 0,
      type: 'craving',
      moods: const [],
      context: const [],
      companions: const [],
      note: 'Temiz Gün ✨',
    );
    ref.read(historyLogsProvider.notifier).addLog(log);
    ref.read(analyticsServiceProvider).logCravingResisted(intensity: 0);
  }

  // FAB'dan açılan akıllı kayıt menüsü
  void _showSmartAddSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? Theme.of(context).colorScheme.surface
        : AppColors.lightBackground;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final successColor =
        isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.p24),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.p24),
                Text(
                  'Kayıt Ekle',
                  style: AppTextStyles.cardHeader.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppSpacing.p8),
                Text(
                  'Dürüstçe kaydetmek en büyük adımdır.',
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.p24),

                // Seçenek 1: Hızlı 1 sigara
                _buildSheetOption(
                  context: context,
                  icon: Icons.flash_on_rounded,
                  title: 'Sadece 1 sigara ekle',
                  color: primary,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(sheetContext);
                    _quickAddOne();
                  },
                ),
                const SizedBox(height: AppSpacing.p12),

                // Seçenek 2: Detaylı kayıt
                _buildSheetOption(
                  context: context,
                  icon: Icons.edit_note_rounded,
                  title: 'Detaylı kayıt',
                  color: primary,
                  isPrimary: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push(AppRouter.craving);
                  },
                ),
                const SizedBox(height: AppSpacing.p12),

                // Seçenek 3: Krize direndim
                _buildSheetOption(
                  context: context,
                  icon: Icons.shield_outlined,
                  title: 'Krize direndim',
                  color: successColor,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push(AppRouter.craving, extra: false);
                  },
                ),
                const SizedBox(height: AppSpacing.p24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Bottom sheet seçenek widgetı
  Widget _buildSheetOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        child: LunoButton(
          text: title,
          icon: icon,
          onPressed: onTap,
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: Icon(icon),
        label: Text(title),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isDark
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Colors.grey.shade200,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  // Tek tıkla 1 sigara kaydet
  void _quickAddOne() {
    final log = DailyLog(
      id: const Uuid().v4(),
      date: DateTime.now(),
      cravingIntensity: 0,
      hasSmoked: true,
      smokeCount: 1,
      type: 'slip',
      moods: const [],
      context: const [],
      companions: const [],
    );
    ref.read(historyLogsProvider.notifier).addLog(log);
    ref.read(analyticsServiceProvider).logSmokeLogged(count: 1);
  }

  // "Birkaç Dal" için sayı seçici bottom sheet
  void _showQuickCountSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? Theme.of(context).colorScheme.surface
        : AppColors.lightBackground;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    int count = 1;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return SafeArea(
              bottom: true,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.p24),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.p24),
                    Text(
                      'Kaç tane oldu?',
                      style: AppTextStyles.cardHeader.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: AppSpacing.p32),

                    // Sayı seçici
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCountButton(
                          icon: Icons.remove,
                          color: primary,
                          onTap: () {
                            if (count > 1) {
                              HapticFeedback.selectionClick();
                              setSheetState(() => count--);
                            }
                          },
                        ),
                        const SizedBox(width: 32),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) {
                            return ScaleTransition(scale: anim, child: child);
                          },
                          child: Text(
                            count.toString(),
                            key: ValueKey(count),
                            style: AppTextStyles.largeNumber.copyWith(
                              fontSize: 48,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        _buildCountButton(
                          icon: Icons.add,
                          color: primary,
                          onTap: () {
                            if (count < 99) {
                              HapticFeedback.selectionClick();
                              setSheetState(() => count++);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'sigara',
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.p32),

                    // Kaydet butonu
                    SizedBox(
                      width: double.infinity,
                      child: LunoButton(
                        text: 'Kaydet',
                        icon: Icons.check,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pop(sheetContext);
                          _quickAddCount(count);
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.p12),

                    // İptal
                    TextButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: Text(
                        'İptal',
                        style: AppTextStyles.bodySemibold.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Belirtilen sayıda sigara kaydet
  void _quickAddCount(int count) {
    final log = DailyLog(
      id: const Uuid().v4(),
      date: DateTime.now(),
      cravingIntensity: 0,
      hasSmoked: true,
      smokeCount: count,
      type: 'slip',
      moods: const [],
      context: const [],
      companions: const [],
    );
    ref.read(historyLogsProvider.notifier).addLog(log);
    ref.read(analyticsServiceProvider).logSmokeLogged(count: count);
  }

  Widget _buildCountButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}

/// Pop-up check-in içindeki tek seçenek kartı.
/// Tema.md StatCard anatomisine uygun; renk, ikon, başlık ve altyazı alır.
class _CheckinOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CheckinOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CheckinOptionCard> createState() => _CheckinOptionCardState();
}

class _CheckinOptionCardState extends State<_CheckinOptionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            // Tema.md: card bg + border renkleri
            color: _pressed
                ? widget.color.withValues(alpha: 0.14)
                : widget.color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? widget.color.withValues(alpha: 0.35)
                  : widget.color.withValues(alpha: 0.18),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // İkon kabı — Tema.md: icon container radius 12px, padding 10px
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(height: 10),
              // Başlık — Tema.md: body semibold 13.6px
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySemibold.copyWith(
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              // Alt yazı — Tema.md: caption 12.5px, primary renk
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: widget.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
