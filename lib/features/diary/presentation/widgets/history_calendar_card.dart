import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/features/diary/presentation/widgets/daily_log_card.dart';

const int _kStartOfWeekDay = 1; // Monday

/// Monthly calendar with a day-tap detail panel.
/// Manages month-offset and selected-day state internally.
class HistoryCalendarCard extends StatefulWidget {
  final List<DailyLog> logs;
  final double pricePerCigarette;

  const HistoryCalendarCard({
    super.key,
    required this.logs,
    required this.pricePerCigarette,
  });

  @override
  State<HistoryCalendarCard> createState() => _HistoryCalendarCardState();
}

class _HistoryCalendarCardState extends State<HistoryCalendarCard> {
  int _monthOffset = 0;
  DateTime? _selectedDay;

  DateTime _monthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + _monthOffset, 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthStart = _monthStart();
    final startOfGrid = monthStart.subtract(
      Duration(days: monthStart.weekday - _kStartOfWeekDay),
    );
    final nextMonthStart =
        DateTime(monthStart.year, monthStart.month + 1, 1);
    final daysInMonth = nextMonthStart.difference(monthStart).inDays;
    final totalDaysNeeded =
        (monthStart.weekday - _kStartOfWeekDay) + daysInMonth;
    final totalWeeks = (totalDaysNeeded / 7).ceil();
    final gridDays = List.generate(
      totalWeeks * 7,
      (i) => startOfGrid.add(Duration(days: i)),
    );

    final Set<String> loggedDays = widget.logs.map((log) {
      final d = log.date;
      return '${d.year}-${d.month}-${d.day}';
    }).toSet();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<DailyLog> selectedDayLogs = [];
    if (_selectedDay != null) {
      selectedDayLogs = widget.logs
          .where((log) =>
              log.date.year == _selectedDay!.year &&
              log.date.month == _selectedDay!.month &&
              log.date.day == _selectedDay!.day)
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Günler', style: AppTextStyles.cardHeader),
        const SizedBox(height: AppSpacing.p12),
        LunoCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MonthArrow(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => setState(() => _monthOffset--),
                  ),
                  Text(
                    DateFormat('MMMM yyyy', 'tr_TR').format(monthStart),
                    style: AppTextStyles.bodySemibold.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  _MonthArrow(
                    icon: Icons.chevron_right_rounded,
                    onTap: _monthOffset < 0
                        ? () => setState(() => _monthOffset++)
                        : null,
                    disabled: _monthOffset >= 0,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.p16),
              Row(
                children: _CalendarDayCell.weekdayLabels
                    .skip(1)
                    .map((label) => Expanded(
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              ...List.generate(totalWeeks, (weekIndex) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: List.generate(7, (dayIndex) {
                      final day = gridDays[weekIndex * 7 + dayIndex];
                      final dayKey = '${day.year}-${day.month}-${day.day}';
                      final hasLog = loggedDays.contains(dayKey);
                      final isToday = day == today;
                      final isSelected = _selectedDay != null &&
                          day.year == _selectedDay!.year &&
                          day.month == _selectedDay!.month &&
                          day.day == _selectedDay!.day;
                      final isFuture = day.isAfter(today);
                      final isCurrentMonth = day.month == monthStart.month;

                      return Expanded(
                        child: GestureDetector(
                          onTap: (isFuture || !isCurrentMonth)
                              ? null
                              : () => setState(() {
                                    _selectedDay =
                                        isSelected ? null : day;
                                  }),
                          child: _CalendarDayCell(
                            day: day,
                            hasLog: hasLog,
                            isToday: isToday,
                            isSelected: isSelected,
                            isFuture: isFuture,
                            isCurrentMonth: isCurrentMonth,
                            primary: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ],
          ),
        ),
        if (_selectedDay != null) ...[
          const SizedBox(height: AppSpacing.p16),
          _SelectedDayDetail(
            selectedDay: _selectedDay!,
            logs: selectedDayLogs,
            pricePerCigarette: widget.pricePerCigarette,
          ),
        ],
      ],
    );
  }
}

class _MonthArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const _MonthArrow({
    required this.icon,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: disabled
              ? Colors.transparent
              : primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: disabled
              ? Theme.of(context).hintColor.withValues(alpha: 0.3)
              : primary,
        ),
      ),
    );
  }
}

class _SelectedDayDetail extends StatelessWidget {
  final DateTime selectedDay;
  final List<DailyLog> logs;
  final double pricePerCigarette;

  const _SelectedDayDetail({
    required this.selectedDay,
    required this.logs,
    required this.pricePerCigarette,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr =
        DateFormat('dd MMMM yyyy, EEEE', 'tr_TR').format(selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              dateStr,
              style: AppTextStyles.bodySemibold.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.p12),
        if (logs.isEmpty)
          LunoCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.p8),
              child: Center(
                child: Text(
                  'Bu gün için kayıt yok.',
                  style: AppTextStyles.body.copyWith(color: theme.hintColor),
                ),
              ),
            ),
          )
        else
          ...logs.map(
            (log) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.p12),
              child: DailyLogCard(
                log: log,
                pricePerCigarette: pricePerCigarette,
              ),
            ),
          ),
      ],
    );
  }
}

/// Single cell in the calendar grid.
class _CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final bool hasLog;
  final bool isToday;
  final bool isSelected;
  final bool isFuture;
  final bool isCurrentMonth;
  final Color primary;

  const _CalendarDayCell({
    required this.day,
    required this.hasLog,
    required this.isToday,
    required this.isSelected,
    required this.isFuture,
    required this.isCurrentMonth,
    required this.primary,
  });

  static const List<String> weekdayLabels = [
    '',
    'Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pa',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bgColor;
    Color textColor;
    Color borderColor;

    if (!isCurrentMonth) {
      bgColor = Colors.transparent;
      textColor = theme.hintColor.withValues(alpha: 0.2);
      borderColor = Colors.transparent;
    } else if (isSelected) {
      bgColor = primary;
      textColor = Colors.white;
      borderColor = primary;
    } else if (isToday) {
      bgColor = primary.withValues(alpha: 0.12);
      textColor = primary;
      borderColor = primary.withValues(alpha: 0.4);
    } else if (hasLog) {
      bgColor = primary.withValues(alpha: 0.07);
      textColor = theme.colorScheme.onSurface;
      borderColor = primary.withValues(alpha: 0.2);
    } else {
      bgColor = Colors.transparent;
      textColor = isFuture
          ? theme.hintColor.withValues(alpha: 0.35)
          : theme.hintColor.withValues(alpha: 0.6);
      borderColor = Colors.transparent;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${day.day}',
              style: AppTextStyles.bodySemibold.copyWith(
                color: textColor,
                fontSize: 14,
                fontWeight: isToday || isSelected
                    ? FontWeight.w800
                    : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedOpacity(
              opacity: (hasLog && isCurrentMonth) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
