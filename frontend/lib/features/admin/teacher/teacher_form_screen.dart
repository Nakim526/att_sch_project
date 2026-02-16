import 'package:att_school/shared/widgets/elements/input/app_select_one_input.dart';
import 'package:att_school/shared/widgets/elements/input/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class TeacherFormScreen extends StatelessWidget {
  final GlobalKey<DropdownSearchState<Map<String, String>>> dropdownKey;
  final GlobalKey<FormState> formKey;
  final TextEditingController nipController;
  final TextEditingController nameController;
  final String? selectedEmail;
  final List<dynamic> emails;
  final void Function(String)? onChangedNip;
  final void Function(String)? onChangedName;
  final dynamic Function(dynamic)? onChangedEmail;
  final bool? errorNip;
  final bool? errorName;
  final bool? errorEmail;

  const TeacherFormScreen({
    super.key,
    required this.dropdownKey,
    required this.formKey,
    required this.nipController,
    required this.nameController,
    required this.emails,
    this.selectedEmail,
    this.onChangedNip,
    this.onChangedName,
    this.onChangedEmail,
    this.errorNip,
    this.errorName,
    this.errorEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AppSection(
        children: [
          AppSelectOneInput(
            items: emails,
            labelText: 'Email',
            errorText: 'Email is required',
            isError: errorEmail,
            initialValue: selectedEmail,
            onChanged: onChangedEmail,
            showSearchBox: true,
          ),
          AppTextInput(
            controller: nameController,
            labelText: 'Name',
            errorText: 'Name is required',
            isError: errorName,
            onChanged: onChangedName,
          ),
          AppTextInput(
            controller: nipController,
            labelText: 'Nip',
            errorText: 'Nip is required',
            isError: errorNip,
            onChanged: onChangedNip,
          ),
        ],
      ),
    );
  }
}
