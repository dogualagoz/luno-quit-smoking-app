import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/services/local_storage/hive_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // İleride Firebase.initializeApp() buraya gelecek

  // Hive'ı başlat
  await HiveService.init();

  runApp(const ProviderScope(child: LunoApp()));
}
