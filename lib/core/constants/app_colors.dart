import 'package:flutter/material.dart';

/// Design tokens from the Stitch "Luminous Learning" iEducation Design System
class AppColors {
  const AppColors._();

  // Primary palette (Solar Gold)
  static const Color primary = Color(0xFFFFC107); // Solar Gold
  static const Color primaryContainer = Color(0xFFFABD00);
  static const Color onPrimary = Color(0xFF000000); // High contrast text on gold
  static const Color onPrimaryContainer = Color(0xFF6D5100);
  static const Color primaryFixed = Color(0xFFFFDF9E);
  static const Color primaryFixedDim = Color(0xFFFABD00);
  static const Color primaryDark = Color(0xFFC79100);
  static const Color primaryLight = Color(0xFFFFE4AF);

  // Secondary palette (Royal & Deep Purple)
  static const Color secondary = Color(0xFF5D2D9F); // Royal Purple
  static const Color secondaryDark = Color(0xFF4A148C);
  static const Color secondaryContainer = Color(0xFF7B1FA2);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFFCBA8FF);
  static const Color secondaryFixed = Color(0xFFEDDCFF);
  static const Color secondaryFixedDim = Color(0xFFD7BAFF);

  // Tertiary palette (Sunset Orange / Warm Accent)
  static const Color tertiary = Color(0xFFFF9800); // Sunset Orange
  static const Color tertiaryContainer = Color(0xFFFFBE7E);
  static const Color accent = Color(0xFFFFC107); // Gold accent
  static const Color accentOrange = Color(0xFFFF9800);

  // Surface & Neutral tones (Midnight Dark)
  static const Color background = Color(0xFF121414); // Midnight Dark Canvas
  static const Color backgroundDark = Color(0xFF0C0F0F);
  static const Color canvasPurple = Color(0xFF1E1B2E);
  static const Color surface = Color(0xFF1E2020);
  static const Color surfaceContainerLowest = Color(0xFF0C0F0F);
  static const Color surfaceContainerLow = Color(0xFF1A1C1C);
  static const Color surfaceContainer = Color(0xFF1E2020);
  static const Color surfaceContainerHigh = Color(0xFF282A2B);
  static const Color surfaceContainerHighest = Color(0xFF333535);
  static const Color surfaceDim = Color(0xFF121414);
  static const Color surfaceBright = Color(0xFF38393A);
  static const Color surfaceDark = Color(0xFF0C0F0F);

  // Text & Content colors
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFD4C5AB);
  static const Color onBackground = Color(0xFFE2E2E2);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A5BD);
  static const Color textMuted = Color(0xFF9C8F78);

  // Status colors
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF5252);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF29B6F6);

  // Role badges
  static const Color roleStudent = Color(0xFFFFC107);
  static const Color roleTeacher = Color(0xFFBA68C8);
  static const Color roleAdmin = Color(0xFFFF5252);

  // Outline, Border & Divider
  static const Color outline = Color(0xFF9C8F78);
  static const Color outlineVariant = Color(0xFF4F4632);
  static const Color border = Color(0xFF333535);
  static const Color borderLight = Color(0xFF424242);
  static const Color divider = Color(0xFF282A2B);

  // Gradients
  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2E1065), // Deep Midnight Purple
      Color(0xFF121414), // Dark Canvas
    ],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [
      Color(0xFFFFC107),
      Color(0xFFFFB300),
    ],
  );
}
