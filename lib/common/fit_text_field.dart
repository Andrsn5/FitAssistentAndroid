import 'package:flutter/material.dart';
import 'package:fitassistent/theme/app_theme.dart';

class FitTextField extends StatelessWidget {
  const FitTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.height,
    this.prefix,
  });


  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final double? height;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    return SizedBox(
      height: height ?? sizes.inputFieldHeight,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefix == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(
                    left: sizes.commonFieldHorizontalPadding,
                    right: sizes.commonFieldPrefixIconGap,
                  ),
                  child: SizedBox(
                    width: sizes.commonFieldPrefixIconSize,
                    height: sizes.commonFieldPrefixIconSize,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, sizes.commonFieldPrefixIconDy),
                        child: prefix,
                      ),
                    ),
                  ),
                ),
          prefixIconConstraints: BoxConstraints(
            minWidth: sizes.commonFieldPrefixIconSize +
                sizes.commonFieldHorizontalPadding +
                sizes.commonFieldPrefixIconGap,
            minHeight: sizes.commonFieldPrefixIconSize,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: colors.authHintTextColor),
          isDense: true,
          filled: true,
          fillColor: colors.authFieldBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizes.commonFieldBorderRadius),
            borderSide: BorderSide(color: colors.authFieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizes.commonFieldBorderRadius),
            borderSide: BorderSide(color: colors.authFieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizes.commonFieldBorderRadius),
            borderSide: BorderSide(color: colors.primaryColor, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: sizes.commonFieldHorizontalPadding,
            vertical: sizes.commonFieldVerticalPadding,
          ),
        ),
      ),
    );
  }
}

