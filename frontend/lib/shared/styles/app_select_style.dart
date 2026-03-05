import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/utils/extensions/string_extension.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_input_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AppSelectStyle {
  final BuildContext context;

  AppSelectStyle(this.context);

  String toItems(dynamic item, bool isFormatted) {
    if (item == null) return '';
    if (item.toString().isEmail) return item.toString();
    if (item is Map) {
      if (item.isEmpty) return '';
      if (!isFormatted) return item['name'];
      return item['name'].toString().capitalizeEachWord();
    }
    if (!isFormatted) return item;
    return item.toString().capitalizeEachWord();
  }

  DropDownDecoratorProps decoratorProps(
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    bool? isError,
    bool enabled,
  ) {
    return DropDownDecoratorProps(
      baseStyle: AppTextStyle.of(
        context,
        enabled ? AppTextVariant.body : AppTextVariant.caption,
      ),

      decoration: AppInputStyle.dropdown(
        context,
        isError: isError ?? false,
        constraints: constraints,
        borderRadius: borderRadius,
        enabled: enabled,
      ),
    );
  }

  PopupProps popupPropsSingleSelectionMenu(
    bool showSearchBox,
    MenuAlign? align,
    List<dynamic> items,
    int minLines,
    int maxLines,
    bool isFormatted,
  ) {
    return PopupProps.menu(
      menuProps: _menuProps(align, items, showSearchBox),

      emptyBuilder: (context, searchEntry) {
        return _emptyBuilder(context, searchEntry, showSearchBox);
      },

      searchFieldProps: _searchFieldProps(minLines, maxLines),

      itemBuilder: (context, item, isDisabled, isSelected) {
        return _itemBuilder(context, item, isDisabled, isSelected, isFormatted);
      },

      searchDelay: Duration(seconds: 1),
      showSearchBox: showSearchBox,
      fit: FlexFit.loose,
    );
  }

  PopupPropsMultiSelection<Map<String, dynamic>> popupPropsMultiSelectionMenu(
    GlobalKey<DropdownSearchState<Map<String, dynamic>>> key,
    bool showSearchBox,
    MenuAlign? align,
    List<dynamic> items,
    int minLines,
    int maxLines,
    bool isFormatted,
  ) {
    return PopupPropsMultiSelection.menu(
      menuProps: _menuProps(align, items, showSearchBox),

      emptyBuilder: (context, searchEntry) {
        return _emptyBuilder(context, searchEntry, showSearchBox);
      },

      searchFieldProps: _searchFieldProps(minLines, maxLines),

      itemBuilder: (context, item, isDisabled, isSelected) {
        return _itemBuilder(context, item, isDisabled, isSelected, isFormatted);
      },

      validationBuilder: (context, items) {
        return _validationBuilder(key, context, items);
      },

      searchDelay: Duration(seconds: 1),
      showSearchBox: showSearchBox,
      fit: FlexFit.loose,
    );
  }

  MenuProps _menuProps(
    MenuAlign? align,
    List<dynamic>? items,
    bool showSearchBox,
  ) {
    return MenuProps(
      color: context.onError,
      backgroundColor: context.sectionContainer,
      align: align ?? MenuAlign.bottomCenter,
      positionCallback:
          align != null
              ? (dropdownBox, overlay) {
                return _positionCallback(
                  dropdownBox,
                  overlay,
                  items?.length ?? 1,
                  showSearchBox,
                );
              }
              : null,
    );
  }

  RelativeRect _positionCallback(
    RenderBox dropdownBox,
    RenderBox overlay,
    int itemsCount,
    bool showSearchBox,
  ) {
    final dropdownSize = dropdownBox.size;
    final overlaySize = overlay.size;
    final dropdownTopLeft = dropdownBox.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    if (showSearchBox) itemsCount += 1;
    if (itemsCount > 8) itemsCount = 8;
    if (itemsCount < 1) itemsCount = 1;

    return RelativeRect.fromLTRB(
      dropdownTopLeft.dx,
      dropdownTopLeft.dy -
          (dropdownSize.height * itemsCount) -
          (itemsCount * 4),
      overlaySize.width - (dropdownTopLeft.dx + dropdownSize.width),
      overlaySize.height - dropdownTopLeft.dy + (itemsCount * 2),
    );
  }

  Widget _emptyBuilder(
    BuildContext context,
    String searchEntry,
    bool showSearchBox,
  ) {
    return Padding(
      padding: AppSpacing.field,
      child: Stack(
        children: [
          AppText(
            showSearchBox ? 'No results found for "$searchEntry"' : 'No items',
            variant: AppTextVariant.body,
          ),
        ],
      ),
    );
  }

  TextFieldProps _searchFieldProps(int minLines, int maxLines) {
    return TextFieldProps(
      padding: AppSpacing.none,
      cursorColor: context.primary,
      decoration: AppInputStyle.text(context, hintText: 'Search...'),
      style: AppTextStyle.of(context, AppTextVariant.body),
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  Widget _itemBuilder(
    BuildContext context,
    dynamic item,
    bool isDisabled,
    bool isSelected,
    bool isFormatted,
  ) {
    return Padding(
      padding: AppSpacing.normal,
      child: AppText(toItems(item, isFormatted), variant: AppTextVariant.body),
    );
  }

  Widget _validationBuilder(
    GlobalKey<DropdownSearchState<Map<String, dynamic>>> key,
    BuildContext context,
    List<dynamic> items,
  ) {
    final popupState = key.currentState;

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
  }
}
