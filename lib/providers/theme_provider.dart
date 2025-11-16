import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }

  // Dark theme
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFF0F0F1E),
        canvasColor: const Color(0xFF0F0F1E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFFFF6584),
          surface: Color(0xFF1A1A2E),
        ),
        useMaterial3: true,
      );

  // Light theme
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        canvasColor: const Color(0xFFF5F7FA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFFFF6584),
          surface: Color(0xFFFFFFFF),
        ),
        useMaterial3: true,
      );

  // Helper method to get gradient colors based on theme
  List<Color> get gradientColors {
    if (_isDarkMode) {
      return [
        const Color(0xFF0F0F1E),
        const Color(0xFF1A1A2E),
        const Color(0xFF6C63FF).withValues(alpha: 0.2),
      ];
    } else {
      return [
        const Color(0xFFF5F7FA),
        const Color(0xFFE8EBF0),
        const Color(0xFF6C63FF).withValues(alpha: 0.1),
      ];
    }
  }

  // Card background color
  Color get cardColor {
    if (_isDarkMode) {
      return const Color(0xFF1A1A2E).withValues(alpha: 0.6);
    } else {
      return const Color(0xFFFFFFFF).withValues(alpha: 0.9);
    }
  }

  // Card background color for metrics
  Color get metricCardColor {
    if (_isDarkMode) {
      return const Color(0xFF1A1A2E).withValues(alpha: 0.7);
    } else {
      return const Color(0xFFFFFFFF).withValues(alpha: 0.95);
    }
  }

  // Text color
  Color get textColor {
    return _isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
  }

  // Secondary text color
  Color textColorWithOpacity(double opacity) {
    if (_isDarkMode) {
      return Colors.white.withValues(alpha: opacity);
    } else {
      return const Color(0xFF1A1A2E).withValues(alpha: opacity);
    }
  }

  // Border color
  Color get borderColor {
    if (_isDarkMode) {
      return Colors.white.withValues(alpha: 0.12);
    } else {
      return const Color(0xFF1A1A2E).withValues(alpha: 0.1);
    }
  }

  // Shadow color
  Color get shadowColor {
    if (_isDarkMode) {
      return Colors.black.withValues(alpha: 0.15);
    } else {
      return const Color(0xFF1A1A2E).withValues(alpha: 0.08);
    }
  }

  // Input field color
  Color get inputFieldColor {
    if (_isDarkMode) {
      return const Color(0xFF1A1A2E);
    } else {
      return const Color(0xFFFFFFFF);
    }
  }

  // Hint text color
  Color get hintTextColor {
    if (_isDarkMode) {
      return Colors.white.withValues(alpha: 0.3);
    } else {
      return const Color(0xFF1A1A2E).withValues(alpha: 0.4);
    }
  }
}

