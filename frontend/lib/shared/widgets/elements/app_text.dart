import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:flutter/material.dart';

enum AppTextVariant {
  body,
  title,
  subtitle,
  h1,
  h2,
  h3,
  h4,
  caption,
  overline,
  link,
  error,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? align;
  final bool underline;
  final TextOverflow? overflow;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.align,
    this.underline = false,
    this.overflow,
  }) : variant = AppTextVariant.body;

  const AppText(
    this.text, {
    super.key,
    required this.variant,
    this.color,
    this.align,
    this.underline = false,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: AppTextStyle.of(
        context,
        variant,
        color: color,
        underline: underline,
      ),
      overflow: _overflow(variant, overflow: overflow),
    );
  }

  static TextOverflow _overflow(
    AppTextVariant variant, {
    TextOverflow? overflow,
  }) {
    if (overflow != null) return overflow;

    switch (variant) {
      case AppTextVariant.body:
      case AppTextVariant.title:
      case AppTextVariant.subtitle:
      case AppTextVariant.h1:
      case AppTextVariant.h2:
      case AppTextVariant.h3:
      case AppTextVariant.h4:
        return TextOverflow.ellipsis;
      default:
        return TextOverflow.visible;
    }
  }
}
