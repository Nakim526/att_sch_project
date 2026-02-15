import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/core/utils/extensions/string_extension.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_input_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AppSelectManyInput extends StatelessWidget {
  final GlobalKey<DropdownSearchState<Map<String, String>>> dropdownKey;
  final List<Map<String, String>>? items;
  final List<Map<String, String>>? initialValue;
  final String? labelText;
  final String? errorText;
  final bool? isError;
  final DropdownSuffixProps? suffixProps;
  final BoxConstraints? constraints;
  final bool showSearchBox;
  final BorderRadius? borderRadius;
  final Function(dynamic)? onChanged;

  const AppSelectManyInput({
    super.key,
    required this.dropdownKey,
    required this.items,
    this.initialValue,
    this.labelText,
    this.errorText,
    this.isError,
    this.suffixProps,
    this.constraints,
    this.showSearchBox = true,
    this.borderRadius,
    this.onChanged,
  });

  List<Widget> _dropdownBuildSelectedItems(
    BuildContext context,
    List<Map<String, String>> selectedItems,
  ) {
    return selectedItems.map((item) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.small,
          vertical: AppSize.xSmall,
        ), // 👈 super kecil
        decoration: BoxDecoration(
          color: context.outline,
          borderRadius: AppBorderRadius.small,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            // ✅ API RESMI
            dropdownKey.currentState?.removeItem(item);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSize.xSmall,
            children: [
              Flexible(
                child: AppText(
                  item['name']?.capitalizeEachWord() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  variant: AppTextVariant.input,
                ),
              ),
              Icon(Icons.close, size: 12),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final initialNull = {'id': '', 'name': ''};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSize.xSmall,
      children: [
        if (labelText != null)
          AppText(labelText!, variant: AppTextVariant.caption),
        DropdownSearch<Map<String, String>>.multiSelection(
          key: dropdownKey,
          items: (f, cs) => items ?? [initialNull],
          selectedItems: initialValue ?? [],
          itemAsString: (item) => item['name'] ?? '',
          compareFn: (item, selected) => item['id'] == selected['id'],

          decoratorProps: DropDownDecoratorProps(
            decoration: AppInputStyle.dropdown(
              context,
              isError: isError ?? false,
              constraints: BoxConstraints(
                maxHeight: constraints?.maxHeight ?? double.infinity,
              ),
              padding: AppSpacing.small,
              borderRadius: borderRadius,
            ),
            baseStyle: AppTextStyle.of(context, AppTextVariant.body),
          ),

          dropdownBuilder: (context, selectedItems) {
            if (selectedItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return Wrap(
              spacing: AppSize.xSmall, // jarak horizontal antar chip
              runSpacing: AppSize.xSmall, // jarak vertikal
              children: _dropdownBuildSelectedItems(context, selectedItems),
            );
          },

          popupProps: PopupPropsMultiSelection.menu(
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
                  item['name']?.capitalizeEachWord() ?? '',
                  variant: AppTextVariant.body,
                ),
              );
            },

            validationBuilder: (context, selectedItems) {
              final popupState = dropdownKey.currentState;
              return Padding(
                padding: AppSpacing.button,
                child: Row(
                  spacing: AppSize.small,
                  children: [
                    Spacer(),
                    AppButton(
                      'Batal',
                      variant: AppButtonVariant.secondary,
                      onPressed: () {
                        popupState?.closeDropDownSearch();
                      },
                    ),
                    AppButton(
                      'OK',
                      variant: AppButtonVariant.primary,
                      onPressed: () {
                        popupState?.popupOnValidate();
                      },
                    ),
                  ],
                ),
              );
            },

            searchDelay: Duration(seconds: 1),
            showSearchBox: showSearchBox,
            fit: FlexFit.loose,
          ),

          onChanged: (value) => onChanged!(value),
        ),
        if (errorText != null && isError!)
          AppText(errorText!, variant: AppTextVariant.error),
      ],
    );
  }
}
