import 'package:flutter/material.dart';

class AppTheme {
  
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  ThemeData getTheme() {
    return ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
    ));
  }

  AppTheme copyWith(bool? isDarkMode) {
    return AppTheme(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  bool isLigthMode() {
    return !isDarkMode;
  }
}
