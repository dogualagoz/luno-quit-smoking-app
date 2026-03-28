import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  Future<void> recordError(dynamic exception, StackTrace? stack, {dynamic reason, bool fatal = false}) async {
    await _crashlytics.recordError(exception, stack, reason: reason, fatal: fatal);
  }

  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  Future<void> setUserId(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }
}
