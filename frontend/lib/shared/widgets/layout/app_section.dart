import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:flutter/material.dart';

class AppSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final double? borderCircular;
  final EdgeInsets? padding;
  final double? spacing;

  const AppSection({
    super.key,
    this.title,
    required this.children,
    this.borderCircular,
    this.padding,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness == Brightness.dark;

    return Card(
      margin: AppSpacing.none,
      color: context.sectionContainer,
      elevation: AppSize.small,
      clipBehavior: Clip.antiAlias,
      shadowColor:
          isDark
              ? Colors.white.withValues(alpha: 0.16)
              : Colors.black.withValues(alpha: 0.24),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.outline),
        borderRadius: BorderRadius.circular(borderCircular ?? AppSize.small),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderCircular ?? AppSize.small),
        child: Ink(
          child: Container(
            padding: padding ?? AppSpacing.medium,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing ?? AppSize.normal,
              children: [
                if (title != null)
                  AppText(title!, variant: AppTextVariant.subtitle),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
