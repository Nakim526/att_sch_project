import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/constant/theme/theme_extension.dart';
import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double? borderCircular;
  final VoidCallback onTap;
  final Widget child;

  const AppTile({
    super.key,
    this.padding,
    this.borderCircular,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness == Brightness.dark;

    return Card(
      color: context.primaryContainer,
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
        onTap: onTap,
        child: Ink(
          child: Padding(padding: padding ?? AppSpacing.medium, child: child),
        ),
      ),
    );
  }
}
