import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/features/admin/school/models/school_model.dart';
import 'package:att_school/features/admin/school/read/detail/presentation/read_school_detail_page.dart';
import 'package:att_school/features/admin/school/read/detail/provider/read_school_detail_provider.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/text/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchoolFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(SchoolModel data) onSubmit;
  final String? id;
  final SchoolModel? editData;

  const SchoolFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<SchoolFormScreen> createState() => _SchoolFormScreenState();
}

class _SchoolFormScreenState extends State<SchoolFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _principalNameController = TextEditingController();
  final _principalEmailController = TextEditingController();
  bool _errorName = false;
  bool _errorPrincipalName = false;
  bool _errorPrincipalEmail = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final detail = context.read<ReadSchoolDetailProvider>();

        detail.ready = false;

        if (widget.id != null) {
          await detail.fetchById(widget.id!);

          if (detail.error.isNotEmpty) return;

          final detailData = detail.data;

          if (detailData != null) {
            if (!mounted) return;

            setState(() {
              _nameController.text = detailData.name;
              _addressController.text = detailData.address ?? '';
              _phoneController.text = detailData.phone ?? '';
              _emailController.text = detailData.email ?? '';
              _principalNameController.text = detailData.principalName;
              _principalEmailController.text = detailData.principalEmail;
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
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _principalNameController.dispose();
    _principalEmailController.dispose();
    super.dispose();
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  void _onChangedPrincipalName(_) {
    if (_errorPrincipalName) setState(() => _errorPrincipalName = false);
  }

  void _onChangedPrincipalEmail(_) {
    if (_errorPrincipalEmail) setState(() => _errorPrincipalEmail = false);
  }

  bool _validate() {
    setState(() {
      _errorName = _nameController.text.isEmpty;
      _errorPrincipalName = _principalNameController.text.isEmpty;
      _errorPrincipalEmail = _principalEmailController.text.isEmpty;
    });

    return !(_errorName || _errorPrincipalName || _errorPrincipalEmail);
  }

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadSchoolDetailProvider>();

    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        AppText(widget.title, variant: AppTextVariant.h2),
        AppButton(
          "Save",
          onPressed: () async {
            if (!_validate()) return;

            final result = await widget.onSubmit(
              SchoolModel(
                id: widget.id,
                name: _nameController.text.trim(),
                address: _addressController.text.trim(),
                phone: _phoneController.text.trim(),
                email: _emailController.text.trim(),
                principalName: _principalNameController.text.trim(),
                principalEmail: _principalEmailController.text.trim(),
              ),
            );

            if (context.mounted) {
              await AppDialog.show(
                context,
                title: result.status ? 'Success' : 'Error',
                message: result.message,
              );

              if (result.status && context.mounted) {
                String id = result.data['id'];

                if (!RolesProvider.me.isAdmin) id = 'me';

                if (!context.mounted) return;

                if (widget.editData == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ReadSchoolDetailPage(id)),
                  );
                  return;
                }

                Navigator.pop(context);
              }
            }
          },
          variant: AppButtonVariant.primary,
        ),
        if (detail.isReady)
          Form(
            key: _formKey,
            child: Column(
              spacing: AppSize.medium,
              children: [
                AppSection(
                  title: 'Data Sekolah',
                  children: [
                    AppTextInput(
                      controller: _nameController,
                      labelText: 'Nama Sekolah',
                      errorText: 'Nama Sekolah tidak boleh kosong.',
                      isError: _errorName,
                      onChanged: _onChangedName,
                    ),
                    AppTextInput(
                      controller: _addressController,
                      labelText: 'Alamat',
                    ),
                    AppTextInput(
                      controller: _phoneController,
                      labelText: 'Nomor Telepon',
                    ),
                    AppTextInput(
                      controller: _emailController,
                      labelText: 'Email Sekolah',
                    ),
                  ],
                ),
                AppSection(
                  title: 'Kepala Sekolah',
                  children: [
                    AppTextInput(
                      controller: _principalNameController,
                      labelText: 'Nama Kepala Sekolah',
                      errorText: 'Nama Kepala Sekolah tidak boleh kosong.',
                      isError: _errorPrincipalName,
                      onChanged: _onChangedPrincipalName,
                    ),
                    AppTextInput(
                      controller: _principalEmailController,
                      labelText: 'Email Kepala Sekolah',
                      errorText: 'Email Kepala Sekolah tidak boleh kosong.',
                      isError: _errorPrincipalEmail,
                      onChanged: _onChangedPrincipalEmail,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
