import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color cream = Color(0xFFFFF9F0); // Warmer, lighter cream
  static const Color saffron = Color(0xFFFF9933);
  static const Color gold = Color(0xFFFFD700);
  static const Color deepRed = Color(0xFF8B0000);
  static const Color textDark = Color(0xFF333333);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: cream,
      primaryColor: saffron,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffron,
        brightness: Brightness.light,
        primary: saffron,
        secondary: gold,
        surface: cream,
        onSurface: textDark,
      ),
      textTheme: GoogleFonts.merriweatherTextTheme().apply(
        bodyColor: textDark,
        displayColor: deepRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.merriweather(
          color: deepRed,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: deepRed),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: gold.withAlpha(128), width: 1),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: saffron,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffron,
        brightness: Brightness.dark,
        primary: saffron,
        secondary: gold,
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
        onPrimary: Colors.black,
      ),
      textTheme: GoogleFonts.merriweatherTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: const Color(0xFFE0E0E0),
        displayColor: saffron,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.merriweather(
          color: saffron,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: saffron),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: gold.withAlpha(128), width: 1),
        ),
      ),
      iconTheme: const IconThemeData(color: saffron),
    );
  }
}
