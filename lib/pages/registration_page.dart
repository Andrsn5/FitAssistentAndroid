import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitassistent/common/fit_buttons.dart';
import 'package:fitassistent/common/fit_text_field.dart';
import 'package:fitassistent/theme/app_theme.dart';
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
              padding: EdgeInsets.symmetric(
                horizontal: sizes.authCardHorizontalPadding,
                vertical: sizes.authCardVerticalPadding,
              ),
              decoration: BoxDecoration(
                color: colors.authCardBackground,
                borderRadius: BorderRadius.circular(sizes.authCardRadius),
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
                      SizedBox(height: sizes.authTitleToIconSpacing),
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
                      SizedBox(height: sizes.authIconToFieldsSpacing),
                      FitTextField(
                        controller: _emailController,
                        hintText: 'Введите почту',
                        prefix: Icon(
                          Icons.email_outlined,
                          size: sizes.commonFieldPrefixIconSize,
                          color: colors.authHintTextColor,
                        ),
                      ),
                      SizedBox(height: sizes.authFieldsSpacing),
                      FitTextField(
                        controller: _passwordController,
                        hintText: 'Введите пароль',
                        obscureText: true,
                        prefix: Icon(
                          Icons.vpn_key_outlined,
                          size: sizes.commonFieldPrefixIconSize,
                          color: colors.authHintTextColor,
                        ),
                      ),
                      SizedBox(height: sizes.authDividerToSecondarySpacing),
                      FitPrimaryButton(
                        text: 'Регистрация',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OnboardingPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: sizes.authSecondaryButtonsSpacing),
                      FitSecondaryButton(
                        text: 'Назад',
                        onPressed: () => Navigator.of(context).pop(),
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

