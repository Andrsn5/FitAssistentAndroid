import 'package:flutter/material.dart';
import 'package:fitassistent/common/fit_text_field.dart';
import 'package:fitassistent/theme/app_theme.dart';

class OnboardingLabeledField extends StatelessWidget {
  const OnboardingLabeledField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: sizes.onboardingFieldLabelBottomPadding,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: sizes.onboardingFieldLabelFontSize,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ),
        FitTextField(
          controller: controller,
          hintText: hintText,
          height: sizes.inputFieldHeight,
        ),
      ],
    );
  }
}

