import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/diary/data/models/daily_log.dart';
import '../../features/onboarding/data/models/user_profile.dart';
import '../../services/local_storage/hive_service.dart';
import '../providers/firebase_providers.dart';

/// Bidirectional last-write-wins sync between Hive (source of truth) and
/// Firestore (backup + multi-device).
///
/// Conflict resolution: per-record [updatedAt] comparison. Never deletes
/// records — if one side has data the other lacks, that data is copied over.
class SyncService {
  final FirebaseFirestore _firestore;

  SyncService(this._firestore);

  /// Reconciles the locally stored [UserProfile] with the user's Firestore
  /// document. Whichever side has the newer [UserProfile.updatedAt] becomes
  /// authoritative and is written to both sides.
  Future<void> syncUserProfile(User user) async {
    final box = HiveService.getUserBox();
    final local = box.get(HiveService.userProfileKey);

    final cloudDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    final cloud = cloudDoc.exists
        ? UserProfile.fromJson(cloudDoc.data()!)
        : null;

    if (local == null && cloud == null) {
      return; // Nothing to sync yet — onboarding hasn't happened anywhere.
    }

    if (local == null && cloud != null) {
      // First login on this device — pull cloud profile.
      await box.put(
        HiveService.userProfileKey,
        cloud.copyWith(touch: false, userId: user.uid, email: user.email),
      );
      return;
    }

    if (local != null && cloud == null) {
      // Onboarding done locally, no cloud record yet — push it up.
      final stamped = local.copyWith(
        touch: false,
        userId: user.uid,
        email: user.email,
      );
      await box.put(HiveService.userProfileKey, stamped);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(stamped.toJson());
      return;
    }

    // Both present: last-write-wins.
    final localNewer = local!.updatedAt.isAfter(cloud!.updatedAt);
    if (localNewer) {
      final stamped = local.copyWith(
        touch: false,
        userId: user.uid,
        email: user.email,
      );
      await box.put(HiveService.userProfileKey, stamped);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(stamped.toJson());
    } else {
      await box.put(
        HiveService.userProfileKey,
        cloud.copyWith(touch: false, userId: user.uid, email: user.email),
      );
    }
  }

  /// Merges daily logs between Hive and Firestore. ID-based merge: for
  /// records present on both sides, the newer [DailyLog.updatedAt] wins. Logs
  /// present on only one side are copied to the other.
  Future<void> syncDailyLogs(User user) async {
    final box = HiveService.getDailyLogsBox();
    final localLogs = {for (final log in box.values) log.id: log};

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailyLogs')
        .get();
    final cloudLogs = {
      for (final doc in snapshot.docs)
        doc.id: DailyLog.fromMap(doc.data(), doc.id),
    };

    final allIds = {...localLogs.keys, ...cloudLogs.keys};

    final hiveWrites = <String, DailyLog>{};
    final cloudWrites = <String, DailyLog>{};

    for (final id in allIds) {
      final local = localLogs[id];
      final cloud = cloudLogs[id];

      if (local == null && cloud != null) {
        hiveWrites[id] = cloud;
      } else if (cloud == null && local != null) {
        cloudWrites[id] = local;
      } else if (local != null && cloud != null) {
        if (local.updatedAt.isAfter(cloud.updatedAt)) {
          cloudWrites[id] = local;
        } else if (cloud.updatedAt.isAfter(local.updatedAt)) {
          hiveWrites[id] = cloud;
        }
      }
    }

    if (hiveWrites.isNotEmpty) {
      await box.putAll(hiveWrites);
    }

    if (cloudWrites.isNotEmpty) {
      final batch = _firestore.batch();
      final collection = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailyLogs');
      for (final entry in cloudWrites.entries) {
        batch.set(collection.doc(entry.key), entry.value.toMap());
      }
      await batch.commit();
    }
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref.watch(firestoreProvider));
});
