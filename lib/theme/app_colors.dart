import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6D4C2E);
  static const Color primaryDark = Color(0xFF4A3320);
  static const Color primaryLight = Color(0xFF8B6B4A);

  static const Color accent = Color(0xFFC9A96E);
  static const Color accentLight = Color(0xFFDEC9A0);
  static const Color accentDark = Color(0xFFA8843E);

  static const Color background = Color(0xFFF5EDE3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0E4D6);
  static const Color cardColor = Color(0xFFFAF5EF);

  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF6D5D4E);
  static const Color textHint = Color(0xFF9E8E7E);

  static const Color success = Color(0xFF5D8A4B);
  static const Color error = Color(0xFFC0392B);
  static const Color warning = Color(0xFFD4A017);
  static const Color info = Color(0xFF5B7FA4);

  static const Color divider = Color(0xFFDDD0C0);
  static const Color shimmer = Color(0xFFE8DDD0);
  static const Color shadow = Color(0x266D4C2E);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentDark, accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFF6D4C2E), Color(0xFFC9A96E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
