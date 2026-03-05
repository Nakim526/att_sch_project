import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/shared/styles/app_select_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AppSelectManyInput extends StatelessWidget {
  final GlobalKey<DropdownSearchState<Map<String, dynamic>>> dropdownKey;
  final List<Map<String, dynamic>>? items;
  final List<Map<String, dynamic>>? initialValue;
  final String? labelText;
  final String? errorText;
  final bool? isError;
  final DropdownSuffixProps? suffixProps;
  final BoxConstraints? constraints;
  final bool showSearchBox;
  final BorderRadius? borderRadius;
  final Function(dynamic)? onChanged;
  final MenuAlign? align;
  final int minLines;
  final int maxLines;
  final bool isFormatted;
  final bool enabled;
  final List<Map<String, dynamic>>? lockItems;

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
    this.showSearchBox = false,
    this.borderRadius,
    this.onChanged,
    this.align,
    this.minLines = 1,
    this.maxLines = 1,
    this.isFormatted = true,
    this.enabled = true,
    this.lockItems,
  });

  bool _isLocked(Map<String, dynamic> item) {
    if (lockItems == null) return false;
    return lockItems!.any((e) => e['id'] == item['id']);
  }

  List<Widget> _dropdownBuildSelectedItems(
    BuildContext context,
    List<Map<String, dynamic>> selectedItems,
    AppSelectStyle style,
  ) {
    return selectedItems.map((item) {
      final locked = _isLocked(item);

      return Container(
        padding: AppSpacing.items,
        decoration: BoxDecoration(
          color: context.outline,
          borderRadius: AppBorderRadius.small,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            if (locked) return;
            dropdownKey.currentState?.removeItem(item);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSize.xSmall,
            children: [
              Flexible(
                child: AppText(
                  style.toItems(item, isFormatted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  variant: AppTextVariant.input,
                ),
              ),
              if (!locked) Icon(Icons.close, size: AppSize.normal),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final style = AppSelectStyle(context);
    final initialNull = [
      {'id': '', 'name': ''},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSize.xSmall,
      children: [
        if (labelText != null)
          AppText(labelText!, variant: AppTextVariant.caption),
        DropdownSearch<Map<String, dynamic>>.multiSelection(
          key: dropdownKey,

          items: (f, cs) => items ?? initialNull,
          selectedItems: initialValue ?? [],

          compareFn: (item, selected) => item['id'] == selected['id'],

          itemAsString: (item) => style.toItems(item, isFormatted),

          enabled: enabled,

          decoratorProps: style.decoratorProps(
            constraints,
            borderRadius,
            isError,
            enabled,
          ),

          dropdownBuilder: (context, selectedItems) {
            if (selectedItems.isEmpty) {
              return const SizedBox.shrink();
            }

            return Wrap(
              spacing: AppSize.xSmall,
              runSpacing: AppSize.xSmall,
              children: _dropdownBuildSelectedItems(
                context,
                selectedItems,
                style,
              ),
            );
          },

          popupProps: style.popupPropsMultiSelectionMenu(
            dropdownKey,
            showSearchBox,
            align,
            items ?? initialNull,
            minLines,
            maxLines,
            isFormatted,
          ),

          onChanged: (value) => onChanged!(value),
        ),
        if (errorText != null && isError!)
          AppText(errorText!, variant: AppTextVariant.error),
      ],
    );
  }
}
