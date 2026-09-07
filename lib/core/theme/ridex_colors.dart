import 'package:flutter/material.dart';

/// RIDEX centralized color palette — extracted from Stitch designs.
abstract final class RidexColors {
  // Brand gradient
  static const Color red = Color(0xFFE11D2A);
  static const Color orange = Color(0xFFF95A2C);
  static const Color yellow = Color(0xFFFFB800);

  // Backgrounds
  static const Color background = Color(0xFFFAF9F6); // warm cream
  static const Color surface = Color(0xFFFDFBF7);
  static const Color card = Color(0xFFFFFFFF);
  static const Color ivory = Color(0xFFF7F4EC);

  // Text
  static const Color charcoal = Color(0xFF141416);
  static const Color muted = Color(0xFF7E828E);
  static const Color lightMuted = Color(0xFF9CA3AF);

  // Borders
  static const Color border = Color(0xFFE8E5DD);
  static const Color borderLight = Color(0xFFF0EFEA);

  // Status
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldDark = Color(0xFF059669);
  static const Color emeraldBg = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color errorBg = Color(0xFFFFF1F2);

  // Gradient list — brand signature
  static const List<Color> brandGradient = [red, orange, yellow];

  // Drawer / surface
  static const Color drawerBg = Color(0xFFFDFBF7);
}
