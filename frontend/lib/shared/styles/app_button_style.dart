import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/shared/widgets/elements/app_button.dart';
import 'package:flutter/material.dart';
import 'package:att_school/core/constant/theme/theme_extension.dart';
import 'package:att_school/core/constant/size/app_size.dart';

class AppButtonStyle {
  AppButtonStyle._();

  static ButtonStyle elevated(BuildContext context, AppButtonVariant variant) {
    final background = switch (variant) {
      AppButtonVariant.primary => context.primaryContainer,
      AppButtonVariant.secondary => context.secondaryContainer,
      AppButtonVariant.tertiary => context.tertiaryContainer,
      _ => context.primary,
    };

    return ButtonStyle(
      padding: WidgetStatePropertyAll(AppSpacing.button),
      backgroundColor: WidgetStatePropertyAll(background),
      elevation: WidgetStatePropertyAll(AppSize.xSmall),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          side: BorderSide(color: context.outline),
          borderRadius: BorderRadius.circular(AppSize.xSmall),
        ),
      ),
    );
  }

  static ButtonStyle link(BuildContext context) {
    return ButtonStyle(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      minimumSize: WidgetStateProperty.all(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed)) {
          return context.tertiary;
        }
        return context.secondary;
      }),
    );
  }
}
