import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/constant/theme/theme_extension.dart';
import 'package:att_school/shared/styles/app_input_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AppDropdownInput extends StatelessWidget {
  final List<dynamic> items;
  final int? value;
  final String? labelText;
  final String? errorText;
  final bool? isError;
  final DropdownSuffixProps? suffixProps;
  final InputDecoration? decoration;
  final BoxConstraints? constraints;
  final bool showSearchBox;
  final MenuAlign? align;
  final BorderRadius? borderRadius;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final Function(dynamic)? onChanged;

  const AppDropdownInput({
    super.key,
    required this.items,
    this.value,
    this.labelText,
    this.errorText,
    this.isError,
    this.suffixProps,
    this.decoration,
    this.constraints,
    this.showSearchBox = true,
    this.align,
    this.borderRadius,
    this.enabledBorder,
    this.focusedBorder,
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
        DropdownSearch<dynamic>(
          items: (f, cs) => items,
          selectedItem: value,

          compareFn: (item1, item2) => item1 == item2,

          decoratorProps: DropDownDecoratorProps(
            decoration:
                decoration ??
                AppInputStyle.dropdown(
                  context,
                  isError: isError ?? false,
                  constraints: constraints,
                  borderRadius: borderRadius,
                ),
            baseStyle: AppTextStyle.of(context, AppTextVariant.body),
          ),
          suffixProps: suffixProps ?? DropdownSuffixProps(),
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
            ),
            itemBuilder: (context, item, isDisabled, isSelected) {
              return Padding(
                padding: AppSpacing.button,
                child: AppText(
                  item == null ? '' : item.toString(),
                  variant: AppTextVariant.body,
                ),
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
