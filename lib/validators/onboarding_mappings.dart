import 'package:fitassistent/pages/onboarding/onboarding_models.dart';

class OnboardingMappings {
  const OnboardingMappings._();

  // Backend target IDs
  static const int targetIdMassGain = 1;
  static const int targetIdWeightLoss = 2;
  static const int targetIdMaintainWeight = 3;

  static int targetIdForGoal(OnboardingGoal goal) {
    return switch (goal) {
      OnboardingGoal.massGain => targetIdMassGain,
      OnboardingGoal.weightLoss => targetIdWeightLoss,
      OnboardingGoal.maintainWeight => targetIdMaintainWeight,
    };
  }
}

