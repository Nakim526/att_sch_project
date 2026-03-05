import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/formatter/time_formatter.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_input_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:flutter/material.dart';

class AppTimeInput extends StatefulWidget {
  final TextEditingController controller;
  final String initialValue;
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

  const AppTimeInput({
    super.key,
    required this.controller,
    required this.initialValue,
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
  State<AppTimeInput> createState() => _AppTimeInputState();
}

class _AppTimeInputState extends State<AppTimeInput> {
  TimeOfDay? _selectedTime;
  TimeOfDay? _initialTime;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue.isEmpty) return;

    _initialTime = TimeFormatter.normalize(widget.initialValue);
  }

  Future<void> _selectTime() async {
    final now = TimeOfDay.now();

    final result = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? _initialTime ?? now,
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (result != null && mounted) {
      final selectedTime = result.format(context);

      setState(() {
        widget.onChanged?.call(selectedTime);
        widget.controller.text = selectedTime;
        _selectedTime = result;
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
              icon: Icons.access_time,
              variant: AppButtonVariant.icon,
              onPressed: _selectTime,
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
