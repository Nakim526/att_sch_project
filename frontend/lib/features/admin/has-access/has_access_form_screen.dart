import 'package:att_school/shared/widgets/elements/input/app_select_many_input.dart';
import 'package:att_school/shared/widgets/elements/input/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class HasAccessFormScreen extends StatelessWidget {
  final GlobalKey<DropdownSearchState<Map<String, String>>> dropdownKey;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final List<Map<String, String>> roles;
  final List<Map<String, String>>? selectedRoles;
  final void Function(String)? onChangedName;
  final void Function(String)? onChangedEmail;
  final dynamic Function(dynamic)? onChangedRoles;
  final bool? errorName;
  final bool? errorEmail;
  final bool? errorRoles;

  const HasAccessFormScreen({
    super.key,
    required this.dropdownKey,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.roles,
    this.selectedRoles,
    this.onChangedName,
    this.onChangedEmail,
    this.onChangedRoles,
    this.errorName,
    this.errorEmail,
    this.errorRoles,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AppSection(
        children: [
          AppTextInput(
            controller: nameController,
            labelText: 'Name',
            errorText: 'Name is required',
            isError: errorName,
            onChanged: onChangedName,
          ),
          AppTextInput(
            controller: emailController,
            labelText: 'Email',
            errorText: 'Email is required',
            isError: errorEmail,
            onChanged: onChangedEmail,
          ),
          AppSelectManyInput(
            dropdownKey: dropdownKey,
            items: roles,
            labelText: 'Roles',
            errorText: 'Roles is required',
            isError: errorRoles,
            initialValue: selectedRoles,
            showSearchBox: true,
            onChanged: onChangedRoles,
          ),
        ],
      ),
    );
  }
}
