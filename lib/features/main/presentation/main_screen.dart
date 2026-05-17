import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_error_widget.dart';
import 'package:luno_quit_smoking_app/core/widgets/mascot_animation.dart';
import 'package:luno_quit_smoking_app/core/widgets/quote_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/widgets/stat_grid.dart';
import 'package:luno_quit_smoking_app/core/widgets/swipeable_damage_cards.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/today_summary_card.dart';
import 'package:luno_quit_smoking_app/features/main/application/stats_provider.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/daily_checkin_sheet.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/main_header.dart';
import 'package:luno_quit_smoking_app/features/main/presentation/widgets/smart_add_sheet.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasLogForToday()) {
        showDailyCheckinSheet(context, ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statsProvider);
    final profile = ref.watch(userProfileProvider);
    final userName = profile?.nickname ?? "Kullanıcı";

    return Scaffold(
      body: SafeArea(
        child: stats.when(
          data: (statsData) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainHeader(
                    userName: userName,
                    subText: statsData.prepSubtext,
                  ),
                  AppSpacing.sectionGapLarge,
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
                  SpeechBubble(text: statsData.prepSubtext),
                  AppSpacing.sectionGap,
                  SwipeableDamageCards(organs: statsData.organDamages),
                  AppSpacing.sectionGap,
                  StatGrid(stats: statsData),
                  AppSpacing.sectionGap,
                  TodaySummaryCard(
                    logs: ref.watch(historyLogsProvider).value ?? [],
                  ),
                  AppSpacing.sectionGap,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showSmartAddSheet(context, ref),
        backgroundColor: Colors.pink.shade200,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  bool _hasLogForToday() {
    final logs = ref.read(historyLogsProvider).value ?? [];
    final today = DateTime.now();
    return logs.any((log) =>
        log.date.year == today.year &&
        log.date.month == today.month &&
        log.date.day == today.day);
  }
}
