import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/shared/styles/app_select_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AppSelectOneInput extends StatelessWidget {
  final List<dynamic>? items;
  final dynamic initialValue;
  final String? labelText;
  final String? errorText;
  final bool? isError;
  final DropdownSuffixProps? suffixProps;
  final InputDecoration? decoration;
  final BoxConstraints? constraints;
  final bool showSearchBox;
  final BorderRadius? borderRadius;
  final Function(dynamic value) onChanged;
  final MenuAlign? align;
  final int minLines;
  final int maxLines;
  final bool isFormatted;
  final bool enabled;

  const AppSelectOneInput({
    super.key,
    required this.items,
    this.initialValue,
    this.labelText,
    this.errorText,
    this.isError,
    this.suffixProps,
    this.decoration,
    this.constraints,
    this.showSearchBox = false,
    this.borderRadius,
    required this.onChanged,
    this.align,
    this.minLines = 1,
    this.maxLines = 1,
    this.isFormatted = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppSelectStyle(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSize.xSmall,
      children: [
        if (labelText != null)
          AppText(labelText!, variant: AppTextVariant.caption),
        DropdownSearch<dynamic>(
          items: (f, cs) => items ?? [],
          selectedItem: initialValue,

          compareFn: (item, selected) => item == selected,

          itemAsString: (item) => style.toItems(item, isFormatted),

          enabled: enabled,

          decoratorProps: style.decoratorProps(
            constraints,
            borderRadius,
            isError,
            enabled,
          ),

          popupProps: style.popupPropsSingleSelectionMenu(
            showSearchBox,
            align,
            items ?? [],
            minLines,
            maxLines,
            isFormatted,
          ),

          onChanged: onChanged,
        ),
        if (errorText != null && isError!)
          AppText(errorText!, variant: AppTextVariant.error),
      ],
    );
  }
}
