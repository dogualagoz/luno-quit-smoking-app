import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/features/history/data/models/daily_log.dart';

class DailyLogCard extends StatelessWidget {
  final DailyLog log;

  const DailyLogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark
        ? AppColors.darkChartSuccess
        : AppColors.lightChartSuccess;

    // Basit bir yüz ifadesi mantığı (Geliştirilebilir)
    String getEmoji() {
      if (!log.hasSmoked) return '😁'; // İçmediyse süper
      if (log.smokeCount < 5) return '😐';
      return '😞'; // 5 ve üstüyse üzgün
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: const Border(), // Çizgisiz
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getRelativeDateString(log.date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  DateFormat('dd MMM').format(log.date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 16),

            // Sigara Sayısı ve Emoji
            if (log.hasSmoked) ...[
              const Icon(Icons.smoking_rooms, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${log.smokeCount} sigara',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ] else ...[
              const Icon(Icons.smoke_free, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              const Text(
                'Temiz gün',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(width: 8),
            Text(getEmoji(), style: const TextStyle(fontSize: 18)),

            const Spacer(),

            // Kriz Rozeti
            if (log.cravingIntensity > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      '${log.cravingIntensity} şiddet',
                      style: TextStyle(
                        color: successColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: log.note != null && log.note!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  log.note!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (log.location != null)
                  _buildDetailRow('Konum:', log.location!),
                if (log.moods.isNotEmpty)
                  _buildDetailRow('Ruh Hali:', log.moods.join(', ')),
                if (log.context.isNotEmpty)
                  _buildDetailRow('Aktivite:', log.context.join(', ')),
                if (log.companions.isNotEmpty)
                  _buildDetailRow('Kiminle:', log.companions.join(', ')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
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

    // Geri kalan günler için haftanın gününü döndürebiliriz
    return DateFormat('EEEE').format(date);
  }
}
