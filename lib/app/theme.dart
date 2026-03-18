import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0A1524);
  static const Color surface = Color(0xFF18283C);
  static const Color surfaceAlt = Color(0xFF233A52);
  static const Color accent = Color(0xFFF4C95D);
  static const Color accentLight = Color(0xFFFFE066);
  static const Color accentDark = Color(0xFFE6B800);
  static const Color textPrimary = Color(0xFFF5F7FB);
  static const Color textMuted = Color(0xFF9CB0C3);
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFA726);

  static const LinearGradient screenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A2A3F), Color(0xFF18263A)],
  );

  static BoxDecoration screenBackgroundDecoration() {
    return const BoxDecoration(gradient: screenGradient);
  }

  static BoxDecoration panelDecoration({Color? color, double elevation = 8}) {
    final panelColor = color ?? const Color(0xFF20384D);
    return BoxDecoration(
      color: panelColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: elevation,
          offset: Offset(0, elevation / 2),
        ),
      ],
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accent,
        surface: surface,
        onPrimary: Color(0xFF1B1D22),
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.montserratTextTheme(
        base.textTheme,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) return accent;
          return textMuted;
        }),
        suffixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) return accent;
          return textMuted;
        }),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3A5364), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: const Color(0xFF171B21),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          elevation: 8,
          shadowColor: accent.withValues(alpha: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: accent, width: 2),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
    );
  }
}
