import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palet warna girly untuk seluruh aplikasi.
class AppColors {
  static const Color primary = Color(0xFFE91E78); // hot pink
  static const Color primaryDark = Color(0xFFC2185B);
  static const Color soft = Color(0xFFFFE4EF); // blush
  static const Color background = Color(0xFFFFF5F9); // pink sangat muda
  static const Color accent = Color(0xFFB57EDC); // lavender
  static const Color text = Color(0xFF4A2B3B);
  static const Color textMuted = Color(0xFF9C7A8B);
  static const Color star = Color(0xFFFFB300);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.pacifico(
          fontSize: 24,
          color: AppColors.primary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        side: const BorderSide(color: AppColors.soft),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: GoogleFonts.poppins(fontSize: 12.5),
      ),
    );
  }
}
