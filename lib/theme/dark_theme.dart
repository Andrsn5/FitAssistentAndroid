import 'package:flutter/material.dart';

import 'platform_colors.dart';
import 'platform_text_styles.dart';

class DarkTheme {
  static const Color _seedColor = Color(0xFFFF9800);
  static const Color _defaultTextColor = Color(0xFFFFFFFF);

  PlatformColors get platformColors => const PlatformColors(
        colorScheme: ColorScheme.dark(
          primary: _seedColor,
          surface: Color(0xFF121212),
          onSurface: _defaultTextColor,
        ),
        background: Color(0xFF000000),
        surface: Color(0xFF121212),
        textPrimary: _defaultTextColor,
        textSecondary: Color(0xFFBDBDBD),
        border: Color(0xFF2C2C2C),
        headerTextColor: _defaultTextColor,
      );

  PlatformTextStyles get platformTextStyles => PlatformTextStyles.create(
        platformColors: platformColors,
        defaultTextColor: _defaultTextColor,
      );

  ThemeData get themeData {
    final colors = platformColors;
    final styles = platformTextStyles;

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colors.colorScheme,
      scaffoldBackgroundColor: colors.background,
      textTheme: ThemeData.dark().textTheme.copyWith(
            titleMedium: styles.h2SemiBold,
          ),
    );
  }
}

