import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/services/local_storage/hive_service.dart';

class HistoryRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Box<DailyLog> _dailyLogsBox;

  HistoryRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth,
       _dailyLogsBox = HiveService.getDailyLogsBox();

  /// Bugün için kaydedilmiş bir check-in var mı?
  bool hasLogForToday() {
    final today = DateTime.now();
    return _dailyLogsBox.values.any((log) {
      return log.date.year == today.year &&
          log.date.month == today.month &&
          log.date.day == today.day;
    });
  }

  /// Tüm geçmiş kayıtları getir (Local)
  List<DailyLog> getAllLogs() {
    final logs = _dailyLogsBox.values.toList();
    logs.sort((a, b) => b.date.compareTo(a.date)); // Yeniden eskiye sırala
    return logs;
  }

  /// Yeni günlük kayıt ekle
  Future<void> addDailyLog(DailyLog log) async {
    // 1. Hive'a yaz (Hızlı sonuç)
    await _dailyLogsBox.put(log.id, log);

    // 2. Firestore'a yaz (Yedekleme - arka planda, beklemeden)
    final user = _auth.currentUser;
    if (user != null) {
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailyLogs')
          .doc(log.id)
          .set(log.toMap());
    }
  }

  /// Firestore'dan son verileri çekip Hive ile senkronize et
  Future<void> syncLogsFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailyLogs')
          .get();

      final logs = snapshot.docs
          .map((doc) => DailyLog.fromMap(doc.data(), doc.id))
          .toList();

      if (logs.isNotEmpty) {
        final Map<String, DailyLog> logsMap = {
          for (var log in logs) log.id: log,
        };
        await _dailyLogsBox.putAll(logsMap);
      }
    } catch (e) {
      // Hata sessizce geçiliyor, Hive verileri korunuyor
    }
  }
}
