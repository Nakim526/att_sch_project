import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/shared/styles/app_input_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:flutter/material.dart';

class AppTextInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isError;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final BorderRadius? borderRadius;
  final Widget? prefix;
  final Widget? suffixIcon;
  final int minLines;
  final int? maxLines;
  final bool alignLabelWithHint;
  final void Function(String)? onChanged;

  const AppTextInput({
    super.key,
    required this.controller,
    this.keyboardType,
    this.isError,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.borderRadius,
    this.prefix,
    this.suffixIcon,
    this.minLines = 1,
    this.maxLines,
    this.alignLabelWithHint = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSize.xSmall,
      children: [
        if (labelText != null)
          AppText(labelText!, variant: AppTextVariant.caption),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: AppInputStyle.text(
            context,
            hintText: hintText,
            borderRadius: borderRadius,
            prefixIcon: prefix,
            suffixIcon: suffixIcon,
            isError: isError ?? false,
            minLines: minLines,
          ),
          onChanged: onChanged,
          minLines: minLines,
          maxLines: maxLines,
          textAlignVertical:
              alignLabelWithHint ? TextAlignVertical.center : null,
        ),
        if (errorText != null && isError != null && isError!)
          AppText(errorText!, variant: AppTextVariant.error),
      ],
    );
  }
}
