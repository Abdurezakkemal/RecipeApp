import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 16;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;

  ThemeData get themeData => _isDarkMode
      ? ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: _fontSize),
            bodyLarge: TextStyle(fontSize: _fontSize),
          ),
        )
      : ThemeData.light().copyWith(
          textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: _fontSize),
            bodyLarge: TextStyle(fontSize: _fontSize),
          ),
        );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }
}
