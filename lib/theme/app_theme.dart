import 'package:flutter/material.dart';

import 'platform_colors.dart';
import 'platform_text_styles.dart' as pts;
import 'platform_sizes.dart' as psz;
import 'dark_theme.dart';
import 'light_theme.dart';

extension PlatformTextStylesGetter on BuildContext {
  pts.PlatformTextStyles get platformTextStyles => pts.platformTextStyles(this);
}

extension PlatformColorsGetter on BuildContext {
  PlatformColors get platformColors {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? DarkTheme().platformColors : LightTheme().platformColors;
  }
}

extension PlatformSizesGetter on BuildContext {
  psz.PlatformSizes get platformSizes => psz.platformSizes(this);
}

pts.PlatformTextStyles textStylesOf(BuildContext context) {
  return pts.platformTextStyles(context);
}

PlatformColors colorsOf(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? DarkTheme().platformColors : LightTheme().platformColors;
}

psz.PlatformSizes sizesOf(BuildContext context) {
  return psz.platformSizes(context);
}
