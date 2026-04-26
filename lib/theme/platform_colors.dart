import 'package:flutter/material.dart';

class PlatformColors {
  final ColorScheme colorScheme;

  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;

  final Color headerTextColor;
  final Color primaryColor;

  const PlatformColors({
    required this.colorScheme,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.headerTextColor,
    required this.primaryColor,
  });

  factory PlatformColors.of(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return PlatformColors(
      colorScheme: scheme,
      background: theme.scaffoldBackgroundColor,
      surface: scheme.surface,
      textPrimary: theme.textTheme.bodyLarge?.color ?? scheme.onSurface,
      textSecondary: theme.textTheme.bodyMedium?.color ?? scheme.onSurface,
      border: scheme.outline,
      headerTextColor: const Color(0xFF000000),
      primaryColor: theme.primaryColor,
    );
  }
}

PlatformColors platformColors(BuildContext context) {
  return PlatformColors.of(context);
}
