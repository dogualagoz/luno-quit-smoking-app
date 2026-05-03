import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';

/// Günlük giriş streak değerini hesaplayan yardımcı fonksiyon.
/// Kullanıcının üst üste kaç gün log girdiğini döner.
/// Bugün log girilmemişse, dünden başlayarak sayar (streak kırılmaz).
int _calculateStreak(List<DailyLog> logs) {
  if (logs.isEmpty) return 0;

  // Benzersiz tarihleri gün hassasiyetinde küme olarak topla
  final Set<String> activeDays = logs.map((log) {
    final d = log.date;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }).toSet();

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Bugün log var mı kontrol et; yoksa dünden başla
  final todayKey =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  final bool hasTodayLog = activeDays.contains(todayKey);

  // Sayma başlangıç günü: bugün log varsa bugün, yoksa dün
  DateTime cursor = hasTodayLog ? today : today.subtract(const Duration(days: 1));

  int streak = 0;
  while (true) {
    final key =
        '${cursor.year}-${cursor.month.toString().padLeft(2, '0')}-${cursor.day.toString().padLeft(2, '0')}';
    if (!activeDays.contains(key)) break;
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return streak;
}

/// Mevcut streak değerini döndüren provider.
/// historyLogsProvider değiştiğinde otomatik güncellenir.
final streakProvider = Provider<int>((ref) {
  final logsAsync = ref.watch(historyLogsProvider);
  return logsAsync.when(
    data: (logs) => _calculateStreak(logs),
    loading: () => 0,
    error: (_, __) => 0,
  );
});
