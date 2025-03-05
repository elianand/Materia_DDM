import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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


class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(!state.isDarkMode);
  }
}