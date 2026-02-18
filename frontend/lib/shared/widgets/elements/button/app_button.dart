import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? prefixIcon;
  final TextAlign? textAlign;

  const AppButton(
    this.text, {
    super.key,
    this.icon,
    required this.variant,
    this.onPressed,
    this.prefixIcon,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.link) {
      return SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          style: AppButtonStyle.link(context),
          child: AppText(text, variant: AppTextVariant.link),
        ),
      );
    } else if (variant == AppButtonVariant.icon) {
      return IconButton(
        icon: Icon(icon, size: AppSize.mediumPlus, color: context.onSurface),
        style: AppButtonStyle.icon(context, variant),
        onPressed: onPressed,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtonStyle.elevated(context, variant),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSize.normal,
        children: [
          if (prefixIcon != null) prefixIcon!,
          AppText(text, variant: AppTextVariant.button, textAlign: textAlign),
        ],
      ),
    );
  }
}
