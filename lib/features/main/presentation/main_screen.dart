import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/core/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/quote_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/stat_grid.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/main_header.dart';
import 'package:luno_quit_smoking_app/core/widgets/swipeable_damage_cards.dart';
import 'package:luno_quit_smoking_app/features/history/presentation/widgets/today_summary_card.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:luno_quit_smoking_app/features/history/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/mascot_animation.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_error_widget.dart';

// --- Ana Dashboard Ekranı (Uygulamanın Merkezi) ---
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // Navigasyon sırasında kriz kontrolünün birden fazla yapılmasını önleyen bayrak
  bool _hasCheckedCraving = false;

  @override
  Widget build(BuildContext context) {
    // Uygulama ilk açıldığında bugün log var mı kontrol et, yoksa Craving ekranını aç
    ref.listen(historyLogsProvider, (previous, next) {
      if (!_hasCheckedCraving && next is AsyncData) {
        _hasCheckedCraving = true;
        final logs = next.value ?? [];
        final today = DateTime.now();
        final hasLogForToday = logs.any(
          (log) =>
              log.date.year == today.year &&
              log.date.month == today.month &&
              log.date.day == today.day,
        );

        if (!hasLogForToday) {
          // Asenkron navigasyon uyarılarını engellemek için post-frame callback içinde çağır
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (GoRouter.of(
                  context,
                ).routerDelegate.currentConfiguration.uri.toString() !=
                AppRouter.craving) {
              context.push(AppRouter.craving);
            }
          });
        }
      }
    });

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
      // --- Yüzen Aksiyon Butonu (Yeni Kriz/Kaçamak Kaydı) ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRouter.craving),
        backgroundColor: Colors.pink.shade200,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
