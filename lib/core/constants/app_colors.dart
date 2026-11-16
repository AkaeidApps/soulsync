import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFFF4B6E);
  static const Color primaryDark = Color(0xFFE63E5F);
  static const Color secondary = Color(0xFFFF8A5B);
  static const Color accent = Color(0xFF7C4DFF);

  static const Color background = Color(0xFFFFF7F8);
  static const Color surface = Colors.white;
  static const Color surfaceAlt = Color(0xFFF6F6F8);

  static const Color textPrimary = Color(0xFF1F1F2B);
  static const Color textSecondary = Color(0xFF6B6B7A);
  static const Color textLight = Color(0xFF9A9AA8);

  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color border = Color(0xFFE9E9EE);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
