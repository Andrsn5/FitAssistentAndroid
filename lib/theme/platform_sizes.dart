import 'package:flutter/material.dart';

class PlatformSizes {
  static const double _buttonHeight = 57;
  static const double _inputFieldHeight = 57;
  static const double _recomendationBlockHeight = 84;
  static const double _profileIconSize = 87;
  static const double _navigationButtonHeight = 54;
  static const double _slideBarToggleSize = 15;

  final double buttonHeight;
  final double inputFieldHeight;
  final double recomendationBlockHeight;
  final double profileIconSize;
  final double navigationButtonHeight;
  final double slideBarToggleSize;

  const PlatformSizes({
    required this.buttonHeight,
    required this.inputFieldHeight,
    required this.recomendationBlockHeight,
    required this.profileIconSize,
    required this.navigationButtonHeight,
    required this.slideBarToggleSize,
  });

  factory PlatformSizes.standard() {
    return const PlatformSizes(
      buttonHeight: _buttonHeight,
      inputFieldHeight: _inputFieldHeight,
      recomendationBlockHeight: _recomendationBlockHeight,
      profileIconSize: _profileIconSize,
      navigationButtonHeight: _navigationButtonHeight,
      slideBarToggleSize: _slideBarToggleSize,
    );
  }
}

PlatformSizes platformSizes(BuildContext context) {
  return PlatformSizes.standard();
}

