import "package:flutter/material.dart";

final appTheme = ThemeData(
  radioTheme: RadioThemeData(
    fillColor: WidgetStatePropertyAll(Color(0xFF004CFF)),
    overlayColor: WidgetStatePropertyAll(Color(0xFF004CFF)),
    splashRadius: 20,
  ),
  primaryColor: Color(0xFF004CFF),
  scaffoldBackgroundColor: Color(0xFFF5F5F5),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF004CFF), // Blue
    onPrimary: Color(0xFFFFFFFF), // White
    secondary: Color(0xFFADD8E6), // Light blue
    onSecondary: Color(0xFFFFFFFF), // White
    error: Color(0xFFB3261E), // Red
    onError: Color(0xFFFFFFFF), // White
    surface: Color(0xFFFFFFFF), // White
    onSurface: Color(0xFF202020), // Black
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 22, // Section titles, dialogs, app bars
      color: Color(0xFF202020),
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      fontSize: 18, // Subtitles, smaller section headers
      color: Color(0xFF202020),
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontSize: 16, // Smaller headers, emphasized text
      color: Color(0xFF202020),
      fontWeight: FontWeight.w500,
    ),
    headlineLarge: TextStyle(
      fontSize: 32, // Page titles, banners, big headers
      color: Color(0xFF202020),
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(
      fontSize: 16, // Main body text
      color: Color(0xFF202020),
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontSize: 14, // Secondary text, paragraphs
      color: Color(0xFF202020),
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 12, // Captions, helper text
      color: Color(0xFF202020),
      fontWeight: FontWeight.w300,
    ),
    labelLarge: TextStyle(
      fontSize: 14, // Buttons, inputs, tags
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 12, // Smaller buttons/labels
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      fontSize: 11, // Very small UI hints
      fontWeight: FontWeight.w300,
    ),
  ),
);
