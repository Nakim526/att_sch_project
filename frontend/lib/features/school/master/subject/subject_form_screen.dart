import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/subject/models/subject_model.dart';
import 'package:att_school/features/school/master/subject/read/detail/presentation/read_subject_detail_page.dart';
import 'package:att_school/features/school/master/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/field/app_field.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/text/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(SubjectModel data) onSubmit;
  final String? id;
  final SubjectModel? editData;

  const SubjectFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<SubjectFormScreen> createState() => _SubjectFormScreenState();
}

class _SubjectFormScreenState extends State<SubjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  SemesterModel? _semester;
  AcademicYearModel? _academicYear;
  bool _errorCode = false;
  bool _errorName = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final detail = context.read<ReadSubjectDetailProvider>();
        final semester = context.read<ReadSemesterActiveProvider>();

        detail.ready = false;

        await semester.fetchActive();

        if (semester.error.isNotEmpty) return;

        setState(() {
          _semester = semester.data;
          _academicYear = semester.academicYear;
        });

        if (widget.id != null) {
          await detail.fetchById(widget.id!);

          if (detail.data != null) {
            setState(() {
              _codeController.text = detail.data!.code ?? '';
              _nameController.text = detail.data!.name;
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
    _codeController.dispose();
    super.dispose();
  }

  void _onChangedCode(_) {
    if (_errorCode) setState(() => _errorCode = false);
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  bool _validate() {
    setState(() {
      _errorCode = _codeController.text.isEmpty;
      _errorName = _nameController.text.isEmpty;
    });

    return !(_errorCode || _errorName);
  }

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadSubjectDetailProvider>();

    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        AppText(widget.title, variant: AppTextVariant.h2),
        AppButton(
          "Save",
          onPressed: () async {
            if (!_validate()) return;

            final result = await widget.onSubmit(
              SubjectModel(
                id: widget.id,
                code: _codeController.text,
                name: _nameController.text,
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
                      builder: (context) => ReadSubjectDetailPage(id),
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
        if (detail.isReady && _semester != null)
          Form(
            key: _formKey,
            child: AppSection(
              title: 'Mata Pelajaran',
              children: [
                AppTextInput(
                  controller: _codeController,
                  labelText: 'Kode Mata Pelajaran',
                  errorText: 'Kode Mata Pelajaran Wajib Diisi',
                  isError: _errorCode,
                  onChanged: _onChangedCode,
                ),
                AppTextInput(
                  controller: _nameController,
                  labelText: 'Mata Pelajaran',
                  errorText: 'Mata Pelajaran Wajib Diisi',
                  isError: _errorName,
                  onChanged: _onChangedName,
                ),
                AppField('Semester', value: _semester?.name),
                AppField('Tahun Ajaran', value: _academicYear?.name),
              ],
            ),
          ),
      ],
    );
  }
}
