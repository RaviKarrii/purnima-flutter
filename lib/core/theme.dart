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
      scaffoldBackgroundColor: cream,
      primaryColor: saffron,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffron,
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
}
