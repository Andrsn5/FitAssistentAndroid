import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'light_theme.dart';
import 'dark_theme.dart';
import 'platform_colors.dart';

class HeaderTextStyle extends TextStyle {
  static const double _fontSize = 32;
  static const double _lineHeight = 1.0;
  static const double _letterSpacing = 0.0;

  const HeaderTextStyle({
    Color color = const Color(0xFF000000),
  }) : super(
          fontSize: _fontSize,
          height: _lineHeight,
          letterSpacing: _letterSpacing,
          fontWeight: FontWeight.w700,
          color: color,
        );

  static TextStyle resolve({Color color = const Color(0xFF000000)}) {
    return GoogleFonts.montserrat(
      fontSize: _fontSize,
      height: _lineHeight,
      letterSpacing: _letterSpacing,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}

@immutable
class PlatformTextStyles {
  final TextStyle headerTextStyle;
  final TextStyle h2SemiBold;

  const PlatformTextStyles({
    required this.headerTextStyle,
    required this.h2SemiBold,
  });

  static const double _h2FontSize = 16;
  static const double _h2LineHeight = 24 / 16;

  factory PlatformTextStyles.create({
    required PlatformColors platformColors,
    required Color defaultTextColor,
  }) {
    final base = ThemeData.light().textTheme;
    final h2SemiBold = (base.titleMedium ?? const TextStyle()).copyWith(
      fontSize: _h2FontSize,
      height: _h2LineHeight,
      fontWeight: FontWeight.w600,
      color: defaultTextColor,
    );

    return PlatformTextStyles(
      headerTextStyle: HeaderTextStyle.resolve(
        color: platformColors.headerTextColor,
      ),
      h2SemiBold: h2SemiBold,
    );
  }
}

PlatformTextStyles platformTextStyles(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final PlatformColors colors =
      isDark ? DarkTheme().platformColors : LightTheme().platformColors;

  final Color defaultTextColor =
      isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

  return PlatformTextStyles.create(
    platformColors: colors,
    defaultTextColor: defaultTextColor,
  );
}
