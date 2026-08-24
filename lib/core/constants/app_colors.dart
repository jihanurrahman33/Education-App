import 'package:flutter/material.dart';

/// Design tokens from the Stitch "Academic Modernist" Design System
class AppColors {
  const AppColors._();

  // Primary palette (Academic Blue)
  static const Color primary = Color(0xFF003FB1); // Deep Academic Blue
  static const Color primaryContainer = Color(0xFF1A56DB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFD4DCFF);
  static const Color primaryFixed = Color(0xFFDBE1FF);
  static const Color primaryFixedDim = Color(0xFFB5C4FF);
  static const Color primaryDark = Color(0xFF002B7F);
  static const Color primaryLight = Color(0xFF3B82F6);

  // Secondary palette (Success Green)
  static const Color secondary = Color(0xFF006C4A); // Success Green
  static const Color secondaryContainer = Color(0xFF82F5C1);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF00714E);
  static const Color secondaryFixed = Color(0xFF85F8C4);
  static const Color secondaryFixedDim = Color(0xFF68DBA9);

  // Tertiary palette (Accent Amber / Orange)
  static const Color tertiary = Color(0xFF694100);
  static const Color tertiaryContainer = Color(0xFF895600);
  static const Color accent = Color(0xFFF59E0B); // Amber / Warm Accent
  static const Color accentOrange = Color(0xFFFF9800);

  // Surface & Neutral tones
  static const Color background = Color(0xFFF9F9FF);
  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF0F3FF);
  static const Color surfaceContainer = Color(0xFFE7EEFE);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F8);
  static const Color surfaceContainerHighest = Color(0xFFDCE2F3);
  static const Color surfaceDim = Color(0xFFD3DAEA);
  static const Color surfaceBright = Color(0xFFF9F9FF);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Text & Content colors
  static const Color onSurface = Color(0xFF151C27);
  static const Color onSurfaceVariant = Color(0xFF434654);
  static const Color onBackground = Color(0xFF151C27);
  static const Color textPrimary = Color(0xFF151C27);
  static const Color textSecondary = Color(0xFF434654);
  static const Color textMuted = Color(0xFF737686);

  // Status colors
  static const Color success = Color(0xFF006C4A);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF1353D8);

  // Role badges
  static const Color roleStudent = Color(0xFF003FB1);
  static const Color roleTeacher = Color(0xFF6D28D9);
  static const Color roleAdmin = Color(0xFFBA1A1A);

  // Outline, Border & Divider
  static const Color outline = Color(0xFF737686);
  static const Color outlineVariant = Color(0xFFC3C5D7);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEEF2F6);
}
