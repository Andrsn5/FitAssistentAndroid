import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/theme/platform_colors.dart';
import 'package:fitassistent/pages/onboarding_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = context.platformSizes;
    final colors = context.platformColors;
    final textStyles = context.platformTextStyles;

    return Scaffold(
      backgroundColor: colors.authScreenBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SizedBox.expand(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: BoxDecoration(
                color: colors.authCardBackground,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Регистрация',
                        textAlign: TextAlign.center,
                        style: context.platformTextStyles.headerTextStyle,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: sizes.profileIconSize,
                        child: Center(
                          child: SvgPicture.asset(
                            'lib/image/icons/profile.svg',
                            width: sizes.profileIconSize,
                            height: sizes.profileIconSize,
                            colorFilter: ColorFilter.mode(
                              colors.textPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _RegisterTextField(
                        controller: _emailController,
                        height: sizes.inputFieldHeight,
                        hintText: 'Введите почту',
                        colors: colors,
                      ),
                      const SizedBox(height: 15),
                      _RegisterTextField(
                        controller: _passwordController,
                        height: sizes.inputFieldHeight,
                        hintText: 'Введите пароль',
                        colors: colors,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: sizes.buttonHeight,
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OnboardingPage(),
                          ),
                        );
                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.authPrimaryButtonBackground,
                            foregroundColor: colors.authPrimaryButtonText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Регистрация',
                            style: textStyles.authPrimaryButtonTextStyle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: sizes.navigationButtonHeight,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.authSecondaryButtonBackground,
                            foregroundColor: colors.authSecondaryButtonText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Назад'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterTextField extends StatelessWidget {
  const _RegisterTextField({
    required this.controller,
    required this.height,
    required this.hintText,
    required this.colors,
    this.obscureText = false,
  });

  static const double _borderRadius = 16;
  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 18;

  final TextEditingController controller;
  final double height;
  final String hintText;
  final PlatformColors colors;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: colors.authHintTextColor),
          isDense: true,
          filled: true,
          fillColor: colors.authFieldBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: colors.authFieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: colors.authFieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: colors.primaryColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
        ),
      ),
    );
  }
}
