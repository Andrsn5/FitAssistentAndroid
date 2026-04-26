import 'package:flutter/material.dart';

import 'platform_colors.dart';
import 'platform_text_styles.dart';

class LightTheme {
  static const Color _seedColor = Color(0xFFFF9800);
  static const Color _defaultTextColor = Color(0xFF000000);

  PlatformColors get platformColors => const PlatformColors(
        colorScheme: ColorScheme.light(
          primary: _seedColor,
          surface: Color(0xFFFFFFFF),
          onSurface: _defaultTextColor,
        ),
        background: Color(0xFFFFFFFF),
        surface: Color(0xFFFFFFFF),
        textPrimary: _defaultTextColor,
        textSecondary: Color(0xFF333333),
        border: Color(0xFFE0E0E0),
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
      brightness: Brightness.light,
      colorScheme: colors.colorScheme,
      scaffoldBackgroundColor: colors.background,
      textTheme: ThemeData.light().textTheme.copyWith(
            titleMedium: styles.h2SemiBold,
          ),
    );
  }
}

