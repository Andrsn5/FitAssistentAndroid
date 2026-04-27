import 'package:flutter/material.dart';

class PlatformSizes {
  static const double _buttonHeight = 57;
  static const double _inputFieldHeight = 57;
  static const double _recomendationBlockHeight = 84;
  static const double _profileIconSize = 87;
  static const double _navigationButtonHeight = 54;
  static const double _slideBarToggleSize = 15;

  // Common
  static const double _commonFieldBorderRadius = 16;
  static const double _commonFieldHorizontalPadding = 16;
  static const double _commonFieldVerticalPadding = 18;
  static const double _commonButtonBorderRadius = 16;
  static const double _commonFieldPrefixIconSize = 22;
  static const double _commonFieldPrefixIconGap = 10;
  static const double _authForgotVerticalPadding = 20;
  static const double _commonFieldPrefixIconDy = -1;
  static const double _commonTopNoticeHorizontalMargin = 16;
  static const double _commonTopNoticeVerticalPadding = 12;
  static const double _commonTopNoticeHorizontalPadding = 14;
  static const double _commonTopNoticeRadius = 16;
  static const double _commonTopNoticeTopOffset = 12;
  static const double _commonTopNoticeIconSize = 18;
  static const double _commonTopNoticeIconGap = 8;
  static const int _commonTopNoticeAnimationMs = 160;

  // Auth / Registration pages
  static const double _authOuterHorizontalPadding = 20;
  static const double _authOuterVerticalPadding = 30;
  static const double _authCardHorizontalPadding = 20;
  static const double _authCardVerticalPadding = 28;
  static const double _authCardRadius = 28;
  static const double _authTitleToIconSpacing = 40;
  static const double _authIconToFieldsSpacing = 40;
  static const double _authFieldsSpacing = 15;
  static const double _authForgotSpacing = 5;
  static const double _authPrimaryToDividerSpacing = 18;
  static const double _authDividerHorizontalPadding = 12;
  static const double _authDividerToSecondarySpacing = 14;
  static const double _authSecondaryButtonsSpacing = 12;
  static const double _authSocialIconSize = 18;
  static const double _authSocialIconGap = 5;

  // Onboarding (layout + navigation)
  static const int _onboardingPagesCount = 5;
  static const double _onboardingCardRadius = 28;
  static const double _onboardingIndicatorDotSize = 10;
  static const double _onboardingIndicatorDotSpacing = 8;
  static const double _onboardingBottomIndicatorPadding = 24;
  static const double _onboardingNavActionButtonSize = 56;
  static const double _onboardingNavActionIconSize = 28;
  static const double _onboardingNavBorderWidth = 2;
  static const double _onboardingNavButtonHorizontalPadding = 24;
  static const double _onboardingNavButtonBottomPadding = 64;
  static const int _onboardingPageTransitionMs = 220;

  // Onboarding steps (shared)
  static const double _onboardingStepHorizontalPadding = 28;
  static const double _onboardingContentMaxWidth = 520;
  static const double _onboardingTitleFontSize = 28;

  // Onboarding: name step
  static const double _onboardingNameTitleBottomSpacing = 20;
  static const double _onboardingNameLabelBottomSpacing = 10;
  static const double _onboardingNameFieldsSpacing = 12;

  // Onboarding: about step
  static const double _onboardingAboutTitleBottomSpacing = 18;
  static const double _onboardingAboutFieldSpacing = 14;
  static const double _onboardingAboutGenderSpacing = 16;
  static const double _onboardingAboutAfterGenderSpacing = 8;

  // Onboarding: activity step
  static const double _onboardingActivityAdjustButtonHeight = 48;
  static const double _onboardingActivityAdjustButtonsSpacing = 12;

  // Onboarding: labeled field
  static const double _onboardingFieldLabelFontSize = 16;
  static const double _onboardingFieldLabelBottomPadding = 8;

  // Onboarding: goal step
  static const double _onboardingGoalTitleBottomSpacing = 34;
  static const double _onboardingGoalButtonSpacing = 18;

