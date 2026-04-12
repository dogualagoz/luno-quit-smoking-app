import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class HistoryBarChart extends StatefulWidget {
  final Map<int, int> data;
  final String filter;

  const HistoryBarChart({super.key, required this.data, required this.filter});

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

    // Premium degrade renk paleti
    final primaryGradient = LinearGradient(
      colors: [
        isDark ? const Color(0xFFE8A0BF) : const Color(0xFFFFB6C1),
        isDark ? const Color(0xFFC24A75) : const Color(0xFFD4789E),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

    // Seçili durumlarda parlayan özel degrade
    final touchedGradient = LinearGradient(
      colors: [
        isDark ? const Color(0xFFFFBDE1) : const Color(0xFFFFD1DC),
        isDark ? const Color(0xFFE84A86) : const Color(0xFFE85C92),
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
                
                final newIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                final now = DateTime.now();
                bool isFuture = false;
                if (widget.filter == 'H') {
                  isFuture = newIndex > now.weekday - 1;
                } else if (widget.filter == 'A') {
                  isFuture = newIndex > now.day - 1;
                } else if (widget.filter == 'Y') {
                  isFuture = newIndex > now.month - 1;
                }

                if (!isFuture) {
                  touchedIndex = newIndex;
                }
              });
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) =>
                  isDark ? const Color(0xFF382F4E) : const Color(0xFFFBEBF2),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              tooltipMargin: 12,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final value = widget.data[group.x + 1] ?? 0;
                String subText = 'sigara ölçümü';
                if (value == 0)
                  subText = 'Oley! Temiz gün 🌱';
                else if (value > 5)
                  subText = 'Dikkatli ol! ⚠️';
                else
                  subText = 'Kontrol sende 👍';

                return BarTooltipItem(
                  '$value ',
                  AppTextStyles.largeNumber.copyWith(
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    fontSize: 24, // Premium büyük rakamlar
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'adet\n',
                      style: AppTextStyles.bodySemibold.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: subText,
                      style: AppTextStyles.label.copyWith(
                        color: isDark
                            ? AppColors.darkForeground
                            : AppColors.lightForeground,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
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
                reservedSize: 36,
                interval: widget.filter == 'A' ? 5 : 1,
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
            horizontalInterval: _getMaxY() / 3,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                    .withValues(alpha: 0.15),
                strokeWidth: 2,
                dashArray: [6, 6], // Noktalı şık çizgiler
              );
            },
          ),
          barGroups: _buildBarGroups(primaryGradient, touchedGradient, isDark),
        ),
        duration: const Duration(
          milliseconds: 400,
        ), // Dokundukça daha hızlı, tok hissiyatlı reaksiyon
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(
    LinearGradient gradient,
    LinearGradient touchedGradient,
    bool isDark,
  ) {
    final List<BarChartGroupData> groups = [];
    final int count = widget.data.length;

    for (int i = 0; i < count; i++) {
      final double yValue = (widget.data[i + 1] ?? 0).toDouble();
      groups.add(
        _makeGroupData(
          i,
          yValue,
          gradient,
          touchedGradient,
          i == touchedIndex,
          isDark,
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
    LinearGradient touchedGradient,
    bool isTouched,
    bool isDark,
  ) {
    // Gelecek günleri hesapla
    final now = DateTime.now();
    bool isFuture = false;
    if (widget.filter == 'H') {
      isFuture = x > now.weekday - 1;
    } else if (widget.filter == 'A') {
      isFuture = x > now.day - 1;
    } else if (widget.filter == 'Y') {
      isFuture = x > now.month - 1;
    }

    // Normal ve 'Dokunulmuş' (Hover/Focus) durumlarındaki kalınlıklar
    double normalWidth = 20.0;
    double touchedWidth = 28.0;

    if (widget.filter == 'A') {
      normalWidth = 6.0;
      touchedWidth = 12.0;
    }
    if (widget.filter == 'Y') {
      normalWidth = 14.0;
      touchedWidth = 22.0;
    }

    final maxY = _getMaxY();
    double drawY = y;
    
    if (isFuture) {
      drawY = 0; // Gelecek için hiçbir çizim olmasın
    } else if (drawY < maxY * 0.05) {
      drawY = maxY * 0.05; // Geçmişte 0 olanlarda hafif çıkıntı (nokta) görünsün
    }

    return BarChartGroupData(
      x: x,
      // Seçili gruptaki metin vs barın daha net görünmesi için ufak bir animasyon etkisi
      showingTooltipIndicators: isTouched && !isFuture ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: drawY,
          gradient: isFuture ? null : (isTouched ? touchedGradient : gradient),
          // Gelecek günler tamamen şeffaf, diğerleri normal
          color: isFuture 
              ? Colors.transparent 
              : (isTouched
                  ? null
                  : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                        .withValues(alpha: 0.4)),
          width: isTouched && !isFuture ? touchedWidth : normalWidth,
          borderRadius: BorderRadius.circular(
            isTouched && !isFuture ? touchedWidth / 2 : normalWidth / 2,
          ), // Premium yuvarlak silindir
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            // Sütunların aktığı o soluk zemin pisti (Gelecek için biraz daha silik)
            color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                .withValues(alpha: isFuture ? 0.03 : 0.08),
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
          ? (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87)
          : Theme.of(context).hintColor.withValues(alpha: 0.6),
      fontWeight: isTouched
          ? FontWeight.w800
          : FontWeight.w500, // Aktif metin ekstra kalın ve güçlü
      fontSize: isTouched ? 13 : 11, // Seçili gün adı öne fırlar
    );

    String text = '';
    if (widget.filter == 'H') {
      final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
      if (index >= 0 && index < 7) text = days[index];
    } else if (widget.filter == 'A') {
      if ((index + 1) % 5 == 0 || index == 0) {
        text = '${index + 1}';
      }
    } else {
      final months = [
        'Oca',
        'Şub',
        'Mar',
        'Nis',
        'May',
        'Haz',
        'Tem',
        'Ağu',
        'Eyl',
        'Eki',
        'Kas',
        'Ara',
      ];
      if (index >= 0 && index < 12) text = months[index];
    }

    return SideTitleWidget(
      meta: meta,
      space: 14,
      child: AnimatedDefaultTextStyle(
        // Metin tarzı da animasyonlu değişsin (Premium hissiyat)
        duration: const Duration(milliseconds: 300),
        style: style,
        child: Text(text),
      ),
    );
  }
}
