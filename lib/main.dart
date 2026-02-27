import 'package:flutter/material.dart';
import 'app.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // İleride Firebase.initializeApp() buraya gelecek
  runApp(const LunoApp());
}