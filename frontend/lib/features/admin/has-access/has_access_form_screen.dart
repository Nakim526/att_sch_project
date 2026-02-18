import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/has-access/models/has_access_model.dart';
import 'package:att_school/features/admin/has-access/read/detail/presentation/read_has_access_detail_page.dart';
import 'package:att_school/features/admin/has-access/read/detail/provider/read_has_access_detail_provider.dart';
import 'package:att_school/features/roles/data/roles_model.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/app_select_many_input.dart';
import 'package:att_school/shared/widgets/elements/input/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HasAccessFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(HasAccessModel payload) onSubmit;
  final String? id;
  final HasAccessModel? editData;

  const HasAccessFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<HasAccessFormScreen> createState() => _HasAccessFormScreenState();
}

class _HasAccessFormScreenState extends State<HasAccessFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownKey = GlobalKey<DropdownSearchState<Map<String, String>>>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roles = AppItems.roles;
  List<Map<String, String>>? _selectedRoles;
  bool _errorName = false;
  bool _errorEmail = false;
  bool _errorRoles = false;

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      Future.microtask(() async {
        if (mounted) {
          final detail = context.read<ReadHasAccessDetailProvider>();
          await detail.fetchById(widget.id!);

          if (detail.hasAccess != null) {
            final data = detail.hasAccess!;
            setState(() {
              _nameController.text = data.name;
              _emailController.text = data.email;
              _selectedRoles = data.roles!.map((e) => e.toMap()).toList();
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  void _onChangedEmail(_) {
    if (_errorEmail) setState(() => _errorEmail = false);
  }

  void _onChangedRoles(List<Map<String, String>>? value) {
    setState(() {
      _selectedRoles = value;
      _errorRoles = false;
    });
  }

  bool _validate() {
    setState(() {
      _errorName = _nameController.text.isEmpty;
      _errorEmail = _emailController.text.isEmpty;
      _errorRoles = _selectedRoles == null || _selectedRoles!.isEmpty;
    });

    return !(_errorName || _errorEmail || _errorRoles);
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSize.xLarge,
          children: [
            AppText(widget.title, variant: AppTextVariant.h2),
            AppButton(
              "Save",
              onPressed: () async {
                if (!_validate()) return;

                final List<RolesModel> roles = [];

                for (final selected in _selectedRoles ?? []) {
                  roles.add(RolesModel(role: selected['name']!));
                }

                final result = await widget.onSubmit(
                  HasAccessModel(
                    id: widget.id,
                    name: _nameController.text,
                    email: _emailController.text,
                    roles: roles,
                  ),
                );

                if (context.mounted) {
                  await AppDialog.show(
                    context,
                    title: result.status ? 'Success' : 'Error',
                    message: result.message,
                  );

                  if (context.mounted && result.status) {
                    if (widget.editData == null) {
                      final id = result.data['id'];
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadHasAccessDetailPage(id),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  }
                }
              },
              variant: AppButtonVariant.primary,
            ),
            if (widget.id == null ||
                (widget.id != null && widget.editData != null))
              Form(
                key: _formKey,
                child: AppSection(
                  children: [
                    AppTextInput(
                      controller: _nameController,
                      labelText: 'Name',
                      errorText: 'Name is required',
                      isError: _errorName,
                      onChanged: _onChangedName,
                    ),
                    AppTextInput(
                      controller: _emailController,
                      labelText: 'Email',
                      errorText: 'Email is required',
                      isError: _errorEmail,
                      onChanged: _onChangedEmail,
                    ),
                    AppSelectManyInput(
                      dropdownKey: _dropdownKey,
                      items: _roles,
                      labelText: 'Roles',
                      errorText: 'Roles is required',
                      isError: _errorRoles,
                      initialValue: _selectedRoles,
                      showSearchBox: true,
                      onChanged: (value) => _onChangedRoles(value),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
