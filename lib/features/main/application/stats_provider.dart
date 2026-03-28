import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/onboarding_repository.dart';
import 'package:luno_quit_smoking_app/features/history/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/main/application/quit_calculator.dart';
import 'package:luno_quit_smoking_app/features/main/data/models/quit_stats.dart';

// Dashboard istatistiklerini sağlayan canlı akış (Stream) provider
final statsProvider = StreamProvider<QuitStats>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  final logsAsync = ref.watch(historyLogsProvider);
  final logs = logsAsync.value ?? [];

  if (userProfile == null) {
    return Stream.value(
      QuitStats(
        rawMoney: 0.0,
        moneyLabel: "Harcanan Para",
        moneyValue: "0",
        moneyDecimal: ",00",
        moneySubtext: "₺0.0/dk yanıyor",
        moneyAction: "başlamak için dokun",
        timeLabel: "Kaybedilen Zaman",
        timeValue: "0",
        timeSubtext: "Henüz başlamadın",
        timeDigits: List.filled(8, "0"),
        countLabel: "İçilen Sigara",
        countValue: "0",
        countSubtext: "Henüz ölçülmedi",
        prepLabel: "Hazırlık Seviyesi",
        prepPercentage: 0.0,
        prepSubtext: "Henüz başlamadın",
        prepAction: "başlamak için dokun",
        progress: 0.0,
        type: QuitStatType.loss,
      ),
    );
  }

  // Her 100 milisaniyede bir tetiklenen akış
  return Stream.periodic(const Duration(milliseconds: 100), (_) {
    return QuitCalculator.calculate(userProfile, logs: logs);
  });
});
