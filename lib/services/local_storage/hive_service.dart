import 'package:hive_flutter/hive_flutter.dart';
import 'package:luno_quit_smoking_app/features/onboarding/data/models/user_profile.dart';

class HiveService {
  //Box isimlerini burada sabit tutmak hata payını azaltır
  static const String userBoxName = 'luno_user_box';
  static const String userProfileKey = 'user_profile';

  //Uygulama açıldığında ilk başlayacak fonksiyon
  static Future<void> init() async {
    // Hive'ı başlat
    await Hive.initFlutter();

    // Ürettiğimiz Adapter'ı kaydet
    Hive.registerAdapter(UserProfileAdapter());

    //Verileri tutacak Box'ı aç
    await Hive.openBox<UserProfile>(userBoxName);
  }

  // Box'ı döndüren yardımcı bir metod
  static Box<UserProfile> getUserBox() {
    return Hive.box<UserProfile>(userBoxName);
  }
}
