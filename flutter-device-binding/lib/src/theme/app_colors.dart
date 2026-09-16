import 'package:flutter/material.dart';

/// azuma corporate design system, lifted from `azuma-homepage/tailwind.config.js`
/// and mapped onto Material 3 in `app_theme.dart`. Names are the token names
/// there; the "as text" variants are the 500 step, used where the 400 brand
/// value does not reach 4.5:1 on white.
abstract final class AppColors {
  // Primary · Steel Cerulean
  static const Color primary50 = Color(0xFFF0F7FA);
  static const Color primary100 = Color(0xFFD9ECF2);
  static const Color primary200 = Color(0xFFB0D6E4);
  static const Color primary300 = Color(0xFF7AB9D0);
  static const Color primary = Color(0xFF3E86A3);
  static const Color primary500 = Color(0xFF2E6E8A);
  static const Color primary600 = Color(0xFF245872);
  static const Color primary700 = Color(0xFF1B445A);

  // Secondary / Error · Signal Red
  static const Color error = Color(0xFFFD2C4E);
  static const Color errorText = Color(0xFFE01040);
  static const Color error50 = Color(0xFFFFF0F2);

  // Success · Eucalyptus
  static const Color success = Color(0xFF3A9E8F);
  static const Color successText = Color(0xFF2A7E72);
  static const Color success50 = Color(0xFFEDF7F4);

  // Warning · Warm Amber
  static const Color warning = Color(0xFFE6A914);
  static const Color warning50 = Color(0xFFFEF9EC);
  static const Color warningText = Color(0xFF754F05);

  // Neutral · Arctic Slate
  static const Color white = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF5F7F9);
  static const Color neutral100 = Color(0xFFEAEDF1);
  static const Color neutral200 = Color(0xFFD1D8E0);
  static const Color neutral300 = Color(0xFFADB8C4);
  static const Color neutral400 = Color(0xFF84939F);
  static const Color neutral500 = Color(0xFF637180);
  static const Color neutral600 = Color(0xFF4D5A68);
  static const Color neutral700 = Color(0xFF384451);
  static const Color neutral900 = Color(0xFF161D24);
}
