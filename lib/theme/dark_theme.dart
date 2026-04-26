import 'package:flutter/material.dart';

import 'platform_colors.dart';
import 'platform_sizes.dart';
import 'platform_text_styles.dart';

class DarkTheme {
  static const Color _seedColor = Color(0xFF0B6E4F);
  static const Color _defaultTextColor = Color(0xFFFFFFFF);
  static const Color _authCardBackground = Color(0xFF121212);
  static const Color _authScreenBackground = Color(0xFF0E0E0E);
  static const Color _authFieldBackground = Color(0xFF1B1B1B);
  static const Color _authFieldBorder = Color(0xFF2C2C2C);
  static const Color _authHintTextColor = Color(0xFF8C8C8C);
  static const Color _authDividerColor = Color(0xFF2C2C2C);
  static const Color _authPrimaryButtonBackground = Color(0xFFFFFFFF);
  static const Color _authPrimaryButtonText = Color(0xFF000000);
  static const Color _authSecondaryButtonBackground = Color(0xFF1F1F1F);
  static const Color _authSecondaryButtonText = Color(0xFFFFFFFF);
  static const Color _recomendationBlockBackground = Color(0xFF1F1F1F);

  PlatformColors get platformColors => const PlatformColors(
        colorScheme: ColorScheme.dark(
          primary: _seedColor,
          surface: Color(0xFF121212),
          onSurface: _defaultTextColor,
        ),
        background: _authScreenBackground,
        surface: _authCardBackground,
        textPrimary: _defaultTextColor,
        textSecondary: Color(0xFFBDBDBD),
        border: Color(0xFF2C2C2C),
        headerTextColor: _defaultTextColor,
        primaryColor: _seedColor,
        authScreenBackground: _authScreenBackground,
        authCardBackground: _authCardBackground,
        authFieldBackground: _authFieldBackground,
        authFieldBorder: _authFieldBorder,
        authHintTextColor: _authHintTextColor,
        authLinkTextColor: _seedColor,
        authDividerColor: _authDividerColor,
        authPrimaryButtonBackground: _authPrimaryButtonBackground,
        authPrimaryButtonText: _authPrimaryButtonText,
        authSecondaryButtonBackground: _authSecondaryButtonBackground,
        authSecondaryButtonText: _authSecondaryButtonText,
        recomendationBlockBackground: _recomendationBlockBackground,
      );

  PlatformTextStyles get platformTextStyles => PlatformTextStyles.create(
        platformColors: platformColors,
        defaultTextColor: _defaultTextColor,
      );

  PlatformSizes get platformSizes => PlatformSizes.standard();

  ThemeData get themeData {
    final colors = platformColors;
    final styles = platformTextStyles;

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colors.colorScheme,
      primaryColor: colors.colorScheme.primary,
      scaffoldBackgroundColor: colors.background,
      textTheme: ThemeData.dark().textTheme.copyWith(
            titleMedium: styles.h2SemiBold,
          ),
    );
  }
}

