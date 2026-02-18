import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, tertiary, link, icon }

class AppButtonStyle {
  AppButtonStyle._();

  static ButtonStyle elevated(BuildContext context, AppButtonVariant variant) {
    final bg = _background(context, variant);
    final fg = _foreground(context, variant);
    final isDark = context.brightness == Brightness.dark;

    return ButtonStyle(
      padding: WidgetStatePropertyAll(AppSpacing.button),
      backgroundColor: WidgetStatePropertyAll(bg),
      foregroundColor: WidgetStatePropertyAll(fg),
      elevation: WidgetStatePropertyAll(AppSize.small),
      shadowColor: WidgetStatePropertyAll(
        isDark
            ? Colors.white.withValues(alpha: 0.24)
            : Colors.black.withValues(alpha: 0.24),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.xSmall),
          side: _border(context, variant),
        ),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return context.pressedOverlay;
        }
        if (states.contains(WidgetState.hovered)) {
          return context.hoverOverlay;
        }
        return null;
      }),
    );
  }

  static ButtonStyle link(BuildContext context) {
    final color = context.primary;
    final hover = context.primary.withValues(alpha: 0.6);
    return ButtonStyle(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      minimumSize: WidgetStateProperty.all(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed)) {
          return hover;
        }
        return color;
      }),
      alignment: Alignment.centerLeft,
      textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        final active =
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed);

        return AppTextStyle.of(
          context,
          AppTextVariant.link,
          color: color,
          underline: active ? true : false,
        );
      }),
    );
  }

  static ButtonStyle icon(BuildContext context, AppButtonVariant variant) {
    final bg = _background(context, variant);
    final fg = _foreground(context, variant);
    final isDark = context.brightness == Brightness.dark;
    final size = Size(AppSize.mediumPlus * 2, AppSize.fieldHeight);

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(size),
      maximumSize: WidgetStatePropertyAll(size),
      padding: WidgetStatePropertyAll(AppSpacing.none),
      backgroundColor: WidgetStatePropertyAll(bg),
      foregroundColor: WidgetStatePropertyAll(fg),
      elevation: WidgetStatePropertyAll(AppSize.zero),
      shadowColor: WidgetStatePropertyAll(
        isDark
            ? Colors.white.withValues(alpha: 0.24)
            : Colors.black.withValues(alpha: 0.24),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(AppSize.xSmall),
          ),
          side: _border(context, variant),
        ),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return context.pressedOverlay;
        }
        if (states.contains(WidgetState.hovered)) {
          return context.hoverOverlay;
        }
        return null;
      }),
    );
  }

  /* =======================
   * PRIVATE HELPERS
   * ======================= */

  static Color _background(BuildContext context, AppButtonVariant variant) {
    return switch (variant) {
      AppButtonVariant.primary => context.primaryContainer,
      AppButtonVariant.secondary => context.secondaryContainer,
      AppButtonVariant.tertiary => context.tertiaryContainer,
      AppButtonVariant.icon => context.surface,
      _ => context.primary,
    };
  }

  static Color _foreground(BuildContext context, AppButtonVariant variant) {
    return switch (variant) {
      AppButtonVariant.primary => context.onPrimaryContainer,
      AppButtonVariant.secondary => context.onSecondaryContainer,
      AppButtonVariant.tertiary => context.onTertiaryContainer,
      _ => context.onPrimary,
    };
  }

  static BorderSide _border(BuildContext context, AppButtonVariant variant) {
    return switch (variant) {
      AppButtonVariant.tertiary => BorderSide(color: context.outline),
      AppButtonVariant.icon => BorderSide(color: context.outline),
      _ => BorderSide.none,
    };
  }
}
