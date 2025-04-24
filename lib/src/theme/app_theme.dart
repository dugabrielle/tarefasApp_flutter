import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE7D1F3), // Cor do Background
    primaryColor: const Color(0xFF8E44AD), // Cor do Botão "Add Nota"
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFC387DB), // Cor da AppBar
      foregroundColor: Color(0xFF2F1F42), // Cor da Fonte da AppBar
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF9956A3), // Cor da Fonte de Texto 2
      secondary: Color(0xFF731FB3), // Cor dos Botões dentro das Tasks
      tertiary: Color(0xFFF3E7F7), // Cor do Title Color
    ),
    textTheme: GoogleFonts.comicNeueTextTheme(
      const TextTheme(
        bodyMedium: TextStyle(
          color: Color(0xFF2F1F42), // Cor da Fonte de Texto
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(
          Color(0xFFFFA500), // Cor do Sol
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // Cor do Background
    primaryColor: const Color(0xFF210F44), // Cor do Botão "Add Nota"
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4E2C79), // Cor da AppBar
      foregroundColor: Color(0xFFE8D9F3), // Cor da Fonte de Texto
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7456A3), // Cor da Fonte de Texto 2
      secondary: Color(0xFF29044A), // Cor dos Botões dentro das Tasks
      tertiary: Color(0xFF735496), // Cor do Title Color
    ),
    textTheme: GoogleFonts.comicNeueTextTheme(
      const TextTheme(
        bodyMedium: TextStyle(
          color: Color(0xFFE8D9F3), // Cor da Fonte de Texto
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(
          Color(0xFF617DBE), // Cor da Lua
        ),
      ),
    ),
  );
}
