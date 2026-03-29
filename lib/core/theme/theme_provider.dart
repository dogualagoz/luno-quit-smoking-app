import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// StateNotifier to manage and persist theme mode
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _boxName = 'settings_box';
  static const String _themeKey = 'app_theme_mode';
  late final Box _box;

  ThemeModeNotifier() : super(ThemeMode.light) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_boxName);
    final savedTheme = _box.get(_themeKey) as int?;
    if (savedTheme != null) {
      if (savedTheme == ThemeMode.light.index) {
        state = ThemeMode.light;
      } else if (savedTheme == ThemeMode.dark.index) {
        state = ThemeMode.dark;
      } else {
        // If there wasn't a choice or it was system, now we default to light as per user request
        state = ThemeMode.light;
      }
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    _box.put(_themeKey, mode.index);
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}

// Provider for the ThemeModeNotifier
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
