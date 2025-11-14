import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDeepBlue = Color(0xFF0A3D62);
  static const Color secondaryRailwayGreen = Color(0xFF1ABC9C);
  static const Color accentSafetyYellow = Color(0xFFF1C40F);
  static const Color brandLightBlue = Color(0xFF60A5FA); // light blue for highlights

  static const Color neutralWhite = Colors.white;
  static const Color neutralLightGrey = Color(0xFFF4F5F7);
  static const Color neutralGrey = Color(0xFF9AA0A6);
  static const Color neutralDarkGrey = Color(0xFF2F3542);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static Color cardBorder = const Color(0xFFE6E8EC);
}

class AppSpacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
}

class AppRadius {
  static const double r8 = 8;
  static const double r12 = 12;
  static const double r16 = 16;
  static const double r20 = 20;
}

class AppShadows {
  static List<BoxShadow> low = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 6,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> high = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 12),
    ),
  ];
}

class AppTextStyles {
  // Note: Set up custom fonts (e.g., Inter for headings, Roboto for body) in pubspec.yaml for full effect.
  static const String headingFont = 'Inter';
  static const String bodyFont = 'Roboto';

  static TextStyle h1 = const TextStyle(
    fontFamily: headingFont,
    fontSize: 28,
    height: 1.25,
    fontWeight: FontWeight.w800,
    letterSpacing: .2,
    color: AppColors.neutralDarkGrey,
  );

  static TextStyle h2 = const TextStyle(
    fontFamily: headingFont,
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w800,
    letterSpacing: .2,
    color: AppColors.neutralDarkGrey,
  );

  static TextStyle h3 = const TextStyle(
    fontFamily: headingFont,
    fontSize: 20,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.neutralDarkGrey,
  );

  static TextStyle h4 = const TextStyle(
    fontFamily: headingFont,
    fontSize: 18,
    height: 1.35,
    fontWeight: FontWeight.w700,
    color: AppColors.neutralDarkGrey,
  );

  static TextStyle h5 = const TextStyle(
    fontFamily: headingFont,
    fontSize: 16,
    height: 1.35,
    fontWeight: FontWeight.w700,
    color: AppColors.neutralDarkGrey,
  );

  static TextStyle h6 = const TextStyle(
    fontFamily: headingFont,
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w700,
    color: AppColors.neutralDarkGrey,
  );

  static TextStyle bodyLg = const TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    height: 1.5,
    color: AppColors.neutralDarkGrey,
  );

  static TextStyle body = const TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    height: 1.5,
    color: AppColors.neutralDarkGrey,
  );

  static TextStyle caption = const TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    height: 1.4,
    color: AppColors.neutralGrey,
  );
}

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryDeepBlue,
      secondary: AppColors.secondaryRailwayGreen,
      surface: AppColors.neutralWhite,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.neutralDarkGrey,
    ),
    scaffoldBackgroundColor: AppColors.neutralWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.neutralWhite,
      foregroundColor: AppColors.neutralDarkGrey,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutralWhite,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        borderSide: BorderSide(color: AppColors.cardBorder, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        borderSide: BorderSide(color: AppColors.cardBorder, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        borderSide: const BorderSide(color: AppColors.primaryDeepBlue, width: 1.4),
      ),
    ),
  );
}
