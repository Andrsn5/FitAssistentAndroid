import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitassistent/common/fit_buttons.dart';
import 'package:fitassistent/common/fit_text_field.dart';
import 'package:fitassistent/common/fit_top_notice.dart';
import 'package:fitassistent/common/native_auth_api.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/pages/registration_page.dart';
import 'package:fitassistent/validators/input_constraints.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  static const String _fillFieldsMessage = 'Заполните почту и пароль';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final token = await NativeAuthApi.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (token == null || token.isEmpty) {
        showFitTopNotice(
          context,
          text: 'Авторизация не удалась',
          icon: Icons.error_outline,
        );
        return;
      }

      showFitTopNotice(
        context,
        text: 'Вы успешно авторизовались',
        icon: Icons.check_circle_outline,
      );
    } on Exception catch (e) {
      if (!mounted) return;
      showFitTopNotice(
        context,
        text: 'Ошибка при авторизации: $e',
        icon: Icons.error_outline,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                      SizedBox(height: sizes.authForgotSpacing),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: sizes.authForgotVerticalPadding,
                        ),
                        child: Row(
                          children: [
                            Spacer(),
                            Text(
                              'Забыл пароль',
                              style: TextStyle(color: colors.textSecondary),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {},
                      //   // style: TextButton.styleFrom(
                      //   //   foregroundColor: colors.authLinkTextColor,
                      //   // ),
                      //   child: Text(
                      //     'Забыл пароль',
                      //     // style: TextStyle(color: colors.textSecondary),
                      //   ),
                      // ),
                      AnimatedBuilder(
                        animation: Listenable.merge(
                          [_emailController, _passwordController],
                        ),
                        builder: (context, _) {
                          final canSubmit =
                              _emailController.text.trim().isNotEmpty &&
                              _passwordController.text.trim().isNotEmpty;

                          return FitPrimaryButton(
                            text: _loading ? 'Загрузка...' : 'Авторизация',
                            enabled: !_loading && canSubmit,
                            onDisabledPressed: () {
                              if (_loading) return;
                              if (_emailController.text.trim().isNotEmpty &&
                                  _passwordController.text
                                      .trim()
                                      .isNotEmpty) {
                                _login();
                                return;
                              }
                              showFitTopNotice(
                                context,
                                text: _fillFieldsMessage,
                              );
                            },
                            onPressed: _login,
                          );
                        },
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
                      FitSecondaryButton(
                        text: 'Через Telegram',
                        leading: SvgPicture.asset(
                          'lib/image/icons/telegram.svg',
                          width: sizes.authSocialIconSize,
                          height: sizes.authSocialIconSize,
                          fit: BoxFit.contain,
                        ),
                        backgroundColor: colors.authSocialButtonBackground,
                        onPressed: () {
                          showFitTopNotice(
                            context,
                            text: 'Функция временно недоступна',
                            icon: Icons.info_outline,
                          );
                        },
                      ),
                      SizedBox(height: sizes.authSecondaryButtonsSpacing),
                      FitSecondaryButton(
                        text: 'Через Google',
                        leading: SvgPicture.asset(
                          'lib/image/icons/google.svg',
                          width: sizes.authSocialIconSize,
                          height: sizes.authSocialIconSize,
                          fit: BoxFit.contain,
                        ),
                        backgroundColor: colors.authSocialButtonBackground,
                        onPressed: () {
                          showFitTopNotice(
                            context,
                            text: 'Функция временно недоступна',
                            icon: Icons.info_outline,
                          );
                        },
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
