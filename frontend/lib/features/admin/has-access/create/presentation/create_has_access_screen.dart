import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/has-access/create/provider/create_has_acces_provider.dart';
import 'package:att_school/features/admin/has-access/has_access_form_screen.dart';
import 'package:att_school/features/admin/has-access/models/has_access_model.dart';
import 'package:att_school/features/admin/has-access/read/detail/presentation/read_has_access_detail_page.dart';
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

class CreateHasAccessScreen extends StatefulWidget {
  const CreateHasAccessScreen({super.key});

  @override
  State<CreateHasAccessScreen> createState() => _CreateHasAccessScreenState();
}

class _CreateHasAccessScreenState extends State<CreateHasAccessScreen> {
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
    final provider = context.watch<CreateHasAccessProvider>();

    return Stack(
      children: [
        AppScreen(
          appBar: AppBar(title: const Text('Create Class')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.medium,
              children: [
                AppText("Create Class", variant: AppTextVariant.h2),
                AppButton(
                  "Save",
                  onPressed: () async {
                    if (!_validate()) return;

                    final List<RolesModel> roles = [];

                    for (final selected in _selectedRoles!) {
                      roles.add(RolesModel(role: selected['name']!));
                    }

                    final result = await provider.createHasAccess(
                      HasAccessModel(
                        name: _nameController.text,
                        email: _emailController.text,
                        roles: roles,
                      ),
                    );

                    if (context.mounted) {
                      await AppDialog.show(
                        context,
                        title: result.success ? 'Success' : 'Error',
                        message: result.message,
                      );

                      if (context.mounted && result.success) {
                        final id = result.data['id'];

                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadHasAccessDetailPage(id),
                          ),
                        );
                      }
                    }
                  },
                  variant: AppButtonVariant.primary,
                ),
                HasAccessFormScreen(
                  formKey: _formKey,
                  dropdownKey: _dropdownKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  errorName: _errorName,
                  errorEmail: _errorEmail,
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
        if (provider.isLoading) const AppLoading(),
      ],
    );
  }
}
