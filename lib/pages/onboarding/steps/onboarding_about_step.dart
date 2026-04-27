import 'package:flutter/material.dart';
import 'package:fitassistent/common/fit_buttons.dart';
import 'package:fitassistent/pages/onboarding/onboarding_models.dart';
import 'package:fitassistent/pages/onboarding/widgets/onboarding_labeled_field.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/validators/input_constraints.dart';

class OnboardingAboutStep extends StatelessWidget {
  const OnboardingAboutStep({
    super.key,
    required this.nameController,
    required this.heightController,
    required this.weightController,
    required this.ageController,
    required this.gender,
    required this.onGenderChanged,
  });

  final TextEditingController nameController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController ageController;
  final OnboardingGender? gender;
  final ValueChanged<OnboardingGender> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    final name = nameController.text.trim();
    final titleName = name.isEmpty ? 'Имя' : name;
    final isMaleSelected = gender == OnboardingGender.male;
    final isFemaleSelected = gender == OnboardingGender.female;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: sizes.onboardingContentMaxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizes.onboardingStepHorizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$titleName, расскажи о себе',
                style: context.platformTextStyles.h2SemiBold.copyWith(
                  fontSize: sizes.onboardingTitleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: sizes.onboardingAboutTitleBottomSpacing),
              OnboardingLabeledField(
                label: 'Ваш рост',
                controller: heightController,
                hintText: 'Рост(см)',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                maxLength: InputConstraints.heightMaxLength,
                inputFormatters: [InputConstraints.digitsOnlyFormatter],
              ),
              SizedBox(height: sizes.onboardingAboutFieldSpacing),
              OnboardingLabeledField(
                label: 'Ваш вес',
                controller: weightController,
                hintText: 'Вес(кг)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                maxLength: InputConstraints.weightMaxLength,
                inputFormatters: [InputConstraints.decimalNumberFormatter],
              ),
              SizedBox(height: sizes.onboardingAboutFieldSpacing),
              OnboardingLabeledField(
                label: 'Ваш возраст',
                controller: ageController,
                hintText: 'Возраст (лет)',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: InputConstraints.ageMaxLength,
                inputFormatters: [InputConstraints.digitsOnlyFormatter],
              ),
              SizedBox(height: sizes.onboardingBudgetBlockTopSpacing),
              Row(
                children: [
                  Expanded(
                    child: FitSelectablePillButton(
                      selected: isMaleSelected,
                      text: 'Мужской',
                      onPressed: () => onGenderChanged(OnboardingGender.male),
                    ),
                  ),
                  SizedBox(width: sizes.onboardingAboutGenderSpacing),
                  Expanded(
                    child: FitSelectablePillButton(
                      selected: isFemaleSelected,
                      text: 'Женский',
                      onPressed: () => onGenderChanged(OnboardingGender.female),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizes.onboardingAboutAfterGenderSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