  // Onboarding: budget step
  static const double _onboardingBudgetBlockTopSpacing = 18;
  static const double _onboardingBudgetAfterFieldSpacing = 14;
  static const double _onboardingBudgetRecommendationPadding = 16;
  static const double _onboardingBudgetRecommendationRadius = 18;
  static const double _onboardingBudgetRecommendationTitleToTextSpacing = 6;

  final double buttonHeight;
  final double inputFieldHeight;
  final double recomendationBlockHeight;
  final double profileIconSize;
  final double navigationButtonHeight;
  final double slideBarToggleSize;

  // Common
  final double commonFieldBorderRadius;
  final double commonFieldHorizontalPadding;
  final double commonFieldVerticalPadding;
  final double commonButtonBorderRadius;
  final double commonFieldPrefixIconSize;
  final double commonFieldPrefixIconGap;
  final double commonFieldPrefixIconDy;
  final double commonTopNoticeHorizontalMargin;
  final double commonTopNoticeVerticalPadding;
  final double commonTopNoticeHorizontalPadding;
  final double commonTopNoticeRadius;
  final double commonTopNoticeTopOffset;
  final double commonTopNoticeIconSize;
  final double commonTopNoticeIconGap;
  final int commonTopNoticeAnimationMs;

  // Auth / Registration pages
  final double authOuterHorizontalPadding;
  final double authOuterVerticalPadding;
  final double authCardHorizontalPadding;
  final double authCardVerticalPadding;
  final double authCardRadius;
  final double authTitleToIconSpacing;
  final double authIconToFieldsSpacing;
  final double authFieldsSpacing;
  final double authForgotSpacing;
  final double authForgotVerticalPadding;
  final double authPrimaryToDividerSpacing;
  final double authDividerHorizontalPadding;
  final double authDividerToSecondarySpacing;
  final double authSecondaryButtonsSpacing;
  final double authSocialIconSize;
  final double authSocialIconGap;

  // Onboarding (layout + navigation)
  final int onboardingPagesCount;
  final double onboardingCardRadius;
  final double onboardingIndicatorDotSize;
  final double onboardingIndicatorDotSpacing;
  final double onboardingBottomIndicatorPadding;
  final double onboardingNavActionButtonSize;
  final double onboardingNavActionIconSize;
  final double onboardingNavBorderWidth;
  final double onboardingNavButtonHorizontalPadding;
  final double onboardingNavButtonBottomPadding;
  final int onboardingPageTransitionMs;

  // Onboarding steps (shared)
  final double onboardingStepHorizontalPadding;
  final double onboardingContentMaxWidth;
  final double onboardingTitleFontSize;

  // Onboarding: name step
  final double onboardingNameTitleBottomSpacing;
  final double onboardingNameLabelBottomSpacing;
  final double onboardingNameFieldsSpacing;

  // Onboarding: about step
  final double onboardingAboutTitleBottomSpacing;
  final double onboardingAboutFieldSpacing;
  final double onboardingAboutGenderSpacing;
  final double onboardingAboutAfterGenderSpacing;

  final double onboardingActivityAdjustButtonHeight;
  final double onboardingActivityAdjustButtonsSpacing;

  // Onboarding: labeled field
  final double onboardingFieldLabelFontSize;
  final double onboardingFieldLabelBottomPadding;

  // Onboarding: goal step
  final double onboardingGoalTitleBottomSpacing;
  final double onboardingGoalButtonSpacing;

  // Onboarding: budget step
  final double onboardingBudgetBlockTopSpacing;
  final double onboardingBudgetAfterFieldSpacing;
  final double onboardingBudgetRecommendationPadding;
  final double onboardingBudgetRecommendationRadius;
  final double onboardingBudgetRecommendationTitleToTextSpacing;

