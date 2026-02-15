import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final bool underline;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.underline = false,
    this.overflow,
    this.maxLines,
  }) : variant = AppTextVariant.body;

  const AppText(
    this.text, {
    super.key,
    required this.variant,
    this.color,
    this.textAlign,
    this.underline = false,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: AppTextStyle.of(
        context,
        variant,
        color: color,
        underline: underline,
      ),
      maxLines: maxLines,
      overflow: _overflow(variant, overflow: overflow),
    );
  }

  static TextOverflow _overflow(
    AppTextVariant variant, {
    TextOverflow? overflow,
  }) {
    if (overflow != null) return overflow;

    switch (variant) {
      case AppTextVariant.title:
      case AppTextVariant.subtitle:
        return TextOverflow.ellipsis;
      default:
        return TextOverflow.clip;
    }
  }
}
