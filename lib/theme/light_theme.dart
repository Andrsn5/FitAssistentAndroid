import 'package:flutter/material.dart';

import 'platform_colors.dart';
import 'platform_sizes.dart';
import 'platform_text_styles.dart';

class LightTheme {
  static const Color _seedColor = Color(0xFF0B6E4F);
  static const Color _defaultTextColor = Color(0xFF000000);
  static const Color _authCardBackground = Color(0xFFFFFFFF);
  static const Color _authScreenBackground = Color(0xFFF4F4F4);
  static const Color _authFieldBackground = Color(0xFFFFFFFF);
  static const Color _authFieldBorder = Color(0xFFD9D9D9);
  static const Color _authHintTextColor = Color(0xFF8C8C8C);
  static const Color _authDividerColor = Color(0xFFE6E6E6);
  static const Color _authPrimaryButtonBackground = Color(0xFF2C2C2C);
  static const Color _authPrimaryButtonText = Color(0xFFFFFFFF);
  static const Color _authSecondaryButtonBackground = Color(0xFFEDEDED);
  static const Color _authSecondaryButtonText = Color(0xFF2C2C2C);
  static const Color _recomendationBlockBackground = Color(0xFFE6E6E6);

  PlatformColors get platformColors => const PlatformColors(
        colorScheme: ColorScheme.light(
          primary: _seedColor,
          surface: Color(0xFFFFFFFF),
          onSurface: _defaultTextColor,
        ),
        background: _authScreenBackground,
        surface: _authCardBackground,
        textPrimary: _defaultTextColor,
        textSecondary: Color(0xFF333333),
        border: Color(0xFFE0E0E0),
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
      brightness: Brightness.light,
      colorScheme: colors.colorScheme,
      primaryColor: colors.colorScheme.primary,
      scaffoldBackgroundColor: colors.background,
      textTheme: ThemeData.light().textTheme.copyWith(
            titleMedium: styles.h2SemiBold,
          ),
    );
  }
}