  const PlatformSizes({
    required this.buttonHeight,
    required this.inputFieldHeight,
    required this.recomendationBlockHeight,
    required this.authForgotVerticalPadding,
    required this.profileIconSize,
    required this.navigationButtonHeight,
    required this.slideBarToggleSize,
    required this.commonFieldBorderRadius,
    required this.commonFieldHorizontalPadding,
    required this.commonFieldVerticalPadding,
    required this.commonButtonBorderRadius,
    required this.commonFieldPrefixIconSize,
    required this.commonFieldPrefixIconGap,
    required this.commonFieldPrefixIconDy,
    required this.commonTopNoticeHorizontalMargin,
    required this.commonTopNoticeVerticalPadding,
    required this.commonTopNoticeHorizontalPadding,
    required this.commonTopNoticeRadius,
    required this.commonTopNoticeTopOffset,
    required this.commonTopNoticeIconSize,
    required this.commonTopNoticeIconGap,
    required this.commonTopNoticeAnimationMs,
    required this.authOuterHorizontalPadding,
    required this.authOuterVerticalPadding,
    required this.authCardHorizontalPadding,
    required this.authCardVerticalPadding,
    required this.authCardRadius,
    required this.authTitleToIconSpacing,
    required this.authIconToFieldsSpacing,
    required this.authFieldsSpacing,
    required this.authForgotSpacing,
    required this.authPrimaryToDividerSpacing,
    required this.authDividerHorizontalPadding,
    required this.authDividerToSecondarySpacing,
    required this.authSecondaryButtonsSpacing,
    required this.authSocialIconSize,
    required this.authSocialIconGap,
    required this.onboardingPagesCount,
    required this.onboardingCardRadius,
    required this.onboardingIndicatorDotSize,
    required this.onboardingIndicatorDotSpacing,
    required this.onboardingBottomIndicatorPadding,
    required this.onboardingNavActionButtonSize,
    required this.onboardingNavActionIconSize,
    required this.onboardingNavBorderWidth,
    required this.onboardingNavButtonHorizontalPadding,
    required this.onboardingNavButtonBottomPadding,
    required this.onboardingPageTransitionMs,
    required this.onboardingStepHorizontalPadding,
    required this.onboardingContentMaxWidth,
    required this.onboardingTitleFontSize,
    required this.onboardingNameTitleBottomSpacing,
    required this.onboardingNameLabelBottomSpacing,
    required this.onboardingNameFieldsSpacing,
    required this.onboardingAboutTitleBottomSpacing,
    required this.onboardingAboutFieldSpacing,
    required this.onboardingAboutGenderSpacing,
    required this.onboardingAboutAfterGenderSpacing,
    required this.onboardingActivityAdjustButtonHeight,
    required this.onboardingActivityAdjustButtonsSpacing,
    required this.onboardingFieldLabelFontSize,
    required this.onboardingFieldLabelBottomPadding,
    required this.onboardingGoalTitleBottomSpacing,
    required this.onboardingGoalButtonSpacing,
    required this.onboardingBudgetBlockTopSpacing,
    required this.onboardingBudgetAfterFieldSpacing,
    required this.onboardingBudgetRecommendationPadding,
    required this.onboardingBudgetRecommendationRadius,
    required this.onboardingBudgetRecommendationTitleToTextSpacing,
  });

