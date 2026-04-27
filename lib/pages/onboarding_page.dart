import 'package:flutter/material.dart';
import 'package:fitassistent/common/feature_flags.dart';
import 'package:fitassistent/common/fit_top_notice.dart';
import 'package:fitassistent/common/native_auth_api.dart';
import 'package:fitassistent/pages/onboarding/onboarding_models.dart';
import 'package:fitassistent/pages/onboarding/steps/onboarding_about_step.dart';
import 'package:fitassistent/pages/onboarding/steps/onboarding_budget_step.dart';
import 'package:fitassistent/pages/onboarding/steps/onboarding_goal_step.dart';
import 'package:fitassistent/pages/onboarding/steps/onboarding_name_step.dart';
import 'package:fitassistent/pages/onboarding/widgets/onboarding_page_indicator.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/validators/input_constraints.dart';
import 'package:fitassistent/validators/onboarding_mappings.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

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
  bool _submitting = false;

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

  Future<void> _next() async {
    final sizes = context.platformSizes;

    if (FeatureFlags.shouldValidateOnboarding) {
      if (_index == 0 && _nameController.text.trim().isEmpty) {
        showFitTopNotice(
          context,
          text: 'Введите имя',
          icon: Icons.info_outline,
        );
        return;
      }
      if (_index == 1) {
        final genderOk = _gender != null;

        final height = int.tryParse(_heightController.text.trim());
        final weight = double.tryParse(
          _weightController.text.trim().replaceAll(',', '.'),
        );
        final age = int.tryParse(_ageController.text.trim());

        final heightOk = height != null &&
            height >= InputConstraints.minHeightCm &&
            height <= InputConstraints.maxHeightCm;
        final weightOk = weight != null &&
            weight >= InputConstraints.minWeightKg &&
            weight <= InputConstraints.maxWeightKg;
        final ageOk = age != null &&
            age >= InputConstraints.minAgeYears &&
            age <= InputConstraints.maxAgeYears;

        if (!heightOk || !weightOk || !ageOk || !genderOk) {
          showFitTopNotice(
            context,
            text: 'Введите корректные значения чтобы продолжить',
            icon: Icons.info_outline,
          );
          return;
        }
      }
      if (_index == 2) {
        final budget = int.tryParse(_budgetController.text.trim());
        if (budget == null || budget < InputConstraints.minWeeklyBudget) {
          showFitTopNotice(
            context,
            text: 'Введите корректный бюджет чтобы продолжить',
            icon: Icons.info_outline,
          );
          return;
        }
      }
      if (_index == 3) {
        if (_goal == null) {
          showFitTopNotice(
            context,
            text: 'Заполните все поля чтобы продолжить',
            icon: Icons.info_outline,
          );
          return;
        }
      }
    }

    if (_index >= sizes.onboardingPagesCount - 1) {
      await _submitAndLoadProfile();
      return;
    }

    _controller.nextPage(
      duration: Duration(milliseconds: sizes.onboardingPageTransitionMs),
      curve: Curves.easeOut,
    );
  }

  Future<void> _submitAndLoadProfile() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    try {
      final shouldValidate = FeatureFlags.shouldValidateOnboarding;

      final nameRaw = _nameController.text.trim();
      final parts = nameRaw.split(RegExp(r"\s+")).where((p) => p.isNotEmpty);
      final firstName = parts.isNotEmpty ? parts.first : 'User';
      final lastName = parts.length > 1 ? parts.skip(1).join(' ') : 'User';

      final height = int.tryParse(_heightController.text.trim());
      final weight = double.tryParse(
        _weightController.text.trim().replaceAll(',', '.'),
      );
      final age = int.tryParse(_ageController.text.trim());
      final budget = int.tryParse(_budgetController.text.trim());

      if (shouldValidate) {
        if (height == null ||
            weight == null ||
            age == null ||
            budget == null ||
            _gender == null ||
            _goal == null) {
          showFitTopNotice(
            context,
            text: 'Заполните все поля чтобы продолжить',
            icon: Icons.info_outline,
          );
          return;
        }
      }

      final resolvedHeight = height ?? InputConstraints.minHeightCm;
      final resolvedWeight = weight ?? InputConstraints.minWeightKg;
      final resolvedAge = age ?? InputConstraints.minAgeYears;
      final resolvedBudget = budget ?? InputConstraints.minWeeklyBudget;

      final gender = _gender == OnboardingGender.male ? 'MALE' : 'FEMALE';
      final goal = _goal ?? OnboardingGoal.maintainWeight;
      final targetId = OnboardingMappings.targetIdForGoal(goal);

      final now = DateTime.now();
      final birthYear = now.year - resolvedAge;
      final birthDate = DateTime(birthYear, 1, 1);
      final birthDateStr =
          '${birthDate.year.toString().padLeft(4, '0')}-01-01';

      final ok = await NativeAuthApi.register(
        email: widget.email,
        password: widget.password,
        firstName: firstName,
        lastName: lastName,
        weight: resolvedWeight,
        height: resolvedHeight,
        birthDate: birthDateStr,
        gender: gender,
        targetId: targetId,
        weeklyBudget: resolvedBudget.toDouble(),
      );

      if (!mounted) return;

      if (!ok) {
        showFitTopNotice(
          context,
          text: 'REGISTER FAILED',
          icon: Icons.error_outline,
        );
        return;
      }

      showFitTopNotice(
        context,
        text: 'REGISTER SUCCESS',
        icon: Icons.check_circle_outline,
      );

      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      final profile = await NativeAuthApi.profile();
      if (!mounted) return;

      showFitTopNotice(
        context,
        text: profile?.toString() ?? 'EMPTY PROFILE',
        icon: Icons.info_outline,
      );

      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      Navigator.of(context).pop();
    } on Exception catch (e) {
      if (!mounted) return;
      showFitTopNotice(
        context,
        text: 'ERROR: $e',
        icon: Icons.error_outline,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
                        onPressed: _submitting ? null : _next,
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

