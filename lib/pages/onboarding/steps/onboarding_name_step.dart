import 'package:flutter/material.dart';
import 'package:fitassistent/common/fit_text_field.dart';
import 'package:fitassistent/theme/app_theme.dart';

class OnboardingNameStep extends StatelessWidget {
  const OnboardingNameStep({super.key, required this.controller});

  final TextEditingController controller;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Давай знакомиться!',
                style: context.platformTextStyles.h2SemiBold.copyWith(
                  fontSize: sizes.onboardingTitleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: sizes.onboardingNameTitleBottomSpacing),
              Text(
                'Как тебя зовут?',
                style: TextStyle(color: colors.textPrimary),
              ),
              SizedBox(height: sizes.onboardingNameLabelBottomSpacing),
              FitTextField(controller: controller, hintText: ''),
            ],
          ),
        ),
      ),
    );
  }
}

