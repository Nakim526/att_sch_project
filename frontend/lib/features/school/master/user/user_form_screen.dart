import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
import 'package:att_school/features/school/master/user/models/user_model.dart';
import 'package:att_school/features/school/master/user/read/detail/presentation/read_user_detail_page.dart';
import 'package:att_school/features/school/master/user/read/detail/provider/read_user_detail_provider.dart';
import 'package:att_school/features/auth/roles/data/roles_model.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/select/app_select_many_input.dart';
import 'package:att_school/shared/widgets/elements/input/text/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(UserModel payload) onSubmit;
  final String? id;
  final UserModel? editData;

  const UserFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownKey = GlobalKey<DropdownSearchState<Map<String, dynamic>>>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roles = AppItems.roles;
  String id = '';
  List<Map<String, dynamic>>? _selectedRoles;
  bool _isTeacher = false;
  bool _errorName = false;
  bool _errorEmail = false;
  bool _errorRoles = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        id = widget.id ?? '';
        final detail = context.read<ReadUserDetailProvider>();

        detail.ready = false;

        _isTeacher = RolesProvider.me.isTeacher;

        if (_isTeacher) id = 'me';

        if (widget.id != null) {
          await detail.fetchById(id);

          if (detail.data != null) {
            final data = detail.data!;
            setState(() {
              _nameController.text = data.name;
              _emailController.text = data.email;
              _selectedRoles = data.roles!.map((e) => e.toMap()).toList();
            });
          }
        }

        detail.ready = true;
      }
    });
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

  dynamic _onChangedRoles(dynamic value) {
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

  Widget get _rolesInput => AppSelectManyInput(
    dropdownKey: _dropdownKey,
    items: _roles,
    labelText: 'Roles',
    errorText: 'Roles Wajib Diisi',
    isError: _errorRoles,
    lockItems: [AppItems.kepsek, AppItems.admin],
    initialValue: _selectedRoles,
    onChanged: _onChangedRoles,
  );

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadUserDetailProvider>();

    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        AppText(widget.title, variant: AppTextVariant.h2),
        AppButton(
          "Save",
          onPressed: () async {
            if (!_validate()) return;

            final List<RolesModel> roles = [];

            for (final selected in _selectedRoles ?? []) {
              roles.add(RolesModel(selected['name']!));
            }

            final result = await widget.onSubmit(
              UserModel(
                id: id,
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
                      builder: (context) => ReadUserDetailPage(id),
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
        if (detail.isReady)
          Form(
            key: _formKey,
            child: AppSection(
              title: 'Hak Akses',
              children: [
                AppTextInput(
                  controller: _nameController,
                  labelText: 'Name',
                  errorText: 'Name Wajib Diisi',
                  isError: _errorName,
                  onChanged: _onChangedName,
                ),
                AppTextInput(
                  controller: _emailController,
                  labelText: 'Email',
                  errorText: 'Email Wajib Diisi',
                  isError: _errorEmail,
                  onChanged: _onChangedEmail,
                ),
                if (!_isTeacher) _rolesInput,
              ],
            ),
          ),
      ],
    );
  }
}
