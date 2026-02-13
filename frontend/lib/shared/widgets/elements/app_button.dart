import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, tertiary, link }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? prefixIcon;

  const AppButton(
    this.text, {
    super.key,
    required this.variant,
    this.onPressed,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.link) {
      return TextButton(
        onPressed: onPressed,
        style: AppButtonStyle.link(context),
        child: AppText(text, variant: AppTextVariant.link),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtonStyle.elevated(context, variant),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSize.medium,
        children: [
          if (prefixIcon != null) prefixIcon!,
          AppText(text, variant: AppTextVariant.button),
        ],
      ),
    );
  }
}
