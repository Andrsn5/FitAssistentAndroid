import 'package:flutter/material.dart';
import 'package:fitassistent/theme/app_theme.dart';

class FitPrimaryButton extends StatelessWidget {
  const FitPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.onDisabledPressed,
    this.height,
    this.borderRadius,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final VoidCallback? onDisabledPressed;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final styles = context.platformTextStyles;
    final sizes = context.platformSizes;

    final radius = borderRadius ?? sizes.commonButtonBorderRadius;
    final callback = enabled ? onPressed : (onDisabledPressed ?? onPressed);

    return SizedBox(
      height: height ?? sizes.buttonHeight,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.authPrimaryButtonBackground,
          foregroundColor: colors.authPrimaryButtonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0,
        ),
        child: Text(text, style: styles.authPrimaryButtonTextStyle),
      ),
    );
  }
}

class FitSecondaryButton extends StatelessWidget {
  const FitSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leading,
    this.backgroundColor,
    this.height,
    this.borderRadius,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Color? backgroundColor;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    final radius = borderRadius ?? sizes.commonButtonBorderRadius;
    final bg = backgroundColor ?? colors.authSecondaryButtonBackground;

    return SizedBox(
      height: height ?? sizes.navigationButtonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: colors.authSecondaryButtonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0,
        ),
        child: leading == null
            ? Text(text)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: sizes.authSocialIconSize,
                    height: sizes.authSocialIconSize,
                    child: Center(child: leading),
                  ),
                  SizedBox(width: sizes.authSocialIconGap),
                  Text(text),
                ],
              ),
      ),
    );
  }
}

class FitSecondaryEmphasisButton extends StatelessWidget {
  const FitSecondaryEmphasisButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.borderRadius,
  });

  final String text;
  final VoidCallback? onPressed;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final styles = context.platformTextStyles;
    final sizes = context.platformSizes;

    final radius = borderRadius ?? sizes.commonButtonBorderRadius;

    return SizedBox(
      height: height ?? sizes.navigationButtonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.authSecondaryButtonBackground,
          foregroundColor: colors.authSecondaryButtonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0,
        ),
        child: Text(text, style: styles.authSecondaryEmphasisButtonTextStyle),
      ),
    );
  }
}

class FitSelectablePillButton extends StatelessWidget {
  const FitSelectablePillButton({
    super.key,
    required this.selected,
    required this.text,
    required this.onPressed,
    this.height,
    this.borderRadius,
  });

  final bool selected;
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    final background = selected
        ? colors.authPrimaryButtonBackground
        : colors.authSecondaryButtonBackground;
    final foreground =
        selected ? colors.authPrimaryButtonText : colors.authSecondaryButtonText;
    final radius = borderRadius ?? sizes.commonButtonBorderRadius;

    return SizedBox(
      height: height ?? sizes.navigationButtonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0,
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

