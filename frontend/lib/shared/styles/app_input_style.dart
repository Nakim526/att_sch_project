import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class AppInputStyle {
  AppInputStyle._();

  static InputDecoration text(
    BuildContext context, {
    String? hintText,
    BorderRadius? borderRadius,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isError = false,
    int minLines = 1,
    int maxLines = 1,
  }) {
    final radius = borderRadius ?? AppBorderRadius.xSmall;

    return InputDecoration(
      filled: true,
      fillColor: context.surface,
      isDense: true,
      hintText: hintText,
      constraints: _constraints(minLines),
      border: _border(radius),
      enabledBorder: _border(
        radius,
        color: isError ? context.error : context.outline,
      ),
      focusedBorder: _border(
        radius,
        color: isError ? context.error : context.primary,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconConstraints: _iconConstraints,
      suffixIconConstraints: _iconConstraints,
    );
  }

  static InputDecoration dropdown(
    BuildContext context, {
    String? hintText,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    bool isError = false,
    BoxConstraints? constraints,
  }) {
    final radius = borderRadius ?? AppBorderRadius.xSmall;

    return InputDecoration(
      filled: true,
      fillColor: context.surface,
      isDense: true,
      hintText: hintText,
      contentPadding: padding ?? AppSpacing.normal,
      constraints: constraints ?? _singleLineConstraints,
      border: _border(radius),
      enabledBorder: _border(
        radius,
        color: isError ? context.error : context.outline,
      ),
      focusedBorder: _border(
        radius,
        color: isError ? context.error : context.primary,
      ),
    );
  }

  /* =======================
   * PRIVATE HELPERS
   * ======================= */

  static OutlineInputBorder _border(BorderRadius radius, {Color? color}) {
    return OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color ?? Colors.transparent),
    );
  }

  static BoxConstraints _constraints(int minLines) {
    if (minLines == 1) return _singleLineConstraints;
    return const BoxConstraints(minHeight: AppSize.fieldHeight);
  }

  static const BoxConstraints _singleLineConstraints = BoxConstraints(
    minHeight: AppSize.fieldHeight,
    maxHeight: double.infinity,
  );

  static const BoxConstraints _iconConstraints = BoxConstraints(
    maxHeight: AppSize.fieldHeight - 2,
    maxWidth: 70,
  );
}
