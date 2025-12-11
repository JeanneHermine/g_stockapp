import 'package:flutter/material.dart';

class ThemeService {
  static ThemeData getLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      brightness: Brightness.light,
      useMaterial3: true,
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      brightness: Brightness.dark,
      useMaterial3: true,
    );
  }
}
