import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:luno_quit_smoking_app/firebase_options.dart';
import 'package:luno_quit_smoking_app/services/local_storage/hive_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Hive'ı başlat
  await HiveService.init();

  runApp(const ProviderScope(child: LunoApp()));
}
