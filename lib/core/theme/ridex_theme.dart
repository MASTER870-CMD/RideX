import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ridex_colors.dart';

abstract final class RidexTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: RidexColors.background,
      colorScheme: const ColorScheme.light(
        primary: RidexColors.red,
        secondary: RidexColors.orange,
        surface: RidexColors.surface,
        error: Color(0xFFE11D2A),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: RidexColors.charcoal,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: RidexColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: RidexColors.background,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: RidexColors.charcoal,
        ),
        iconTheme: const IconThemeData(color: RidexColors.charcoal),
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
        bodyColor: RidexColors.charcoal,
        displayColor: RidexColors.charcoal,
      ),
      dividerTheme: const DividerThemeData(
        color: RidexColors.border,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: RidexColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: RidexColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RidexColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RidexColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RidexColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RidexColors.red, width: 1.5),
        ),
      ),
    );
  }
}
