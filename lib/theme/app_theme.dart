import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFFFCF9F4);
  static const surface = Color(0xFFF5F2ED);
  static const field = Color(0xFFF0EDE8);
  static const primary = Color(0xFFA23B15);
  static const ink = Color(0xFF1C1B18);
  static const brown = Color(0xFF5D4439);
  static const muted = Color(0xFF8A7A72);
  static const sage = Color(0xFFDDEBD3);
  static const sageDark = Color(0xFF4F6048);
  static const peach = Color(0xFFFFDCCC);
  static const border = Color(0xFFEFE9E2);
  static const error = Color(0xFFC0392B);
}

class AppText {
  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
    double? letterSpacing,
    FontStyle? style,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontStyle: style,
    );
  }

  static TextStyle serif({
    double size = 16,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.ink,
    double? height,
    FontStyle? style,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      fontStyle: style,
    );
  }
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      contentTextStyle: AppText.sans(size: 14, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}