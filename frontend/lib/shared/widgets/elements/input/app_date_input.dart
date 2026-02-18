// import 'package:flutter/material.dart';

// Future<DateTime?> datePicker(
//   BuildContext context, {
//   DateTime? initialDate,
// }) async {
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: initialDate ?? DateTime.now(),
//     firstDate: DateTime.now(),
//     lastDate: DateTime(2100),
//   );

//   if (pickedDate == null) return null;

//   return pickedDate;
// }

import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/formatter/date_formatter.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_input_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:flutter/material.dart';

class AppDateInput extends StatefulWidget {
  final TextEditingController controller;
  final String initialValue;
  final DateTime? startDate;
  final bool? isError;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final BorderRadius? borderRadius;
  final Widget? prefix;
  final Widget? suffixIcon;
  final int minLines;
  final int maxLines;
  final void Function(String)? onChanged;

  const AppDateInput({
    super.key,
    required this.controller,
    required this.initialValue,
    this.startDate,
    this.isError,
    this.labelText,
    this.hintText,
    this.errorText,
    this.borderRadius,
    this.prefix,
    this.suffixIcon,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  State<AppDateInput> createState() => _AppDateInputState();
}

class _AppDateInputState extends State<AppDateInput> {
  DateTime? _selectedDate;
  DateTime? _initialDate;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue.isEmpty) return;

    _initialDate = DateFormatter.fromController(widget.initialValue);
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? _initialDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      final selectedDate = DateFormatter.toController(result);

      setState(() {
        widget.onChanged?.call(selectedDate);
        widget.controller.text = selectedDate;
        _selectedDate = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSize.xSmall,
      children: [
        if (widget.labelText != null)
          AppText(widget.labelText!, variant: AppTextVariant.caption),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.datetime,
                style: AppTextStyle.of(context, AppTextVariant.body),
                decoration: AppInputStyle.text(
                  context,
                  hintText: widget.hintText,
                  borderRadius: widget.borderRadius,
                  prefixIcon: widget.prefix,
                  suffixIcon: widget.suffixIcon,
                  isError: widget.isError ?? false,
                  minLines: widget.minLines,
                ),
                onChanged: widget.onChanged,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
              ),
            ),
            AppButton(
              '',
              icon: Icons.calendar_month,
              variant: AppButtonVariant.icon,
              onPressed: _selectDate,
            ),
          ],
        ),
        if (widget.errorText != null &&
            widget.isError != null &&
            widget.isError!)
          AppText(widget.errorText!, variant: AppTextVariant.error),
      ],
    );
  }
}
