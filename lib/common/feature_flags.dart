import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FeatureFlags {
  const FeatureFlags._();

  static const bool onboardingValidationInDebug = true;
  static const bool lightThemeByDefault = false;

  static bool get shouldValidateOnboarding =>
      !kDebugMode || onboardingValidationInDebug;

  static ThemeMode get defaultThemeMode =>
      lightThemeByDefault ? ThemeMode.light : ThemeMode.dark;
}

