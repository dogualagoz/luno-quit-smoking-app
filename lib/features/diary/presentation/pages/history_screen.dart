import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_error_widget.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/history_stats_card.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/history_calendar_card.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/today_summary_card.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null);
  }

  @override
  Widget build(BuildContext context) {
    final historyLogsState = ref.watch(historyLogsProvider);
    final userProfile = ref.watch(userProfileProvider);
    final theme = Theme.of(context);

    final double pricePerCigarette =
        (userProfile != null && userProfile.cigarettesPerPack > 0)
            ? userProfile.packPrice / userProfile.cigarettesPerPack
            : 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: historyLogsState.when(
          data: (logs) {
            if (logs.isEmpty) return _buildEmptyState(theme);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: AppSpacing.pageHorizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.p24),
                    Text('Günlüğüm 📖', style: AppTextStyles.header),
                    const SizedBox(height: 8),
                    Text(
                      'Atılan her adım, yazılan her satır daha temiz bir geleceğe.',
                      style: AppTextStyles.body
                          .copyWith(color: theme.hintColor),
                    ),
                    const SizedBox(height: AppSpacing.p24),
                    TodaySummaryCard(logs: logs),
                    const SizedBox(height: AppSpacing.p24),
                    HistoryStatsCard(logs: logs),
                    const SizedBox(height: AppSpacing.p24),
                    HistoryCalendarCard(
                      logs: logs,
                      pricePerCigarette: pricePerCigarette,
                    ),
                    const SizedBox(height: AppSpacing.p96),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => LunoErrorWidget(
            onRetry: () => ref.invalidate(historyLogsProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppSpacing.pageHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.p24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.p24),
            Text(
              'Henüz Kayıt Yok',
              style: AppTextStyles.pageHeader
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.p8),
            Text(
              'Sürecini başlatmak ve nasıl ilerlediğini görmek için ilk dürüst kaydını gir.',
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.body.copyWith(color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
