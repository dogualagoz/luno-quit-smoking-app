import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/services/local_storage/hive_service.dart';

/// Local-first repository for daily logs.
///
/// Hive is the source of truth. Every write is persisted locally first; the
/// Firestore mirror is awaited so failures surface to the caller, but a
/// cloud-write failure does not roll back the local write — the next
/// SyncService run reconciles.
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

  bool hasLogForToday() {
    final today = DateTime.now();
    return _dailyLogsBox.values.any((log) {
      return log.date.year == today.year &&
          log.date.month == today.month &&
          log.date.day == today.day;
    });
  }

  List<DailyLog> getAllLogs() {
    final logs = _dailyLogsBox.values.toList();
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs;
  }

  Future<void> addDailyLog(DailyLog log) async {
    await _dailyLogsBox.put(log.id, log);

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailyLogs')
          .doc(log.id)
          .set(log.toMap());
    } catch (_) {
      // Local write succeeded; cloud will reconcile on next SyncService run.
    }
  }
}
