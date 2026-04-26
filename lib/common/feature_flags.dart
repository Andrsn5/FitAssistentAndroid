import 'package:flutter/foundation.dart';

class FeatureFlags {
  const FeatureFlags._();

  static const bool onboardingValidationInDebug = false;

  static bool get shouldValidateOnboarding =>
      !kDebugMode || onboardingValidationInDebug;
}

