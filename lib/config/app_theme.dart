import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Updated colors to match the professional design
  static const bg = Color(0xFF0A0E27); // Deep dark blue background
  static const surface = Color(0xFF1A1F3A); // Card background
  static const primary = Color(0xFF6C5CE7); // Purple primary color
  static const accent = Color(0xFF74B9FF); // Light blue accent
  static const text = Colors.white;
  static const textDim = Color(0xFFB2BAC2);
  static const gradient1 = Color(0xFF6C5CE7); // Purple
  static const gradient2 = Color(0xFF74B9FF); // Blue
  static const cardBg = Color(0xFF1E1E2E); // Darker card background

  static var theme;

  static ThemeData dark() {
    final base = ThemeData.dark();
    final txt = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: text,
      displayColor: text,
    );
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        background: bg,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: text,
        onSurface: text,
      ),
      textTheme: txt.copyWith(
        headlineLarge: txt.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: text,
        ),
        headlineMedium: txt.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 28,
          color: text,
        ),
        headlineSmall: txt.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: text,
        ),
        titleLarge: txt.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: text,
        ),
        titleMedium: txt.titleMedium?.copyWith(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: txt.bodyLarge?.copyWith(
          color: text,
          fontSize: 16,
        ),
        bodyMedium: txt.bodyMedium?.copyWith(
          color: textDim,
          fontSize: 14,
        ),
        bodySmall: txt.bodySmall?.copyWith(
          color: textDim,
          fontSize: 12,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        iconTheme: const IconThemeData(color: text),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: primary.withOpacity(0.4),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(
          color: textDim,
          fontSize: 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        labelStyle: TextStyle(
          color: textDim,
          fontSize: 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  // Gradient decoration for backgrounds
  static BoxDecoration gradientDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0A0E27),
          Color(0xFF1A1F3A),
          Color(0xFF2D3561),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  // Button gradient decoration
  static BoxDecoration buttonGradientDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [gradient1, gradient2],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: primary.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // Card decoration with subtle glow
  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: primary.withOpacity(0.1),
          blurRadius: 40,
          offset: const Offset(0, 16),
        ),
      ],
    );
  }
}