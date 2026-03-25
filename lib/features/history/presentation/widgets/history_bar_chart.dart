import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class HistoryBarChart extends StatefulWidget {
  final Map<int, int> data;
  final String filter;

  const HistoryBarChart({
    super.key,
    required this.data,
    required this.filter,
  });

  @override
  State<HistoryBarChart> createState() => _HistoryBarChartState();
}

class _HistoryBarChartState extends State<HistoryBarChart> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _setInitialSelection();
  }

  void _setInitialSelection() {
    final now = DateTime.now();
    if (widget.filter == 'H') {
      touchedIndex = now.weekday - 1;
    } else if (widget.filter == 'A') {
      touchedIndex = now.day - 1;
    } else {
      touchedIndex = now.month - 1;
    }
  }

  @override
  void didUpdateWidget(HistoryBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      _setInitialSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGradient = LinearGradient(
      colors: [
        isDark ? const Color(0xFFD4789E) : const Color(0xFFE8A0BF),
        isDark ? const Color(0xFFB85E82) : const Color(0xFFD4789E),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

    return AspectRatio(
      aspectRatio: 1.8,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: _getMaxY(),
          minY: 0,
          barTouchData: BarTouchData(
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  return;
                }
                touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              });
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => isDark ? const Color(0xFF2D2640) : const Color(0xFFF0E6EF),
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final value = widget.data[group.x + 1] ?? 0;
                return BarTooltipItem(
                  '$value',
                  AppTextStyles.bodySemibold.copyWith(
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: ' \n${value == 1 ? 'sigara' : 'adet'}',
                      style: AppTextStyles.micro.copyWith(
                        color: isDark ? AppColors.darkForeground : AppColors.lightForeground,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getTitles,
                reservedSize: 32,
                interval: widget.filter == 'A' ? 5 : 1, // Ay gösteriminde her günü yazmasın
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getMaxY() / 3,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.2),
                strokeWidth: 1,
                dashArray: [8, 4],
              );
            },
          ),
          barGroups: _buildBarGroups(primaryGradient, isDark),
        ),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(LinearGradient gradient, bool isDark) {
    final List<BarChartGroupData> groups = [];
    final int count = widget.data.length;

    for (int i = 0; i < count; i++) {
      final double yValue = (widget.data[i + 1] ?? 0).toDouble();
      groups.add(
        _makeGroupData(
          i,
          yValue,
          gradient,
          i == touchedIndex,
          isDark,
          count,
        ),
      );
    }
    return groups;
  }

  double _getMaxY() {
    if (widget.data.isEmpty) return 10;
    final maxVal = widget.data.values.fold<int>(0, (p, e) => e > p ? e : p);
    return maxVal < 10 ? 12 : (maxVal * 1.3);
  }

  BarChartGroupData _makeGroupData(
    int x,
    double y,
    LinearGradient gradient,
    bool isTouched,
    bool isDark,
    int totalCount,
  ) {
    // Çubuk genişliği toplam çubuk sayısına göre dinamik (Ay'da daha ince, Hafta'da daha geniş)
    double width = 24.0;
    if (widget.filter == 'A') width = 8.0;
    if (widget.filter == 'Y') width = 16.0;

    final maxY = _getMaxY();
    
    // Görsel derinlik için minimum yükseklik
    double drawY = y;
    if (drawY < maxY * 0.03) drawY = maxY * 0.03;

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: drawY,
          gradient: isTouched ? gradient : null,
          color: isTouched ? null : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: 0.15),
          width: width,
          borderRadius: BorderRadius.circular(width / 2),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    final isTouched = index == touchedIndex;
    
    final style = TextStyle(
      color: isTouched 
          ? (Theme.of(context).brightness == Brightness.dark ? AppColors.darkForeground : AppColors.lightForeground)
          : Theme.of(context).hintColor.withValues(alpha: 0.5),
      fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
      fontSize: 11,
    );

    String text = '';
    if (widget.filter == 'H') {
      final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
      if (index >= 0 && index < 7) text = days[index];
    } else if (widget.filter == 'A') {
      // Aylıkta sadece 1, 5, 10, 15... gibi değerleri yaz
      if ((index + 1) % 5 == 0 || index == 0) {
        text = '${index + 1}';
      }
    } else {
      final months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
      if (index >= 0 && index < 12) text = months[index];
    }

    return SideTitleWidget(
      meta: meta,
      space: 12,
      child: Text(text, style: style),
    );
  }
}
