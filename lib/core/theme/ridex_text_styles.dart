import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ridex_colors.dart';

abstract final class RidexTextStyles {
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: RidexColors.charcoal,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: RidexColors.charcoal,
        letterSpacing: -0.4,
      );

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: RidexColors.charcoal,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: RidexColors.charcoal,
      );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: RidexColors.charcoal,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: RidexColors.muted,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: RidexColors.muted,
      );

  static TextStyle get labelBold => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: RidexColors.charcoal,
        letterSpacing: 0.8,
      );

  static TextStyle get tagline => GoogleFonts.plusJakartaSans(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        color: RidexColors.charcoal,
        letterSpacing: 0.12 * 11.5,
      );

  static TextStyle get poweredBy => GoogleFonts.plusJakartaSans(
        fontSize: 9.5,
        fontWeight: FontWeight.w500,
        color: RidexColors.muted,
        letterSpacing: 0.14 * 9.5,
      );

  static TextStyle get creditAmount => GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: RidexColors.charcoal,
      );

  static TextStyle get badgeText => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      );
}
