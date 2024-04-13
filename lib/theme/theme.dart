import 'package:flutter/material.dart';

class MovieAppTheme {
  static const bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedIconTheme: IconThemeData(size: 30),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  );

  static final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.black,
    brightness: Brightness.dark,
  ).copyWith(
    background: Colors.black,
  );

  static ThemeData get themeData => ThemeData(
        bottomNavigationBarTheme: bottomNavigationBarTheme,
        colorScheme: colorScheme,
        useMaterial3: true,
      );
}
