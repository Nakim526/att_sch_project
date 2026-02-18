import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/shared/widgets/elements/input/app_date_input.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';

class AcademicYearFormScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final void Function(String)? onChangedStartDate;
  final void Function(String)? onChangedEndDate;
  final bool? errorStartDate;
  final bool? errorEndDate;
  final bool errorDate;

  const AcademicYearFormScreen({
    super.key,
    required this.formKey,
    required this.startDateController,
    required this.endDateController,
    this.onChangedStartDate,
    this.onChangedEndDate,
    this.errorStartDate,
    this.errorEndDate,
    required this.errorDate,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AppSection(
        children: [
          AppDateInput(
            controller: startDateController,
            initialValue: startDateController.text,
            labelText: 'Start Date',
            hintText: 'dd/mm/yyyy',
            errorText: 'Start Date is required',
            borderRadius: AppBorderRadius.left(AppSize.xSmall),
            isError: errorStartDate,
            onChanged: onChangedStartDate,
          ),
          AppDateInput(
            controller: endDateController,
            initialValue: endDateController.text,
            labelText: 'End Date',
            hintText: 'dd/mm/yyyy',
            errorText:
                errorDate
                    ? 'End Date must be after Start Date'
                    : 'End Date is required',
            borderRadius: AppBorderRadius.left(AppSize.xSmall),
            isError: errorEndDate,
            onChanged: onChangedEndDate,
          ),
        ],
      ),
    );
  }
}
