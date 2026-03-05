import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';

class AppManyInput extends StatelessWidget {
  final int itemsCount;
  final String label;
  final VoidCallback onAdd;
  final Function(int index) onRemove;
  final List<Widget> Function(int index) buildChild;

  const AppManyInput({
    super.key,
    required this.label,
    required this.itemsCount,
    required this.onAdd,
    required this.onRemove,
    required this.buildChild,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSize.medium,
      children: [
        for (int i = 0; i < itemsCount; i++) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.normal,
              children: [
                Expanded(
                  child: AppSection(
                    title: '$label ${i + 1}',
                    spacing: AppSize.normal,
                    children: buildChild(i),
                  ),
                ),
                if (itemsCount > 1)
                  AppButton(
                    '',
                    icon: Icons.close,
                    variant: AppButtonVariant.icon,
                    onPressed: () => onRemove(i),
                    borderRadius: AppBorderRadius.xSmall,
                  ),
              ],
            ),
          ),
        ],
        AppButton(
          '+ $label',
          // icon: Icons.add,
          variant: AppButtonVariant.tertiary,
          onPressed: onAdd,
          borderRadius: AppBorderRadius.xSmall,
        ),
      ],
    );
  }
}
