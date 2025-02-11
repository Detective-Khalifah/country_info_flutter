import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [ThemeMode] setting key.
const String isDarkModeKey = 'isDarkMode';

// Riverpod provider for the theme notifier.
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  /// Load the theme from [SharedPreferences]
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(isDarkModeKey) ?? false;
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  /// [Material] 3 light theme using white as seed.
  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.light,
    ),
  );

  /// [Material] 3 dark theme using a dark blue, dye-like colour as seed.
  final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF000F24),
      brightness: Brightness.dark,
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: GoogleFonts.arimo(
        fontWeight: FontWeight.bold,
        // TODO: find way to ascertain theme mode as pivot for alternating colours
        color: Color(0xFF1C1917),
      ),
    ),
  );

  /// Toggle between light and dark themes, persist the change.
  Future<void> switchTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setBool(isDarkModeKey, true);
    } else {
      state = ThemeMode.light;
      await prefs.setBool(isDarkModeKey, false);
    }
  }

  /// Check if [ThemeMode] is light.
  bool isLightMode() {
    return state == ThemeMode.light;
  }
}
