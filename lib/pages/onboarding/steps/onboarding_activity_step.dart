import 'package:flutter/material.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/validators/input_constraints.dart';

class OnboardingActivityStep extends StatelessWidget {
  const OnboardingActivityStep({
    super.key,
    required this.firstNameController,
    required this.value,
    required this.onChanged,
  });

  final TextEditingController firstNameController;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    final name = firstNameController.text.trim();
    final titleName = name.isEmpty ? 'Имя' : name;
    final index = InputConstraints.activityIndexForValue(value);
    final canGoBack = index > 0;
    final canGoForward = index < InputConstraints.activityLevels.length - 1;

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
                '$titleName, какой у тебя уровень активности?',
                textAlign: TextAlign.center,
                style: context.platformTextStyles.h2SemiBold.copyWith(
                  fontSize: sizes.onboardingTitleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: sizes.onboardingGoalTitleBottomSpacing),
              Text(
                'Выбери вариант, который лучше всего описывает твой день.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textSecondary),
              ),
              SizedBox(height: sizes.onboardingAboutTitleBottomSpacing),
              Text(
                InputConstraints.activityLabelForValue(value),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: sizes.onboardingAboutTitleBottomSpacing),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: colors.primaryColor,
                  inactiveTrackColor: colors.authDividerColor,
                  thumbColor: colors.primaryColor,
                ),
                child: Slider(
                  min: 0,
                  max: (InputConstraints.activityLevels.length - 1).toDouble(),
                  divisions: InputConstraints.activityLevels.length - 1,
                  value: index.toDouble(),
                  onChanged: (v) {
                    final i = v.round().clamp(
                      0,
                      InputConstraints.activityLevels.length - 1,
                    );
                    onChanged(InputConstraints.activityLevels[i]);
                  },
                ),
              ),
              SizedBox(height: sizes.onboardingAboutAfterGenderSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: sizes.onboardingActivityAdjustButtonHeight,
                      child: ElevatedButton(
                        onPressed: canGoBack
                            ? () => onChanged(
                                InputConstraints.activityLevels[index - 1],
                              )
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.authSecondaryButtonBackground,
                          foregroundColor: colors.authSecondaryButtonText,
                          elevation: 0,
                        ),
                        child: const Text(
                          'Меньше',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: sizes.onboardingActivityAdjustButtonsSpacing),
                  Expanded(
                    child: SizedBox(
                      height: sizes.onboardingActivityAdjustButtonHeight,
                      child: ElevatedButton(
                        onPressed: canGoForward
                            ? () => onChanged(
                                InputConstraints.activityLevels[index + 1],
                              )
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.authSecondaryButtonBackground,
                          foregroundColor: colors.authSecondaryButtonText,
                          elevation: 0,
                        ),
                        child: const Text(
                          'Больше',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
