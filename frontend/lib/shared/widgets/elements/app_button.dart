import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant {
  primary,
  secondary,
  tertiary,
  link,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.text,
    required this.variant,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.link) {
      return TextButton(
        onPressed: onPressed,
        style: AppButtonStyle.link(context),
        child: Text(text),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtonStyle.elevated(context, variant),
      child: Text(text),
    );
  }
}
