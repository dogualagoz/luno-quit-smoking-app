import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/history_bar_chart.dart';

/// Card showing average cigarette count + bar chart with H/A/Y filter toggle.
/// Manages its own filter state internally.
class HistoryStatsCard extends StatefulWidget {
  final List<DailyLog> logs;

  const HistoryStatsCard({super.key, required this.logs});

  @override
  State<HistoryStatsCard> createState() => _HistoryStatsCardState();
}

class _HistoryStatsCardState extends State<HistoryStatsCard> {
  String _selectedFilter = 'A';

  Map<int, int> _calculateChartData(List<DailyLog> logs) {
    final now = DateTime.now();
    Map<int, int> data = {};

    if (_selectedFilter == 'H') {
      for (int i = 1; i <= 7; i++) {
        data[i] = 0;
      }
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfDay =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      for (var log in logs) {
        if (_logType(log) == 'slip' && !log.date.isBefore(startOfDay)) {
          data[log.date.weekday] = data[log.date.weekday]! + log.smokeCount;
        }
      }
    } else if (_selectedFilter == 'A') {
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      for (int i = 1; i <= daysInMonth; i++) {
        data[i] = 0;
      }
      final startOfMonth = DateTime(now.year, now.month, 1);
      for (var log in logs) {
        if (_logType(log) == 'slip' && !log.date.isBefore(startOfMonth)) {
          data[log.date.day] = data[log.date.day]! + log.smokeCount;
        }
      }
    } else {
      for (int i = 1; i <= 12; i++) {
        data[i] = 0;
      }
      final startOfYear = DateTime(now.year, 1, 1);
      for (var log in logs) {
        if (_logType(log) == 'slip' && !log.date.isBefore(startOfYear)) {
          data[log.date.month] = data[log.date.month]! + log.smokeCount;
        }
      }
    }
    return data;
  }

  String _logType(DailyLog log) => log.type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chartData = _calculateChartData(widget.logs);

    final now = DateTime.now();
    final totalSum = chartData.values.fold(0, (sum, val) => sum + val);
    int elapsedDays = 1;
    if (_selectedFilter == 'H') {
      elapsedDays = now.weekday;
    } else if (_selectedFilter == 'A') {
      elapsedDays = now.day;
    } else {
      elapsedDays = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    }
    final double average = elapsedDays > 0 ? totalSum / elapsedDays : 0;

    return LunoCard(
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'İstatistikler',
                style: AppTextStyles.cardHeader.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              _buildFilterButtons(isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                average.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), ''),
                style: AppTextStyles.largeNumber.copyWith(
                  fontSize: 48,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'sigara/gün',
                style: AppTextStyles.body.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _selectedFilter == 'H'
                ? 'Bu hafta boyunca ortalama'
                : _selectedFilter == 'A'
                    ? 'Bu ay boyunca ortalama'
                    : 'Bu yıl boyunca ortalama',
            style: AppTextStyles.label.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
          HistoryBarChart(data: chartData, filter: _selectedFilter),
        ],
      ),
    );
  }

  Widget _buildFilterButtons(bool isDark) {
    return Row(
      children: ['H', 'A', 'Y'].map((filter) {
        final isSelected = _selectedFilter == filter;
        return GestureDetector(
          onTap: () => setState(() => _selectedFilter = filter),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? AppColors.darkChartPrimary
                      : AppColors.lightChartPrimary)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Text(
              filter,
              style: AppTextStyles.label.copyWith(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
