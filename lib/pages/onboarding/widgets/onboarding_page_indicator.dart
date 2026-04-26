import 'package:flutter/material.dart';
import 'package:fitassistent/theme/app_theme.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final sizes = context.platformSizes;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizes.onboardingIndicatorDotSpacing / 2,
          ),
          child: Container(
            width: sizes.onboardingIndicatorDotSize,
            height: sizes.onboardingIndicatorDotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}

