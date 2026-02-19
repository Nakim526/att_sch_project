import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

enum AppTextVariant {
  body,
  title,
  subtitle,
  h1,
  h2,
  h3,
  h4,
  input,
  button,
  caption,
  overline,
  hint,
  link,
  error,
}

class _TextStyleConfig {
  final double size;
  final FontWeight weight;

  const _TextStyleConfig(this.size, this.weight);
}

const Map<AppTextVariant, _TextStyleConfig> _config = {
  AppTextVariant.body: _TextStyleConfig(AppSize.base, FontWeight.normal),
  AppTextVariant.title: _TextStyleConfig(18, FontWeight.bold),
  AppTextVariant.subtitle: _TextStyleConfig(16, FontWeight.w600),
  AppTextVariant.h1: _TextStyleConfig(36, FontWeight.w900),
  AppTextVariant.h2: _TextStyleConfig(28, FontWeight.w900),
  AppTextVariant.h3: _TextStyleConfig(24, FontWeight.w800),
  AppTextVariant.h4: _TextStyleConfig(20, FontWeight.w700),
  AppTextVariant.input: _TextStyleConfig(AppSize.normal, FontWeight.normal),
  AppTextVariant.button: _TextStyleConfig(AppSize.medium, FontWeight.bold),
  AppTextVariant.caption: _TextStyleConfig(AppSize.base, FontWeight.normal),
  AppTextVariant.overline: _TextStyleConfig(AppSize.small, FontWeight.normal),
  AppTextVariant.hint: _TextStyleConfig(AppSize.base, FontWeight.normal),
  AppTextVariant.link: _TextStyleConfig(AppSize.base, FontWeight.w500),
  AppTextVariant.error: _TextStyleConfig(AppSize.normal, FontWeight.normal),
};

class AppTextStyle {
  AppTextStyle._();

  static TextStyle of(
    BuildContext context,
    AppTextVariant variant, {
    Color? color,
    bool underline = false,
  }) {
    final config = _config[variant]!;

    return TextStyle(
      fontSize: config.size,
      fontWeight: config.weight,
      color: color ?? _defaultColor(context, variant),
      decoration: underline ? TextDecoration.underline : null,
      decorationColor: color ?? _defaultColor(context, variant),
    );
  }

  static Color _defaultColor(BuildContext context, AppTextVariant variant) {
    switch (variant) {
      case AppTextVariant.caption:
      case AppTextVariant.overline:
        return context.onSurface.withValues(alpha: 0.6);

      case AppTextVariant.error:
        return context.error;

      case AppTextVariant.link:
        return context.primary;

      case AppTextVariant.hint:
        return context.onSurface.withValues(alpha: 0.4);

      case AppTextVariant.button:
        return context.onPrimaryContainer;

      default:
        return context.onSurface;
    }
  }
}
