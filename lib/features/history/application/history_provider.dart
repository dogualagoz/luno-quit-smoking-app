import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import 'package:luno_quit_smoking_app/features/history/data/history_repository.dart';
import 'package:luno_quit_smoking_app/features/history/data/models/daily_log.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final historyLogsProvider =
    StateNotifierProvider<HistoryLogsNotifier, AsyncValue<List<DailyLog>>>((
      ref,
    ) {
      final repository = ref.watch(historyRepositoryProvider);
      return HistoryLogsNotifier(repository);
    });

class HistoryLogsNotifier extends StateNotifier<AsyncValue<List<DailyLog>>> {
  final HistoryRepository _repository;

  HistoryLogsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      // Önce hızlıca local verileri yükle
      final localLogs = _repository.getAllLogs();
      state = AsyncValue.data(localLogs);

      // Arkadan yedekleri çek ve güncelle (Offline mode desteği bozulmadan)
      await _repository.syncLogsFromFirestore();

      // Senkronizasyon bitince tekrar local veriyi alıp ekrana yansıtıyoruz
      final syncedLogs = _repository.getAllLogs();
      state = AsyncValue.data(syncedLogs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addLog(DailyLog log) async {
    final previousState = state;
    try {
      // Optistic UI güncellemesi (Kullanıcı hemen görsün)
      if (state.value != null) {
        state = AsyncValue.data([log, ...state.value!]);
      }

      await _repository.addDailyLog(log);
    } catch (e, stack) {
      // Bir hata olursa eski haline geri döndür
      state = previousState;
      state = AsyncValue.error(e, stack);
    }
  }
}
