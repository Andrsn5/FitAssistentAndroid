import 'package:flutter/material.dart';
import 'package:fitassistent/common/feature_flags.dart';
import 'package:fitassistent/pages/onboarding/onboarding_models.dart';
import 'package:fitassistent/pages/onboarding/steps/onboarding_about_step.dart';
import 'package:fitassistent/pages/onboarding/steps/onboarding_budget_step.dart';
import 'package:fitassistent/pages/onboarding/steps/onboarding_goal_step.dart';
import 'package:fitassistent/pages/onboarding/steps/onboarding_name_step.dart';
import 'package:fitassistent/pages/onboarding/widgets/onboarding_page_indicator.dart';
import 'package:fitassistent/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _budgetController = TextEditingController();

  int _index = 0;
  OnboardingGender? _gender;
  OnboardingGoal? _goal;

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _next() {
    final sizes = context.platformSizes;

    if (FeatureFlags.shouldValidateOnboarding) {
      if (_index == 0 && _nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Введите имя')));
        return;
      }
      if (_index == 1) {
        final nameOk = _nameController.text.trim().isNotEmpty;
        final heightOk = _heightController.text.trim().isNotEmpty;
        final weightOk = _weightController.text.trim().isNotEmpty;
        final ageOk = _ageController.text.trim().isNotEmpty;
        final genderOk = _gender != null;

        if (!nameOk || !heightOk || !weightOk || !ageOk || !genderOk) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Заполните все поля чтобы продолжить'),
            ),
          );
          return;
        }
      }
      if (_index == 2) {
        if (_budgetController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Заполните все поля чтобы продолжить'),
            ),
          );
          return;
        }
      }
      if (_index == 3) {
        if (_goal == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Заполните все поля чтобы продолжить'),
            ),
          );
          return;
        }
      }
    }

    if (_index >= sizes.onboardingPagesCount - 1) {
      Navigator.of(context).pop();
      return;
    }

    _controller.nextPage(
      duration: Duration(milliseconds: sizes.onboardingPageTransitionMs),
      curve: Curves.easeOut,
    );
  }

  void _back() {
    final sizes = context.platformSizes;
    if (_index <= 0) return;

    _controller.previousPage(
      duration: Duration(milliseconds: sizes.onboardingPageTransitionMs),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    return Scaffold(
      backgroundColor: colors.authScreenBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizes.authOuterHorizontalPadding,
            vertical: sizes.authOuterVerticalPadding,
          ),
          child: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                color: colors.authCardBackground,
                borderRadius: BorderRadius.circular(sizes.onboardingCardRadius),
              ),
              child: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (value) => setState(() => _index = value),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      OnboardingNameStep(controller: _nameController),
                      OnboardingAboutStep(
                        nameController: _nameController,
                        heightController: _heightController,
                        weightController: _weightController,
                        ageController: _ageController,
                        gender: _gender,
                        onGenderChanged: (value) =>
                            setState(() => _gender = value),
                      ),
                      OnboardingBudgetStep(
                        nameController: _nameController,
                        budgetController: _budgetController,
                      ),
                      OnboardingGoalStep(
                        goal: _goal,
                        onGoalChanged: (value) => setState(() => _goal = value),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: sizes.onboardingBottomIndicatorPadding,
                    child: OnboardingPageIndicator(
                      count: sizes.onboardingPagesCount,
                      index: _index,
                      activeColor: colors.primaryColor,
                      inactiveColor: colors.authDividerColor,
                    ),
                  ),
                  Positioned(
                    left: sizes.onboardingNavButtonHorizontalPadding,
                    bottom: sizes.onboardingNavButtonBottomPadding,
                    child: _index > 0
                        ? SizedBox(
                            width: sizes.onboardingNavActionButtonSize,
                            height: sizes.onboardingNavActionButtonSize,
                            child: ElevatedButton(
                              onPressed: _back,
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(
                                  side: BorderSide(
                                    color: colors.textPrimary,
                                    width: sizes.onboardingNavBorderWidth,
                                  ),
                                ),
                                backgroundColor: colors.authCardBackground,
                                foregroundColor: colors.textPrimary,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                size: sizes.onboardingNavActionIconSize,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Positioned(
                    right: sizes.onboardingNavButtonHorizontalPadding,
                    bottom: sizes.onboardingNavButtonBottomPadding,
                    child: SizedBox(
                      width: sizes.onboardingNavActionButtonSize,
                      height: sizes.onboardingNavActionButtonSize,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(
                            side: BorderSide(
                              color: colors.textPrimary,
                              width: sizes.onboardingNavBorderWidth,
                            ),
                          ),
                          backgroundColor: colors.authCardBackground,
                          foregroundColor: colors.textPrimary,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: sizes.onboardingNavActionIconSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

