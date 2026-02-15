import 'package:att_school/shared/widgets/elements/input/app_dropdown_input.dart';
import 'package:att_school/shared/widgets/elements/input/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';

class ClassFormScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final List grades;
  final int? selectedGrade;
  final void Function(String)? onChangedName;
  final dynamic Function(dynamic)? onChangedGrade;
  final bool? errorName;
  final bool? errorGrade;

  const ClassFormScreen({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.grades,
    this.selectedGrade,
    this.onChangedName,
    this.onChangedGrade,
    this.errorName,
    this.errorGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AppSection(
        children: [
          AppDropdownInput(
            items: grades,
            labelText: 'Grade',
            errorText: 'Grade is required',
            isError: errorGrade,
            value: selectedGrade,
            onChanged: onChangedGrade,
          ),
          AppTextInput(
            controller: nameController,
            labelText: 'Class Name',
            errorText: 'Class Name is required',
            isError: errorName,
            onChanged: onChangedName,
          ),
        ],
      ),
    );
  }
}
