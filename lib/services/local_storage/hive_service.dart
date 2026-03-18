import 'package:hive_flutter/hive_flutter.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/models/user_profile.dart';
import 'package:luno_quit_smoking_app/features/history/data/models/daily_log.dart';

class HiveService {
  //Box isimlerini burada sabit tutmak hata payını azaltır
  static const String userBoxName = 'luno_user_box';
  static const String userProfileKey = 'user_profile';
  static const String dailyLogsBoxName = 'daily_logs';

  //Uygulama açıldığında ilk başlayacak fonksiyon
  static Future<void> init() async {
    // Hive'ı başlat
    await Hive.initFlutter();

    // Ürettiğimiz Adapter'ları kaydet
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(DailyLogAdapter());

    //Verileri tutacak Box'ları aç
    await Hive.openBox<UserProfile>(userBoxName);
    await Hive.openBox<DailyLog>(dailyLogsBoxName);
  }

  // Box'ı döndüren yardımcı bir metod
  static Box<UserProfile> getUserBox() {
    return Hive.box<UserProfile>(userBoxName);
  }

  static Box<DailyLog> getDailyLogsBox() {
    return Hive.box<DailyLog>(dailyLogsBoxName);
  }
}
