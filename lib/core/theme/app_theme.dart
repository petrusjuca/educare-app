import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores suaves e amigáveis, inspiradas no Duolingo
  static const Color primaryColor = Color(0xFF58CC02); // Verde Duolingo
  static const Color secondaryColor = Color(0xFFCE82FF); // Roxo suave
  static const Color accentColor = Color(0xFFFF9600); // Laranja
  static const Color backgroundColor = Color(0xFFF7F7F7); // Fundo claro
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF3C3C3C);
  static const Color textSecondaryColor = Color(0xFF777777);

  // Tema para estudantes - amigável mas não estimulante demais
  static ThemeData studentTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    textTheme: GoogleFonts.fredokaTextTheme().copyWith(
      headlineLarge: GoogleFonts.fredoka(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.fredoka(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.fredoka(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.fredoka(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.fredoka(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    // cardTheme: CardTheme(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   elevation: 4,
    //   shadowColor: Colors.black.withOpacity(0.1),
    // ),
    useMaterial3: true,
  );

  // Tema para professores - profissional e legível
  static ThemeData teacherTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    // cardTheme: CardTheme(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   elevation: 2,
    //   shadowColor: Colors.black.withOpacity(0.05),
    // ),
    useMaterial3: true,
  );
}