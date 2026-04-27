import 'package:flutter/material.dart';
import 'package:fitassistent/common/fit_text_field.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/validators/input_constraints.dart';

class OnboardingBudgetStep extends StatelessWidget {
  const OnboardingBudgetStep({
    super.key,
    required this.nameController,
    required this.budgetController,
  });

  final TextEditingController nameController;
  final TextEditingController budgetController;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    final name = nameController.text.trim();
    final titleName = name.isEmpty ? 'Имя' : name;

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
              SizedBox(height: sizes.onboardingBudgetBlockTopSpacing),
              Padding(
                padding: EdgeInsets.only(
                  bottom: sizes.onboardingFieldLabelBottomPadding,
                ),
                child: Text(
                  'Ваш бюджет',
                  style: TextStyle(
                    fontSize: sizes.onboardingFieldLabelFontSize,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              FitTextField(
                controller: budgetController,
                hintText: '',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: InputConstraints.budgetMaxLength,
                inputFormatters: [InputConstraints.digitsOnlyFormatter],
              ),
              SizedBox(height: sizes.onboardingBudgetAfterFieldSpacing),
              Container(
                padding: EdgeInsets.all(
                  sizes.onboardingBudgetRecommendationPadding,
                ),
                decoration: BoxDecoration(
                  color: colors.recomendationBlockBackground,
                  borderRadius: BorderRadius.circular(
                    sizes.onboardingBudgetRecommendationRadius,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Рекомендация',
                      style: TextStyle(
                        fontSize: sizes.onboardingFieldLabelFontSize,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(
                      height:
                          sizes.onboardingBudgetRecommendationTitleToTextSpacing,
                    ),
                    const Text(
                      'Минимальный бюджет для сбалансированного питания: 2000 - 2500 руб/неделя',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

