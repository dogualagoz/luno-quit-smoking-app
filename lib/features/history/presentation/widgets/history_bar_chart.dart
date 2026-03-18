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
    // Varsayılan olarak bugünü seçili gösterebiliriz
    int todayIndex = DateTime.now().weekday - 1;
    touchedIndex = todayIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

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
            // Tooltip göstermiyoruz, daha temiz bir görünüm istendi
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.transparent, // görünmez yapalım
              tooltipMargin: 0,
              getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
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
          gridData: const FlGridData(show: false),
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
    return maxVal < 10 ? 10 : (maxVal + 2).toDouble();
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
    Color primaryColor,
    bool isTouched,
  ) {
    // Tasarımdaki gibi: seçiliyse tam renk, değilse çok uçuk bir renk (%15)
    final barColor = isTouched
        ? primaryColor
        : primaryColor.withValues(alpha: 0.15);

    // Yüksekliği minimum bir değere sabitleyelim ki 0 da olsa yuvarlak bir bar görünsün
    double drawY = y;
    if (drawY == 0) drawY = 0.5; // En azından bir ufak çıkıntı olsun

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: drawY,
          color: barColor,
          width: 28, // Sütunları çok daha kalınlaştırdık (mockupta olduğu gibi)
          borderRadius: BorderRadius.circular(
            8,
          ), // Köşeleri hafif hatlı ama modern yuvarlaklıkta
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final isTouched = value.toInt() == touchedIndex;
    final style = isTouched
        ? AppTextStyles.label.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )
        : AppTextStyles.label.copyWith(
            color: Colors.grey.withValues(alpha: 0.6),
            fontWeight: FontWeight.normal,
          );

    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Pzt';
        break;
      case 1:
        text = 'Sal';
        break;
      case 2:
        text = 'Çar';
        break;
      case 3:
        text = 'Per';
        break;
      case 4:
        text = 'Cum';
        break;
      case 5:
        text = 'Cmt';
        break;
      case 6:
        text = 'Paz';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 12,
      child: Text(text, style: style),
    );
  }
}
