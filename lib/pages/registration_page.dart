import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitassistent/common/fit_buttons.dart';
import 'package:fitassistent/common/fit_text_field.dart';
import 'package:fitassistent/common/fit_top_notice.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/pages/onboarding_page.dart';
import 'package:fitassistent/validators/input_constraints.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const String _fillFieldsMessage = 'Заполните почту и пароль';

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
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        maxLength: InputConstraints.emailMaxLength,
                        inputFormatters: [
                          InputConstraints.emailFormatter,
                          InputConstraints.denyWhitespaceFormatter,
                        ],
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
                        textInputAction: TextInputAction.done,
                        maxLength: InputConstraints.passwordMaxLength,
                        inputFormatters: [
                          InputConstraints.passwordFormatter,
                          InputConstraints.denyWhitespaceFormatter,
                        ],
                        prefix: Icon(
                          Icons.vpn_key_outlined,
                          size: sizes.commonFieldPrefixIconSize,
                          color: colors.authHintTextColor,
                        ),
                      ),
                      SizedBox(height: sizes.authDividerToSecondarySpacing),
                      AnimatedBuilder(
                        animation: Listenable.merge(
                          [_emailController, _passwordController],
                        ),
                        builder: (context, _) {
                          final canSubmitInner =
                              _emailController.text.trim().isNotEmpty &&
                              _passwordController.text.trim().isNotEmpty;

                          return FitPrimaryButton(
                            text: 'Регистрация',
                            enabled: canSubmitInner,
                            onDisabledPressed: () {
                              showFitTopNotice(
                                context,
                                text: _fillFieldsMessage,
                              );
                            },
                            onPressed: () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => OnboardingPage(
                                    email: email,
                                    password: password,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: sizes.authSecondaryButtonsSpacing),
                      FitSecondaryEmphasisButton(
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

