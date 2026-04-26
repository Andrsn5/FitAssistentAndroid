import 'package:flutter/material.dart';
import 'package:fitassistent/common/fit_buttons.dart';
import 'package:fitassistent/pages/onboarding/onboarding_models.dart';
import 'package:fitassistent/theme/app_theme.dart';

class OnboardingGoalStep extends StatelessWidget {
  const OnboardingGoalStep({
    super.key,
    required this.goal,
    required this.onGoalChanged,
  });

  final OnboardingGoal? goal;
  final ValueChanged<OnboardingGoal> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: sizes.onboardingContentMaxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizes.onboardingStepHorizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Какова ваша цель?',
                textAlign: TextAlign.center,
                style: context.platformTextStyles.h2SemiBold.copyWith(
                  fontSize: sizes.onboardingTitleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: sizes.onboardingGoalTitleBottomSpacing),
              FitSelectablePillButton(
                selected: goal == OnboardingGoal.massGain,
                text: 'Набор массы',
                onPressed: () => onGoalChanged(OnboardingGoal.massGain),
              ),
              SizedBox(height: sizes.onboardingGoalButtonSpacing),
              FitSelectablePillButton(
                selected: goal == OnboardingGoal.weightLoss,
                text: 'Похудение',
                onPressed: () => onGoalChanged(OnboardingGoal.weightLoss),
              ),
              SizedBox(height: sizes.onboardingGoalButtonSpacing),
              FitSelectablePillButton(
                selected: goal == OnboardingGoal.maintainWeight,
                text: 'Вес',
                onPressed: () => onGoalChanged(OnboardingGoal.maintainWeight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

