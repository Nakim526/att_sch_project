import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/utils/extensions/string_extension.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/styles/app_input_style.dart';
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
  final Function(dynamic)? onChanged;
  final int minLines;
  final int maxLines;

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
    this.onChanged,
    this.minLines = 1,
    this.maxLines = 1,
  });

  String _toString(dynamic item) {
    if (item == null) return '';
    if (item is Map) return item['name'];
    if (item.toString().isEmail) return item.toString();
    return item.toString().capitalizeEachWord();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSize.xSmall,
      children: [
        if (labelText != null)
          AppText(labelText!, variant: AppTextVariant.caption),
        DropdownSearch<dynamic>(
          items: (f, cs) => items ?? [null],
          selectedItem: initialValue,
          compareFn: (item1, item2) => item1 == item2,
          itemAsString: (item) => _toString(item),

          decoratorProps: DropDownDecoratorProps(
            decoration: AppInputStyle.dropdown(
              context,
              isError: isError ?? false,
              constraints: constraints,
              borderRadius: borderRadius,
            ),
            baseStyle: AppTextStyle.of(context, AppTextVariant.body),
          ),

          popupProps: PopupProps.menu(
            menuProps: MenuProps(
              color: context.onError,
              backgroundColor: context.sectionContainer,
            ),

            emptyBuilder: (context, searchEntry) {
              return Padding(
                padding: AppSpacing.button,
                child: AppText(
                  'No results found for "$searchEntry"',
                  variant: AppTextVariant.body,
                ),
              );
            },

            searchFieldProps: TextFieldProps(
              padding: AppSpacing.none,
              cursorColor: context.onPrimary,
              decoration: AppInputStyle.text(context, hintText: 'Search...'),
              style: AppTextStyle.of(context, AppTextVariant.body),
              minLines: minLines,
              maxLines: maxLines,
            ),

            itemBuilder: (context, item, isDisabled, isSelected) {
              return Padding(
                padding: AppSpacing.normal,
                child: AppText(_toString(item), variant: AppTextVariant.body),
              );
            },

            searchDelay: Duration(seconds: 1),
            showSearchBox: showSearchBox,
            fit: FlexFit.loose,
          ),
          onChanged: onChanged,
        ),
        if (errorText != null && isError!)
          AppText(errorText!, variant: AppTextVariant.error),
      ],
    );
  }
}
