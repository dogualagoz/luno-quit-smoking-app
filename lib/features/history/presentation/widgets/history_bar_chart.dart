import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class HistoryBarChart extends StatefulWidget {
  final Map<int, int> weeklyData;

  const HistoryBarChart({super.key, required this.weeklyData});

  @override
  State<HistoryBarChart> createState() => _HistoryBarChartState();
}

class _HistoryBarChartState extends State<HistoryBarChart> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    int todayIndex = DateTime.now().weekday - 1;
    touchedIndex = todayIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return AspectRatio(
      aspectRatio: 1.8,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
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
              getTooltipColor: (_) => isDark ? AppColors.darkForeground : AppColors.lightForeground,
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final value = widget.weeklyData[group.x + 1] ?? 0;
                return BarTooltipItem(
                  '$value \n',
                  AppTextStyles.bodySemibold.copyWith(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  children: [
                    TextSpan(
                      text: value == 1 ? 'sigara' : 'adet',
                      style: AppTextStyles.micro.copyWith(
                        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
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
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getMaxY() / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                strokeWidth: 1,
                dashArray: [4, 4],
              );
            },
          ),
          barGroups: [
            for (int i = 1; i <= 7; i++)
              makeGroupData(
                i - 1,
                (widget.weeklyData[i] ?? 0).toDouble(),
                primaryColor,
                i - 1 == touchedIndex,
              ),
          ],
        ),
      ),
    );
  }

  double _getMaxY() {
    if (widget.weeklyData.isEmpty) return 10;
    final maxVal = widget.weeklyData.values.reduce(
      (curr, next) => curr > next ? curr : next,
    );
    return maxVal < 10 ? 10 : (maxVal * 1.5); // Add some padding on top for tooltip
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
    Color primaryColor,
    bool isTouched,
  ) {
    // Fotoğraftaki gibi: aktifse tam renk, inaktifse çok hafif pembe arka planı
    final barColor = isTouched ? primaryColor : primaryColor.withValues(alpha: 0.12);

    // Çubukların hap şeklinde kalması için minimum bir değere sahip olmaları gerek.
    // Çünkü değer 0 olunca hiç bir şey çizilmiyor veya kutu gibi oluyor.
    double drawY = y;
    final maxY = _getMaxY();
    // 0 ise bile en dibinde ufak bir yuvarlak olsun (MaxY değerinin %5'i kadar)
    if (drawY == 0) {
      drawY = maxY * 0.05; 
    } else if (drawY < maxY * 0.05) {
      // Y değeri çok küçükse mininum yüksekliğe sabitle
      drawY = maxY * 0.05;
    }

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: drawY,
          color: barColor,
          width: 26, // Fotoğraftaki gibi dolgun çubuklar
          borderRadius: BorderRadius.circular(100), // Tam yuvarlak kapama (hap şeklinde)
          backDrawRodData: BackgroundBarChartRodData(
            show: isTouched, // Yalnızca seçiliyken arkasında puslu bir şerit çıksın (opsiyonel vurgu)
            toY: maxY,
            color: primaryColor.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final isTouched = value.toInt() == touchedIndex;
    final style = isTouched
        ? AppTextStyles.label.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          )
        : AppTextStyles.label.copyWith(
            color: Theme.of(context).hintColor.withValues(alpha: 0.6),
            fontWeight: FontWeight.normal,
          );

    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final text = (value.toInt() >= 0 && value.toInt() < 7) ? days[value.toInt()] : '';
    
    return SideTitleWidget(
      meta: meta,
      space: 12,
      child: Text(text, style: style),
    );
  }
}
