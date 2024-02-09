import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color(0xB2FFFFFF),
    secondary: Colors.black87,
    tertiary: Colors.grey.shade700,
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xB2565656),
    secondary: Colors.white70,
    tertiary: Colors.grey.shade800,
  )
);