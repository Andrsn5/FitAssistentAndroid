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

  final Color authScreenBackground;
  final Color authCardBackground;
  final Color authFieldBackground;
  final Color authFieldBorder;
  final Color authHintTextColor;
  final Color authLinkTextColor;
  final Color authDividerColor;
  final Color authPrimaryButtonBackground;
  final Color authPrimaryButtonText;
  final Color authSecondaryButtonBackground;
  final Color authSecondaryButtonText;
  final Color authSocialButtonBackground;

  final Color recomendationBlockBackground;

  const PlatformColors({
    required this.colorScheme,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.headerTextColor,
    required this.primaryColor,
    required this.authScreenBackground,
    required this.authCardBackground,
    required this.authFieldBackground,
    required this.authFieldBorder,
    required this.authHintTextColor,
    required this.authLinkTextColor,
    required this.authDividerColor,
    required this.authPrimaryButtonBackground,
    required this.authPrimaryButtonText,
    required this.authSecondaryButtonBackground,
    required this.authSecondaryButtonText,
    required this.authSocialButtonBackground,
    required this.recomendationBlockBackground,
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
      authScreenBackground: theme.scaffoldBackgroundColor,
      authCardBackground: scheme.surface,
      authFieldBackground: scheme.surface,
      authFieldBorder: scheme.outline,
      authHintTextColor: scheme.onSurface.withAlpha(140),
      authLinkTextColor: scheme.primary,
      authDividerColor: scheme.outlineVariant,
      authPrimaryButtonBackground: scheme.primary,
      authPrimaryButtonText: scheme.onPrimary,
      authSecondaryButtonBackground: scheme.surfaceContainerHighest,
      authSecondaryButtonText: scheme.onSurface,
      authSocialButtonBackground: scheme.surfaceContainerHighest,
      recomendationBlockBackground: scheme.surfaceContainerHighest,
    );
  }
}

PlatformColors platformColors(BuildContext context) {
  return PlatformColors.of(context);
}
