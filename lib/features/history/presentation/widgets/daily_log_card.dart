import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/history/data/models/daily_log.dart';

class DailyLogCard extends StatefulWidget {
  final DailyLog log;
  final double pricePerCigarette;

  const DailyLogCard({
    super.key,
    required this.log,
    this.pricePerCigarette = 0,
  });

  @override
  State<DailyLogCard> createState() => _DailyLogCardState();
}

class _DailyLogCardState extends State<DailyLogCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _iconController.forward();
      } else {
        _iconController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor =
        isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;
    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final warningColor =
        isDark ? AppColors.darkChartWarning : AppColors.lightChartWarning;

    final isCraving = _getLogType() == 'craving';
    final statusColor = isCraving ? successColor : primaryColor;
    final statusBgColor = statusColor.withValues(alpha: 0.1);

    final hasDetails = widget.log.location != null ||
        widget.log.moods.isNotEmpty ||
        widget.log.context.isNotEmpty ||
        widget.log.companions.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p12),
      child: LunoCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p16,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — tıklanabilir
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: hasDetails ? _toggleExpand : null,
              child: Row(
                children: [
                  // Tarih
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getRelativeDateString(widget.log.date),
                        style: AppTextStyles.caption
                            .copyWith(color: Theme.of(context).hintColor),
                      ),
                      Text(
                        DateFormat('dd MMM').format(widget.log.date),
                        style: AppTextStyles.bodySemibold,
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.p16),

                  // Dikey Ayıraç
                  Container(
                    width: 2,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.lightBorder
                          .withValues(alpha: isDark ? 0.1 : 0.05),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.p16),

                  // Durum ikonu + Metin
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.p8),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCraving
                                ? Icons.shield_outlined
                                : Icons.smoking_rooms,
                            size: 16,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.p8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCraving
                                    ? 'Kriz Atlatıldı'
                                    : '${widget.log.smokeCount} adet',
                                style: AppTextStyles.bodySemibold.copyWith(
                                  color: isCraving
                                      ? successColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                ),
                              ),
                              if (isCraving &&
                                  widget.log.cravingIntensity > 0)
                                Text(
                                  'Şiddet: ${widget.log.cravingIntensity}/10',
                                  style: AppTextStyles.micro.copyWith(
                                      color: Theme.of(context).hintColor),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Fiyat veya Kalkan ikonu
                  if (!isCraving && widget.pricePerCigarette > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: warningColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₺${(widget.log.smokeCount * widget.pricePerCigarette).toStringAsFixed(0)}',
                        style: AppTextStyles.caption.copyWith(
                          color: warningColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (isCraving)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: successColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events,
                              size: 14, color: successColor),
                          const SizedBox(width: 4),
                          Text(
                            'Direnç',
                            style: AppTextStyles.micro.copyWith(
                              color: successColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Açılır/Kapanır ok ikonu
                  if (hasDetails) ...[
                    const SizedBox(width: AppSpacing.p8),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5)
                          .animate(_iconController),
                      child: Icon(
                        Icons.expand_more,
                        color: Theme.of(context).hintColor,
                        size: 20,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Subtitle (not)
            if (widget.log.note != null && widget.log.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.p8),
                child: Text(
                  widget.log.note!,
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context).hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Genişleyen detay alanı
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.p12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.log.location != null)
                      _buildDetailSection(
                          context, 'Konum', [widget.log.location!]),
                    if (widget.log.moods.isNotEmpty)
                      _buildDetailSection(
                          context, 'Duygu Durumu', widget.log.moods),
                    if (widget.log.context.isNotEmpty)
                      _buildDetailSection(
                          context, 'Aktivite', widget.log.context),
                    if (widget.log.companions.isNotEmpty)
                      _buildDetailSection(
                          context, 'Kiminleydi', widget.log.companions),
                  ],
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
      BuildContext context, String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Wrap(
            spacing: AppSpacing.p8,
            runSpacing: AppSpacing.p8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.p12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.lightBorder.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  item,
                  style: AppTextStyles.caption
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getRelativeDateString(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final logDate = DateTime(date.year, date.month, date.day);

    if (logDate == today) return "Bugün";
    if (logDate == yesterday) return "Dün";

    return DateFormat('EEEE', 'tr_TR').format(date);
  }

  String _getLogType() {
    try {
      return widget.log.type;
    } catch (_) {
      return 'craving';
    }
  }
}
