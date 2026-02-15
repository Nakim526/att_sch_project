import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
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
    String true_ = 'Yes',
    String false_ = 'Cancel',
    VoidCallback? onConfirm,
    bool exit = false,
  }) async {
    return await showDialog(
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
              false_,
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            AppButton(
              true_,
              variant: AppButtonVariant.primary,
              onPressed: () {
                exit
                    ? SystemNavigator.pop()
                    : Navigator.of(dialogContext).pop(true);
                onConfirm?.call();
              },
            ),
          ],
        );
      },
    );
  }
}
