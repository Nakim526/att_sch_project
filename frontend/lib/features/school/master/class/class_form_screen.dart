import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/class/read/detail/presentation/read_class_detail_page.dart';
import 'package:att_school/features/school/master/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/teacher/read/list/provider/read_teacher_list_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/field/app_field.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/select/app_select_one_input.dart';
import 'package:att_school/shared/widgets/elements/input/text/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(ClassModel data) onSubmit;
  final String? id;
  final ClassModel? editData;

  const ClassFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _grades = AppItems.gradesMap.values.toList();
  final List<Map<String, dynamic>?> _teachers = [null];
  int? _selectedGrade;
  SemesterModel? _semester;
  AcademicYearModel? _academicYear;
  Map<String, dynamic>? _selectedTeacher;
  bool _errorName = false;
  bool _errorGrade = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final detail = context.read<ReadClassDetailProvider>();
        final semester = context.read<ReadSemesterActiveProvider>();
        final teacher = context.read<ReadTeacherListProvider>();

        detail.ready = false;

        await teacher.reload();
        await semester.fetchActive();

        if (semester.error.isNotEmpty) return;

        setState(() {
          _teachers.addAll(teacher.data);
          _semester = semester.data;
          _academicYear = semester.academicYear;
        });

        if (widget.id != null) {
          await detail.fetchById(widget.id!);

          if (detail.data != null) {
            setState(() {
              _nameController.text = detail.data!.name;
              _selectedGrade = detail.data!.grade;
              _selectedTeacher = detail.data!.teacher?.toMap();
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
    super.dispose();
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  dynamic _onChangedGrade(dynamic value) {
    setState(() {
      _selectedGrade = value;
      _errorGrade = false;
    });
  }

  dynamic _onChangedTeacher(dynamic value) {
    setState(() => _selectedTeacher = value);
  }

  bool _validate() {
    setState(() {
      _errorName = _nameController.text.isEmpty;
      _errorGrade = _selectedGrade == null;
    });

    return !(_errorName || _errorGrade);
  }

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadClassDetailProvider>();

    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        AppText(widget.title, variant: AppTextVariant.h2),
        AppButton(
          "Save",
          onPressed: () async {
            if (!_validate()) return;

            final result = await widget.onSubmit(
              ClassModel(
                id: widget.id,
                name: _nameController.text,
                grade: _selectedGrade!,
                academicYearId: _academicYear!.id!,
                teacherId: _selectedTeacher?['id'],
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
                      builder: (context) => ReadClassDetailPage(id),
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
            child: Column(
              spacing: AppSize.medium,
              children: [
                AppSection(
                  title: 'Data Kelas',
                  children: [
                    AppSelectOneInput(
                      items: _grades,
                      labelText: 'Tingkat Kelas',
                      errorText: 'Tingkat Kelas Wajib Diisi',
                      isError: _errorGrade,
                      initialValue: _selectedGrade,
                      onChanged: _onChangedGrade,
                    ),
                    AppTextInput(
                      controller: _nameController,
                      labelText: 'Nama Kelas',
                      errorText: 'Nama Kelas Wajib Diisi',
                      isError: _errorName,
                      onChanged: _onChangedName,
                    ),
                    AppField('Semester', value: _semester?.name),
                    AppField('Tahun Ajaran', value: _academicYear?.name),
                  ],
                ),
                AppSection(
                  title: 'Optional',
                  children: [
                    AppSelectOneInput(
                      items: _teachers,
                      labelText: 'Wali Kelas',
                      initialValue: _selectedTeacher,
                      onChanged: _onChangedTeacher,
                      isFormatted: false,
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
