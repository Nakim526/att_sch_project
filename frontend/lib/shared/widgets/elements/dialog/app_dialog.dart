import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/core/constant/theme/theme_extension.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_button.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDialog {
  AppDialog._();

  static Future<void> show(
    BuildContext context, {
    required String title,
    String? message,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.surface,
          shape: OutlineInputBorder(
            borderRadius: AppBorderRadius.small,
            borderSide: BorderSide(color: context.outline),
          ),
          elevation: AppSize.small,
          title: AppText(title, variant: AppTextVariant.h2),
          content: AppText(message ?? '', variant: AppTextVariant.body),
          actions: [
            AppButton(
              "OK",
              variant: AppButtonVariant.primary,
              onPressed: () => Navigator.pop(dialogContext),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    String ifTrue = 'Yes',
    String ifFalse = 'Cancel',
    bool exit = false,
  }) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.surface,
          shape: OutlineInputBorder(
            borderRadius: AppBorderRadius.small,
            borderSide: BorderSide(color: context.outline),
          ),
          elevation: AppSize.small,
          title: AppText(title, variant: AppTextVariant.h2),
          content: AppText(message ?? '', variant: AppTextVariant.body),
          actions: [
            AppButton(
              ifFalse,
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            AppButton(
              ifTrue,
              variant: AppButtonVariant.primary,
              onPressed: () {
                exit
                    ? SystemNavigator.pop()
                    : Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
