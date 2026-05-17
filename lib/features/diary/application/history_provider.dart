import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import 'package:luno_quit_smoking_app/core/services/sync_service.dart';
import 'package:luno_quit_smoking_app/features/auth/data/auth_repository.dart';
import 'package:luno_quit_smoking_app/features/diary/data/history_repository.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';

/// Recreated when auth state changes so a previous user's logs cannot leak.
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  ref.watch(authStateProvider);
  return HistoryRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final historyLogsProvider =
    StateNotifierProvider<HistoryLogsNotifier, AsyncValue<List<DailyLog>>>((
      ref,
    ) {
      return HistoryLogsNotifier(
        ref.watch(historyRepositoryProvider),
        ref.watch(syncServiceProvider),
        ref.watch(firebaseAuthProvider),
      );
    });

class HistoryLogsNotifier extends StateNotifier<AsyncValue<List<DailyLog>>> {
  final HistoryRepository _repository;
  final SyncService _sync;
  final FirebaseAuth _auth;

  HistoryLogsNotifier(this._repository, this._sync, this._auth)
      : super(const AsyncValue.loading()) {
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      // Show local data immediately.
      state = AsyncValue.data(_repository.getAllLogs());

      // Reconcile with cloud in the background; merges by id without deletes.
      final user = _auth.currentUser;
      if (user != null) {
        await _sync.syncDailyLogs(user);
        state = AsyncValue.data(_repository.getAllLogs());
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addLog(DailyLog log) async {
    final previousState = state;
    try {
      if (state.value != null) {
        state = AsyncValue.data([log, ...state.value!]);
      }
      await _repository.addDailyLog(log);
    } catch (e, stack) {
      state = previousState;
      state = AsyncValue.error(e, stack);
    }
  }
}
