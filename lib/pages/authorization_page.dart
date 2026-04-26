import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitassistent/common/fit_buttons.dart';
import 'package:fitassistent/common/fit_text_field.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/pages/registration_page.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
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
                        'Авторизация',
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
                      SizedBox(height: sizes.authForgotSpacing),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: colors.authLinkTextColor,
                        ),
                        child: Text(
                          'Забыл пароль',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ),
                      FitPrimaryButton(
                        text: 'Авторизация',
                        onPressed: () {},
                      ),
                      SizedBox(height: sizes.authPrimaryToDividerSpacing),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: colors.authDividerColor),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: sizes.authDividerHorizontalPadding,
                            ),
                            child: Text(
                              'Нет аккаунта?',
                              style: TextStyle(color: colors.textSecondary),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: colors.authDividerColor),
                          ),
                        ],
                      ),
                      SizedBox(height: sizes.authDividerToSecondarySpacing),
                      FitSecondaryButton(
                        text: 'Создать аккаунт',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegistrationPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: sizes.authSecondaryButtonsSpacing),
                      FitSecondaryButton(text: 'Через Telegram', onPressed: () {}),
                      SizedBox(height: sizes.authSecondaryButtonsSpacing),
                      FitSecondaryButton(text: 'Через Google', onPressed: () {}),
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


