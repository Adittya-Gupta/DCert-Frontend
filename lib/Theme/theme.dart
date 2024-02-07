import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade400,
    primary: Colors.white70,
    secondary: Colors.black87,
    tertiary: Colors.grey.shade700,
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.black87,
    secondary: Colors.white70,
    tertiary: Colors.grey.shade800,
  )
);