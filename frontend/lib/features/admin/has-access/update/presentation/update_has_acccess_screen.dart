import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/has-access/has_access_form_screen.dart';
import 'package:att_school/features/admin/has-access/models/has_access_model.dart';
import 'package:att_school/features/admin/has-access/read/detail/provider/read_has_access_detail_provider.dart';
import 'package:att_school/features/admin/has-access/update/provider/update_has_access_provider.dart';
import 'package:att_school/features/roles/data/roles_model.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateHasAccessScreen extends StatefulWidget {
  final String id;
  const UpdateHasAccessScreen(this.id, {super.key});

  @override
  State<UpdateHasAccessScreen> createState() => _UpdateHasAccessScreenState();
}

class _UpdateHasAccessScreenState extends State<UpdateHasAccessScreen> {
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

    Future.microtask(() async {
      if (mounted) {
        final detail = context.read<ReadHasAccessDetailProvider>();
        await detail.fetchById(widget.id);

        if (detail.hasAccess != null) {
          final data = detail.hasAccess!;
          setState(() {
            _nameController.text = data.name;
            _emailController.text = data.email;
            _selectedRoles = data.roles!.map((e) => e.toJson()).toList();
          });
        }
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
    final provider = context.watch<UpdateHasAccessProvider>();
    final detail = context.watch<ReadHasAccessDetailProvider>();

    return Stack(
      children: [
        AppScreen(
          appBar: AppBar(title: const Text('Update HasAccess')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.xLarge,
              children: [
                AppText("Update HasAccess", variant: AppTextVariant.h2),
                AppButton(
                  "Save",
                  onPressed: () async {
                    if (!_validate()) return;

                    final List<RolesModel> roles = [];

                    for (final selected in _selectedRoles ?? []) {
                      roles.add(RolesModel(role: selected['name']!));
                    }

                    final result = await provider.updateHasAccess(
                      HasAccessModel(
                        id: widget.id,
                        name: _nameController.text,
                        email: _emailController.text,
                        roles: roles,
                      ),
                    );

                    if (context.mounted) {
                      if (result.success) {
                        return Navigator.pop(context);
                      }

                      AppDialog.show(
                        context,
                        title: 'Error',
                        message: result.message,
                      );
                    }
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (detail.hasAccess != null)
                  HasAccessFormScreen(
                    formKey: _formKey,
                    dropdownKey: _dropdownKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    errorName: _errorName,
                    errorRoles: _errorRoles,
                    roles: _roles,
                    selectedRoles: _selectedRoles,
                    onChangedName: _onChangedName,
                    onChangedEmail: _onChangedEmail,
                    onChangedRoles: (value) => _onChangedRoles(value),
                  ),
              ],
            ),
          ],
        ),
        if (provider.isLoading || detail.hasAccess == null || detail.isLoading)
          AppLoading(),
      ],
    );
  }
}
