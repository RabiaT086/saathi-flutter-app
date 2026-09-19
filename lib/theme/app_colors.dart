import 'package:flutter/material.dart';
import '../app_state.dart';

/// Shared colors for the whole Saathi app.
/// Keeping these as compile-time constants ensures standard Flutter widgets
/// with `const` compile cleanly without "Invalid constant value" errors.
class AppColors {
  static const Color background = Color(0xFFFDF6EC);
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF134E4A);
  static const Color textSecondary = Color(0xFF57534E);
  static const Color textMuted = Color(0xFF78716C);
  static const Color cardBorder = Color(0xFFD6E8E4);
  static const Color chipBackground = Color(0xFFE6F4F1);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerDark = Color(0xFF991B1B);

  // Dark Theme Palette Constants
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF2D3748);
  static const Color darkChip = Color(0xFF1A2E2B);
  static const Color darkTextPrimary = Color(0xFF5EEAD4);
  static const Color darkTextSecondary = Color(0xFFD6D3D1);
  static const Color darkTextMuted = Color(0xFFA8A29E);

  // Adaptive getters for screens/widgets that respond dynamically to theme toggle
  static bool get isDark => AppState.themeMode.value == ThemeMode.dark;
  static Color get cardBackground => isDark ? darkCard : Colors.white;
  static Color get adaptiveBackground => isDark ? darkBackground : background;
  static Color get adaptiveBorder => isDark ? darkBorder : cardBorder;
  static Color get adaptiveChip => isDark ? darkChip : chipBackground;
  static Color get adaptivePrimaryDark => isDark ? darkTextPrimary : primaryDark;
  static Color get adaptiveTextSecondary => isDark ? darkTextSecondary : textSecondary;
  static Color get adaptiveTextMuted => isDark ? darkTextMuted : textMuted;
}
