import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/student/models/student_model.dart';
import 'package:att_school/features/admin/student/read/detail/presentation/read_student_detail_page.dart';
import 'package:att_school/features/admin/student/read/detail/provider/read_student_detail_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/app_select_one_input.dart';
import 'package:att_school/shared/widgets/elements/input/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(StudentModel data) onSubmit;
  final String? id;
  final StudentModel? editData;

  const StudentFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisController = TextEditingController();
  final _nisnController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _genders = AppItems.genders;
  String? _selectedGender;
  bool _errorNis = false;
  bool _errorName = false;

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      Future.microtask(() async {
        if (mounted) {
          final detail = context.read<ReadStudentDetailProvider>();

          await detail.fetchById(widget.id!);

          if (detail.student != null) {
            setState(() {
              _nisController.text = detail.student!.nis;
              _nisnController.text = detail.student!.nisn ?? '';
              _nameController.text = detail.student!.name;
              _phoneController.text = detail.student!.phone ?? '';
              _addressController.text = detail.student!.address ?? '';
              _selectedGender = detail.student!.gender;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _nisController.dispose();
    _nisnController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onChangedNis(_) {
    if (_errorNis) setState(() => _errorNis = false);
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  void _onChangedGender(String? value) {
    setState(() => _selectedGender = value);
  }

  bool _validate() {
    setState(() {
      _errorNis = _nisController.text.isEmpty;
      _errorName = _nameController.text.isEmpty;
    });

    if (_errorNis || _errorName) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSize.medium,
          children: [
            AppText(widget.title, variant: AppTextVariant.h2),
            AppButton(
              "Save",
              onPressed: () async {
                if (!_validate()) return;

                final result = await widget.onSubmit(
                  StudentModel(
                    id: widget.editData?.id,
                    nis: _nisController.text,
                    nisn: _nisnController.text,
                    name: _nameController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    gender: _selectedGender,
                  ),
                );

                if (context.mounted) {
                  await AppDialog.show(
                    context,
                    title: result.status ? 'Success' : 'Error',
                    message: result.message,
                  );

                  if (result.status && context.mounted) {
                    if (widget.editData == null) {
                      final id = result.data['id'];
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadStudentDetailPage(id),
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
                      controller: _nisController,
                      labelText: 'NIS',
                      errorText: 'NIS Wajib Diisi',
                      isError: _errorNis,
                      onChanged: _onChangedNis,
                    ),
                    AppTextInput(
                      controller: _nisnController,
                      labelText: 'NISN',
                    ),
                    AppTextInput(
                      controller: _nameController,
                      labelText: 'Nama',
                      errorText: 'Nama Wajib Diisi',
                      isError: _errorName,
                      onChanged: _onChangedName,
                    ),
                    AppSelectOneInput(
                      items: _genders,
                      labelText: 'Gender',
                      initialValue: _selectedGender,
                      onChanged: (value) => _onChangedGender(value),
                    ),
                    AppTextInput(
                      controller: _phoneController,
                      labelText: 'Nomor Telepon',
                    ),
                    AppTextInput(
                      controller: _addressController,
                      labelText: 'Alamat',
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