  factory PlatformSizes.standard() {
    return const PlatformSizes(
      buttonHeight: _buttonHeight,
      authForgotVerticalPadding: _authForgotVerticalPadding,
      inputFieldHeight: _inputFieldHeight,
      recomendationBlockHeight: _recomendationBlockHeight,
      profileIconSize: _profileIconSize,
      navigationButtonHeight: _navigationButtonHeight,
      slideBarToggleSize: _slideBarToggleSize,
      commonFieldBorderRadius: _commonFieldBorderRadius,
      commonFieldHorizontalPadding: _commonFieldHorizontalPadding,
      commonFieldVerticalPadding: _commonFieldVerticalPadding,
      commonButtonBorderRadius: _commonButtonBorderRadius,
      commonFieldPrefixIconSize: _commonFieldPrefixIconSize,
      commonFieldPrefixIconGap: _commonFieldPrefixIconGap,
      commonFieldPrefixIconDy: _commonFieldPrefixIconDy,
      commonTopNoticeHorizontalMargin: _commonTopNoticeHorizontalMargin,
      commonTopNoticeVerticalPadding: _commonTopNoticeVerticalPadding,
      commonTopNoticeHorizontalPadding: _commonTopNoticeHorizontalPadding,
      commonTopNoticeRadius: _commonTopNoticeRadius,
      commonTopNoticeTopOffset: _commonTopNoticeTopOffset,
      commonTopNoticeIconSize: _commonTopNoticeIconSize,
      commonTopNoticeIconGap: _commonTopNoticeIconGap,
      commonTopNoticeAnimationMs: _commonTopNoticeAnimationMs,
      authOuterHorizontalPadding: _authOuterHorizontalPadding,
      authOuterVerticalPadding: _authOuterVerticalPadding,
      authCardHorizontalPadding: _authCardHorizontalPadding,
      authCardVerticalPadding: _authCardVerticalPadding,
      authCardRadius: _authCardRadius,
      authTitleToIconSpacing: _authTitleToIconSpacing,
      authIconToFieldsSpacing: _authIconToFieldsSpacing,
      authFieldsSpacing: _authFieldsSpacing,
      authForgotSpacing: _authForgotSpacing,
      authPrimaryToDividerSpacing: _authPrimaryToDividerSpacing,
      authDividerHorizontalPadding: _authDividerHorizontalPadding,
      authDividerToSecondarySpacing: _authDividerToSecondarySpacing,
      authSecondaryButtonsSpacing: _authSecondaryButtonsSpacing,
      authSocialIconSize: _authSocialIconSize,
      authSocialIconGap: _authSocialIconGap,
      onboardingPagesCount: _onboardingPagesCount,
      onboardingCardRadius: _onboardingCardRadius,
      onboardingIndicatorDotSize: _onboardingIndicatorDotSize,
      onboardingIndicatorDotSpacing: _onboardingIndicatorDotSpacing,
      onboardingBottomIndicatorPadding: _onboardingBottomIndicatorPadding,
      onboardingNavActionButtonSize: _onboardingNavActionButtonSize,
      onboardingNavActionIconSize: _onboardingNavActionIconSize,
      onboardingNavBorderWidth: _onboardingNavBorderWidth,
      onboardingNavButtonHorizontalPadding: _onboardingNavButtonHorizontalPadding,
      onboardingNavButtonBottomPadding: _onboardingNavButtonBottomPadding,
      onboardingPageTransitionMs: _onboardingPageTransitionMs,
      onboardingStepHorizontalPadding: _onboardingStepHorizontalPadding,
      onboardingContentMaxWidth: _onboardingContentMaxWidth,
      onboardingTitleFontSize: _onboardingTitleFontSize,
      onboardingNameTitleBottomSpacing: _onboardingNameTitleBottomSpacing,
      onboardingNameLabelBottomSpacing: _onboardingNameLabelBottomSpacing,
      onboardingNameFieldsSpacing: _onboardingNameFieldsSpacing,
      onboardingAboutTitleBottomSpacing: _onboardingAboutTitleBottomSpacing,
      onboardingAboutFieldSpacing: _onboardingAboutFieldSpacing,
      onboardingAboutGenderSpacing: _onboardingAboutGenderSpacing,
      onboardingAboutAfterGenderSpacing: _onboardingAboutAfterGenderSpacing,
      onboardingActivityAdjustButtonHeight: _onboardingActivityAdjustButtonHeight,
      onboardingActivityAdjustButtonsSpacing:
          _onboardingActivityAdjustButtonsSpacing,
      onboardingFieldLabelFontSize: _onboardingFieldLabelFontSize,
      onboardingFieldLabelBottomPadding: _onboardingFieldLabelBottomPadding,
      onboardingGoalTitleBottomSpacing: _onboardingGoalTitleBottomSpacing,
      onboardingGoalButtonSpacing: _onboardingGoalButtonSpacing,
      onboardingBudgetBlockTopSpacing: _onboardingBudgetBlockTopSpacing,
      onboardingBudgetAfterFieldSpacing: _onboardingBudgetAfterFieldSpacing,
      onboardingBudgetRecommendationPadding: _onboardingBudgetRecommendationPadding,
      onboardingBudgetRecommendationRadius: _onboardingBudgetRecommendationRadius,
      onboardingBudgetRecommendationTitleToTextSpacing:
          _onboardingBudgetRecommendationTitleToTextSpacing,
    );
  }
}

PlatformSizes platformSizes(BuildContext context) {
  return PlatformSizes.standard();
}

