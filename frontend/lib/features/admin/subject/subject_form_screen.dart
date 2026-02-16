import 'package:att_school/shared/widgets/elements/input/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';

class SubjectFormScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final void Function(String)? onChangedName;
  final bool? errorName;

  const SubjectFormScreen({
    super.key,
    required this.formKey,
    required this.nameController,
    this.onChangedName,
    this.errorName,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AppSection(
        children: [
          AppTextInput(
            controller: nameController,
            labelText: 'Subject Name',
            errorText: 'Subject Name is required',
            isError: errorName,
            onChanged: onChangedName,
          ),
        ],
      ),
    );
  }
}
